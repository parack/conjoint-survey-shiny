library(shiny)
library(shinyjs)
library(bslib)
library(googlesheets4)
source("translations.R")   # TR list: IT / EN / FR

gs4_auth(path = "service_account.json")

SHEET_ID <- "1yAQKJ9NlYTkS5zoA4hjEa8NgmH3oHzErHHnT3Upt-Yg"
N_TASKS  <- 12L
N_ALTS   <- 3L

# ── Attribute prices (levels text are now in TR[[lang]]$A1 / A2 / A3) ─────────
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

# ── GAAIS-10 Short version ─────────────────────────────────────────────────────
# Schepman & Rodway (2025); Italian validation: Cicero et al. (2025)
# Item texts are in TR[[lang]]$gaais; direction used only for scoring.
GAAIS_ITEMS <- data.frame(
  code      = c("ShortPos01","ShortNeg06","ShortNeg07","ShortNeg08",
                "ShortPos02","ShortPos03","ShortPos04","ShortPos05",
                "ShortNeg09","ShortNeg10"),
  direction = c("pos","neg","neg","neg","pos","pos","pos","pos","neg","neg"),
  stringsAsFactors = FALSE
)

# ── Proxy items (P1–P6: sonic engagement / algorithmic autonomy / block) ───────
# Item texts are in TR[[lang]]$proxy.
PROXY_ITEMS <- data.frame(
  code     = c("proxy_p1","proxy_p2","proxy_p3","proxy_p4","proxy_p5","proxy_p6"),
  subscale = c("engagement","engagement","engagement","autonomy","autonomy","block"),
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

# Choice label vectors are now per-language in TR[[lang]]:
#   lik5, lik5p, freq_opts, bg_opts, fam_opts, aware_opts, audio_ch

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
