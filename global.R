library(shiny)
library(shinyjs)
library(bslib)
library(googlesheets4)

# Locate .secrets whether running from project root or a git worktree subfolder
.secrets_path <- Reduce(
  function(p, i) if (dir.exists(file.path(p, ".secrets"))) file.path(p, ".secrets") else dirname(p),
  seq_len(5), init = getwd()
)
if (!dir.exists(.secrets_path)) .secrets_path <- ".secrets"
gs4_auth(cache = .secrets_path, email = "lorenzo.paravano@gmail.com")

SHEET_ID <- "1yAQKJ9NlYTkS5zoA4hjEa8NgmH3oHzErHHnT3Upt-Yg"
N_TASKS  <- 12L
N_ALTS   <- 3L

# ── Attribute level descriptions ──────────────────────────────────────────────
A1_LEVELS <- c(
  L1 = "Nessuna label AI visibile (solo metadata interni, non accessibili agli utenti)",
  L2 = "Label AI volontaria (visibile solo se dichiarata dal distributore all'upload)",
  L3 = "Label AI obbligatoria (garantita dalla piattaforma, indipendente dall'artista)"
)
A2_LEVELS <- c(
  L1 = "Musica AI non inclusa nelle playlist raccomandate",
  L2 = "Musica AI nelle playlist raccomandate e generaliste",
  L3 = "Musica AI nelle playlist raccomandate + spazio dedicato AI aggiuntivo"
)
A3_LEVELS <- c(
  L1 = "Nessun controllo utente sulla musica AI",
  L2 = "Filtro parziale: esclusione musica AI dalle playlist personalizzate",
  L3 = "Filtro completo: blocco totale della musica AI dalla piattaforma"
)
A4_PRICES <- c(9.99, 11.99, 13.99)

# ── CBC design generator ──────────────────────────────────────────────────────
# 3×3×3×3 = 81 profiles, minus 9 prohibited [A1=L1, A2=L3] = 72 valid
# Random draw per respondent; no profile repeated within a task
generate_cbc_design <- function(n_tasks = N_TASKS, n_alts = N_ALTS) {
  full  <- expand.grid(a1 = 1:3, a2 = 1:3, a3 = 1:3, a4 = 1:3, stringsAsFactors = FALSE)
  valid <- full[!(full$a1 == 1L & full$a2 == 3L), ]
  rownames(valid) <- NULL

  tasks <- vector("list", n_tasks)
  for (t in seq_len(n_tasks)) {
    repeat {
      idx  <- sample(nrow(valid), n_alts, replace = FALSE)
      prof <- valid[idx, ]
      rownames(prof) <- NULL
      if (nrow(unique(prof)) == n_alts) { tasks[[t]] <- prof; break }
    }
  }
  tasks
}

# ── GAAIS-10 Short version (Italian translation) ──────────────────────────────
# Schepman & Rodway (2025); Italian validation: Cicero et al. (2025)
# Positive items scored 1-5; Negative items reverse-scored (6 - raw)
GAAIS_ITEMS <- data.frame(
  code = c(
    "ShortPos01","ShortNeg06","ShortNeg07","ShortNeg08",
    "ShortPos02","ShortPos03","ShortPos04","ShortPos05",
    "ShortNeg09","ShortNeg10"
  ),
  text = c(
    "Sono interessato/a a utilizzare sistemi di intelligenza artificiale nella mia vita quotidiana.",
    "Trovo l'intelligenza artificiale inquietante.",
    "L'intelligenza artificiale potrebbe prendere il controllo delle persone.",
    "Penso che l'intelligenza artificiale sia pericolosa.",
    "L'intelligenza artificiale può avere un impatto positivo sul benessere delle persone.",
    "L'intelligenza artificiale è entusiasmante.",
    "Gran parte della società beneficerà di un futuro ricco di intelligenza artificiale.",
    "Vorrei utilizzare l'intelligenza artificiale nel mio lavoro.",
    "Rabbrividisco di disagio quando penso ai futuri utilizzi dell'intelligenza artificiale.",
    "Persone come me soffriranno se l'intelligenza artificiale verrà utilizzata sempre di più."
  ),
  direction = c("pos","neg","neg","neg","pos","pos","pos","pos","neg","neg"),
  stringsAsFactors = FALSE
)

# ── Proxy DSP-actionable items (6 items Likert 1-7) ──────────────────────────
# 3 proxy-D (sonic discrimination) + 3 proxy-GAAIS_neg (semantic resistance)
PROXY_ITEMS <- data.frame(
  code = c("proxy_d1","proxy_d2","proxy_d3","proxy_gneg1","proxy_gneg2","proxy_gneg3"),
  text = c(
    "Riesco a distinguere la musica creata dall'intelligenza artificiale da quella suonata da musicisti umani.",
    "Percepisco differenze nella qualità emotiva tra musica AI e musica umana.",
    "Mi accorgo quando una canzone è stata generata artificialmente.",
    "Sono preoccupato/a per l'impatto dell'intelligenza artificiale sull'industria musicale.",
    "Preferisco ascoltare musica creata esclusivamente da musicisti umani.",
    "Ritengo che la musica generata dall'AI non possa eguagliare quella umana sul piano emotivo."
  ),
  subscale = c("d","d","d","gaais_neg","gaais_neg","gaais_neg"),
  stringsAsFactors = FALSE
)

# ── Audio clips metadata ──────────────────────────────────────────────────────
# Place actual MP3 files in www/audio/ before deployment
AUDIO_CLIPS <- data.frame(
  id   = paste0("clip", 1:4),
  file = c(
    "audio/clip_ai_1.mp3",
    "audio/clip_ai_2.mp3",
    "audio/clip_human_1.mp3",
    "audio/clip_human_2.mp3"
  ),
  type = c("AI","AI","human","human"),
  stringsAsFactors = FALSE
)

# ── Likert choice vectors ─────────────────────────────────────────────────────
LIKERT5_CHOICES <- setNames(as.character(1:5),
  c("Fortemente in disaccordo","In disaccordo","Neutrale","D'accordo","Fortemente d'accordo"))

LIKERT7_CHOICES <- setNames(as.character(1:7),
  c("1","2","3","4","5","6","7"))

AUDIO_CHOICES <- setNames(as.character(1:5),
  c("Sicuramente umana","Probabilmente umana","Probabilmente AI","Sicuramente AI","Non so"))

# ── Scoring functions ─────────────────────────────────────────────────────────

# D = mean(ratings_AI_clips) - mean(ratings_human_clips)
# "Non so" (5) recoded to maximally wrong: 1 for AI clips, 4 for human clips
compute_d_index <- function(ratings, clip_types) {
  r <- mapply(function(val, type) {
    if (val == 5L) { if (type == "AI") 1L else 4L } else val
  }, as.integer(ratings), clip_types)
  mean(r[clip_types == "AI"]) - mean(r[clip_types == "human"])
}

# Positive items: raw score; Negative items: 6 - raw (reverse coded)
# Returns list: pos (mean positive subscale), neg (mean negative subscale), raw (all scored)
score_gaais <- function(responses) {
  dirs   <- GAAIS_ITEMS$direction
  scored <- mapply(function(r, d) if (d == "neg") 6L - as.integer(r) else as.integer(r),
                   responses, dirs)
  list(
    pos = mean(scored[dirs == "pos"]),
    neg = mean(scored[dirs == "neg"]),
    raw = scored
  )
}
