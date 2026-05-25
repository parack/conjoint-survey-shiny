library(googlesheets4)
library(dplyr)
library(ggplot2)

# ── Config ────────────────────────────────────────────────────────────────────
SHEET_ID    <- "1oVruAANYslwX066U3YcqhCYJd5Mxol1fBe0A-J9XlsY"
PRETEST_DIR <- "C:/Users/loren/Desktop/Audio_Pretest"
AUTH_PATH   <- file.path(PRETEST_DIR, "service_account.json")
META_PATH   <- file.path(PRETEST_DIR, "clips_metadata.csv")
OUT_STATS   <- file.path(PRETEST_DIR, "clip_stats_results.csv")
OUT_ANON    <- file.path(PRETEST_DIR, "responses_anonymized.csv")
OUT_PLOT    <- file.path(PRETEST_DIR, "detection_rate_plot.png")
OUT_DASH    <- file.path(PRETEST_DIR, "dashboard.png")

# Due fonti dati:
#  - "Responses"           = pretest originale (20 clip per partecipante, ~7 partecipanti)
#  - "Responses_Short_EN"  = nuova app EN (10 clip per sessione, recruiting Reddit)
# Tab "Responses_Short" (IT) NON viene usata.
TAB_FULL  <- "Responses"
TAB_SHORT <- "Responses_Short_EN"

# ══════════════════════════════════════════════════════════════════════════════
# CRITERI PRE-SPECIFICATI (preregistration)
# Documentare nella tesi sezione "metodologia di selezione clip".
# Dichiarati PRIMA di vedere risultati su N completo. Non aggiustare post-hoc.
# ══════════════════════════════════════════════════════════════════════════════

# Familiarity criterion: DROPPED (la nuova app non lo raccoglie).
MAX_NONSO_PCT    <- 0.50    # scarta partecipanti con > 50% "Non so"
MIN_DURATION_SEC <- 10L     # scarta sessioni-bot dalla tab Short

# Livello 1 — Hard requirements (gate filter)
# Una clip deve soddisfare TUTTI per essere candidata.
GATE_N_MIN              <- 30      # minimo N per stime stabili (SE pct_correct < 0.10)
GATE_NONSO_MAX          <- 0.15    # clip decidibile (non troppi "don't know")
GATE_CORRECT_MIN        <- 0.30    # esclude floor effect
GATE_CORRECT_MAX        <- 0.70    # esclude ceiling effect (abbassato: >0.70 → varianza D crolla)

# Livello 2 — Composite informativeness score
# Obiettivo: massimizzare la DISCRIMINAZIONE tra chi sa distinguere AI da chi
# no, per il D-index del sondaggio finale.
# Indicatori:
#   a) r_item_D_weighted * sign_align — correlazione continua rating vs D-index,
#                                       tutti i partecipanti pesati per (1-pct_correct)
#   b) Δ_rating_aligned               — gap continuo mean_rating expert-casual, sign-aligned
#   c) sd_rating_casual               — spread continuo rating tra i casual
W_ITEM_D_W   <- 2.0   # r_item_D_weighted * sign_align: tutti i part., peso (1-pct_correct) ⭐
W_DELTA_R    <- 1.0   # Δ_rating_aligned: gap continuo expert-casual, sign-aligned ⭐
W_SD_CASUAL  <- 0.4   # sd_rating tra i casual (spread continuo, sanity check)
W_MEAN_CENTR <- 0.0   # NON rilevante per il D-index

# Cluster expert (AI-aware) vs casual (audience generale)
EXPERT_SOURCES <- c("short_en_reddit_sunoai",
                    "short_en_reddit_aimusic",
                    "short_en_share")          # condivisioni dirette = AI-aware
CASUAL_SOURCES <- c("short_en_reddit_surveyexchange",
                    "short_en_reddit_samplesize",
                    "short_en_direct",
                    "short_en_reddit_takemysurvey",
                    "short_en_reddit_generativeai",
                    "short_en_reddit_musiccognition",
                    "pretest_full",             # friends/family, non AI-aware
                    "short_en_reddit_askmusicians",
                    "short_en_reddit_teenagers")

# Target ranges per gli indicatori secondari (per scoring continuo)
SD_OPTIMUM      <- 1.0     # sd_rating ottimale; penalità lineare crescendo
MEAN_OPTIMUM    <- 2.5     # mean_rating ottimale (scala 1–4)
MEAN_HALF_RANGE <- 1.5     # entro ±1.5 = nessuna penalità totale

# Filtro a livello partecipante (low engagement)
MIN_LISTENED_CLIPS <- 7    # partecipante deve aver ascoltato ≥7/10 clip (solo Short)

# ── Auth + carica dati ────────────────────────────────────────────────────────
gs4_auth(path = AUTH_PATH)

# Tab originale: username, familiar, lang — niente duration/source.
full_raw <- read_sheet(SHEET_ID, sheet = TAB_FULL) |>
  mutate(
    participant_id_raw = as.character(username),
    points       = as.integer(points),
    correct      = as.logical(correct),
    familiar     = as.logical(familiar),
    nonso        = as.logical(nonso),
    rating       = as.integer(rating),
    self_ability = as.integer(self_ability),
    source       = "pretest_full",   # marcatore di provenienza dataset
    duration_sec = NA_integer_       # non raccolto in questa tab
  ) |>
  select(participant_id_raw, clip_id, clip_type, position, rating, nonso,
         familiar, points, correct, self_ability, source, duration_sec)

# Tab nuova EN: session_id, duration_sec, play_count, source UTM — niente familiar.
short_raw <- read_sheet(SHEET_ID, sheet = TAB_SHORT) |>
  mutate(
    participant_id_raw = as.character(session_id),
    points       = as.integer(points),
    correct      = as.logical(correct),
    familiar     = NA,                # non raccolto in questa tab
    nonso        = as.logical(nonso),
    rating       = as.integer(rating),
    self_ability = as.integer(self_ability),
    duration_sec = suppressWarnings(as.integer(duration_sec)),
    play_count   = suppressWarnings(as.integer(play_count)),
    source       = ifelse(is.na(source) | source == "", "short_en_direct",
                          paste0("short_en_", source))
  ) |>
  select(participant_id_raw, clip_id, clip_type, position, rating, nonso,
         familiar, points, correct, self_ability, source, duration_sec,
         play_count)

# ── Filtro qualità sulla tab Short ────────────────────────────────────────────
# 1) Scarta sessioni-bot intere (duration < soglia)
bot_ids <- short_raw |>
  filter(!is.na(duration_sec), duration_sec < MIN_DURATION_SEC) |>
  pull(participant_id_raw) |> unique()

cat("── Filtro qualità (Responses_Short_EN) ──────────────\n")
cat("Sessioni scartate (duration <", MIN_DURATION_SEC, "s):", length(bot_ids), "\n")
if (length(bot_ids) > 0) cat("  ids:", paste(bot_ids, collapse = ", "), "\n")

short_raw <- short_raw |> filter(!participant_id_raw %in% bot_ids)

# 2) Scarta singoli rating senza ascolto (play_count == 0)
#    Mantiene il resto della sessione: la persona è ok, ma quella specifica clip
#    non è stata ascoltata → rating non affidabile.
n_before <- nrow(short_raw)
zero_play <- short_raw |>
  filter(!is.na(play_count), play_count == 0)
short_raw <- short_raw |>
  filter(is.na(play_count) | play_count > 0)
n_dropped <- n_before - nrow(short_raw)

cat("Righe scartate (play_count == 0):    ", n_dropped, "\n")
if (n_dropped > 0) {
  cat("  distribuzione per partecipante:\n")
  print(zero_play |>
          count(participant_id_raw, name = "n_zero_play_clips") |>
          arrange(desc(n_zero_play_clips)))
}

# 3) Scarta partecipanti EN con < MIN_LISTENED_CLIPS ascolti validi
listen_counts <- short_raw |>
  filter(!is.na(play_count), play_count > 0) |>
  count(participant_id_raw, name = "n_listened")
low_engagement <- listen_counts |>
  filter(n_listened < MIN_LISTENED_CLIPS) |>
  pull(participant_id_raw)

cat("Partecipanti EN scartati (<", MIN_LISTENED_CLIPS, "clip ascoltate):",
    length(low_engagement), "\n")
if (length(low_engagement) > 0)
  cat("  ids:", paste(low_engagement, collapse = ", "), "\n")

short_raw <- short_raw |> filter(!participant_id_raw %in% low_engagement)

# Per la tab Full (Responses) play_count non esiste → aggiungi NA per compatibilità bind_rows
full_raw$play_count <- NA_integer_

# ── Unione delle due fonti ────────────────────────────────────────────────────
responses_raw <- bind_rows(full_raw, short_raw)

metadata <- read.csv2(META_PATH, stringsAsFactors = FALSE)

cat("\n── Dati grezzi combinati ────────────────────────────\n")
cat("Partecipanti totali:", n_distinct(responses_raw$participant_id_raw), "\n")
cat("  da Responses (full, 20 clip):  ",
    n_distinct(full_raw$participant_id_raw), "\n")
cat("  da Responses_Short_EN (10 cl): ",
    n_distinct(short_raw$participant_id_raw), "\n")
cat("Righe totali:       ", nrow(responses_raw), "\n\n")

# ── Anonimizzazione ───────────────────────────────────────────────────────────
user_map <- responses_raw |>
  distinct(participant_id_raw) |>
  arrange(participant_id_raw) |>
  mutate(participant_id = sprintf("P%03d", row_number()))

responses <- responses_raw |>
  left_join(user_map, by = "participant_id_raw") |>
  select(-participant_id_raw) |>
  relocate(participant_id, .before = clip_id)

write.csv(responses, OUT_ANON, row.names = FALSE)
cat("Dati anonimizzati salvati in:", OUT_ANON, "\n\n")

# ── Statistiche per partecipante ──────────────────────────────────────────────
participant_stats <- responses |>
  group_by(participant_id) |>
  summarise(
    n_clips      = n(),
    score        = sum(points, na.rm = TRUE),
    n_correct    = sum(correct, na.rm = TRUE),
    pct_correct  = round(n_correct / n_clips, 2),
    pct_nonso    = round(mean(nonso, na.rm = TRUE), 2),
    self_ability = first(self_ability),
    source       = first(source),
    .groups      = "drop"
  ) |>
  arrange(desc(pct_correct))

cat("── Statistiche per partecipante ─────────────────────\n")
print(participant_stats)

# Escludi chi ha risposto "Non so" a più di MAX_NONSO_PCT delle clip
valid_ids <- participant_stats |>
  filter(pct_nonso < MAX_NONSO_PCT) |>
  pull(participant_id)

cat("\nPartecipanti validi (non-so <", MAX_NONSO_PCT * 100, "%):",
    length(valid_ids), "su", nrow(participant_stats), "\n\n")

responses_valid <- responses |> filter(participant_id %in% valid_ids)

# ── Statistiche per clip (aggregate sui due dataset) ──────────────────────────
# Le clip ai_01..10 e hu_01..10 sono le stesse in entrambe le fonti → poolable.
clip_stats <- responses_valid |>
  group_by(clip_id, clip_type) |>
  summarise(
    n              = n(),
    mean_rating    = round(mean(rating[!nonso], na.rm = TRUE), 2),
    sd_rating      = round(sd(rating[!nonso],   na.rm = TRUE), 2),
    pct_correct    = round(mean(correct, na.rm = TRUE), 2),
    pct_familiar   = round(mean(familiar, na.rm = TRUE), 2),
    pct_nonso      = round(mean(nonso,    na.rm = TRUE), 2),
    mean_points    = round(mean(points,   na.rm = TRUE), 2),
    mean_play_cnt  = round(mean(play_count, na.rm = TRUE), 2),  # diagnostico engagement
    se_correct     = round(sd(correct, na.rm = TRUE) / sqrt(n()), 3),
    .groups        = "drop"
  ) |>
  left_join(metadata, by = c("clip_id", "clip_type")) |>
  arrange(clip_type, desc(sd_rating))

# ── Item-total correlation per clip ───────────────────────────────────────────
# Per ogni clip i: correlazione tra correct su clip i e accuracy del partecipante
# su TUTTE LE ALTRE clip. Misura quanto la clip discrimina i "bravi" dai "meno bravi".
compute_item_total_cor <- function(data, target_clip) {
  rated_here <- data |>
    filter(clip_id == target_clip) |>
    select(participant_id, correct_this = correct)
  if (nrow(rated_here) < 5) return(NA_real_)

  other_totals <- data |>
    filter(participant_id %in% rated_here$participant_id,
           clip_id != target_clip) |>
    group_by(participant_id) |>
    summarise(other_acc = mean(as.numeric(correct), na.rm = TRUE),
              .groups = "drop")

  joined <- inner_join(rated_here, other_totals, by = "participant_id")
  if (nrow(joined) < 5) return(NA_real_)
  suppressWarnings(
    cor(as.numeric(joined$correct_this), joined$other_acc, use = "complete.obs")
  )
}

clip_stats <- clip_stats |>
  rowwise() |>
  mutate(r_item_total = round(
    compute_item_total_cor(responses_valid, clip_id), 3)) |>
  ungroup()

# ── Expertise gap per clip ────────────────────────────────────────────────────
# Differenza pct_correct tra cluster expert (AI-aware: SunoAI, aiMusic) e cluster
# novice (audience generale). Misura quanto la clip discrimina in base alla
# provenienza dell'utente — segnale esterno indipendente da r_item_total.
expert_acc <- responses_valid |>
  filter(source %in% EXPERT_SOURCES) |>
  group_by(clip_id) |>
  summarise(pct_expert = round(mean(as.numeric(correct), na.rm = TRUE), 3),
            n_g_expert = n(), .groups = "drop")

casual_acc <- responses_valid |>
  filter(source %in% CASUAL_SOURCES) |>
  group_by(clip_id) |>
  summarise(pct_casual = round(mean(as.numeric(correct), na.rm = TRUE), 3),
            n_g_casual = n(), .groups = "drop")

expertise_gap_df <- full_join(expert_acc, casual_acc, by = "clip_id") |>
  mutate(expertise_gap = round(pct_expert - pct_casual, 3))

cat("── Expertise gap per clip (expert vs casual cluster) ──\n")
cat(sprintf("  Expert n: %d  | Casual n: %d\n",
            n_distinct(responses_valid$participant_id[
              responses_valid$source %in% EXPERT_SOURCES]),
            n_distinct(responses_valid$participant_id[
              responses_valid$source %in% CASUAL_SOURCES])))
print(expertise_gap_df |>
        arrange(desc(expertise_gap)) |>
        select(clip_id, pct_expert, pct_casual, expertise_gap,
               n_g_expert, n_g_casual))

clip_stats <- clip_stats |>
  left_join(expertise_gap_df |>
              select(clip_id, pct_expert, pct_casual, expertise_gap),
            by = "clip_id")

# ── SD rating tra i casual per clip (per composite) ──────────────────────────
sd_casual_df <- responses_valid |>
  filter(source %in% CASUAL_SOURCES, !nonso) |>
  group_by(clip_id) |>
  summarise(sd_rating_casual = round(sd(rating, na.rm = TRUE), 3),
            .groups = "drop")

clip_stats <- clip_stats |>
  left_join(sd_casual_df, by = "clip_id")

# ── Per-source diagnostico (mediana invece di media pool) ─────────────────────
# Stima più robusta quando le distribuzioni per source sono diverse.
per_source <- responses_valid |>
  group_by(clip_id, source) |>
  summarise(pct_correct_src = mean(correct, na.rm = TRUE),
            n_src = n(), .groups = "drop")
median_per_source <- per_source |>
  group_by(clip_id) |>
  summarise(pct_correct_median = round(median(pct_correct_src), 2),
            n_sources = n(),
            .groups = "drop")
clip_stats <- clip_stats |> left_join(median_per_source, by = "clip_id")

# ── r_item_D_casual per clip ──────────────────────────────────────────────────
# Correlazione tra il rating CONTINUO sulla clip i e il D-index del partecipante
# calcolato ESCLUDENDO la clip i, solo sui casual (non-nonso).
# D_excl = mean(AI_ratings_excl) − mean(Human_ratings_excl)
# Per clip AI:    attesa POSITIVA  (high-D → rating AI alto)
# Per clip Human: attesa NEGATIVA  (high-D → rating Human basso)
# Nel composite si usa r_item_D_casual * sign_align (+1 AI, -1 Human).
compute_r_item_D_casual <- function(data, target_clip, target_type,
                                    casual_sources) {
  data_casual <- data |>
    filter(source %in% casual_sources, !nonso)

  rated_here <- data_casual |>
    filter(clip_id == target_clip) |>
    select(participant_id, rating_this = rating)

  if (nrow(rated_here) < 5) return(NA_real_)

  d_excl <- data_casual |>
    filter(participant_id %in% rated_here$participant_id,
           clip_id != target_clip) |>
    group_by(participant_id) |>
    summarise(
      mean_ai = mean(rating[clip_type == "AI"],    na.rm = TRUE),
      mean_hu = mean(rating[clip_type == "HUMAN"], na.rm = TRUE),
      .groups = "drop"
    ) |>
    mutate(D_excl = mean_ai - mean_hu) |>
    filter(!is.na(D_excl))

  joined <- inner_join(rated_here, d_excl, by = "participant_id")
  if (nrow(joined) < 5) return(NA_real_)

  suppressWarnings(
    cor(joined$rating_this, joined$D_excl, use = "complete.obs")
  )
}

clip_stats <- clip_stats |>
  rowwise() |>
  mutate(r_item_D_casual = round(
    compute_r_item_D_casual(responses_valid, clip_id, clip_type,
                            CASUAL_SOURCES), 3)) |>
  ungroup()

cat("\n── r_item_D_casual per clip (diagnostico) ───────────\n")
cat("   (sign atteso: + per AI, − per Human | casual-only)\n")
print(clip_stats |>
        arrange(clip_type, desc(abs(r_item_D_casual))) |>
        select(clip_id, clip_type, genre, r_item_D_casual,
               sd_rating_casual, expertise_gap))

# ── r_item_D_weighted per clip ────────────────────────────────────────────────
# Come r_item_D_casual ma su TUTTI i partecipanti validi, pesati per
# (1 − pct_correct): massimizza il volume dati mantenendo il focus sui casual.
#   peso ≈ 0.50  → casual medio (pct_correct ≈ 0.50)
#   peso ≈ 0.15  → expert forte (pct_correct ≈ 0.85)
# Correlazione di Pearson pesata (weighted Pearson).
compute_r_item_D_weighted <- function(data, target_clip, target_type,
                                      p_stats) {
  rated_here <- data |>
    filter(clip_id == target_clip, !nonso) |>
    select(participant_id, rating_this = rating)

  if (nrow(rated_here) < 5) return(NA_real_)

  d_excl <- data |>
    filter(participant_id %in% rated_here$participant_id,
           clip_id != target_clip,
           !nonso) |>
    group_by(participant_id) |>
    summarise(
      mean_ai = mean(rating[clip_type == "AI"],    na.rm = TRUE),
      mean_hu = mean(rating[clip_type == "HUMAN"], na.rm = TRUE),
      .groups = "drop"
    ) |>
    mutate(D_excl = mean_ai - mean_hu) |>
    filter(!is.na(D_excl))

  joined <- inner_join(rated_here, d_excl, by = "participant_id") |>
    left_join(p_stats |> select(participant_id, pct_correct),
              by = "participant_id") |>
    mutate(w = pmax(0.01, 1 - pct_correct))  # floor 0.01: nessun peso zero

  if (nrow(joined) < 5) return(NA_real_)

  wm_x <- weighted.mean(joined$rating_this, joined$w, na.rm = TRUE)
  wm_y <- weighted.mean(joined$D_excl,      joined$w, na.rm = TRUE)
  wcov <- sum(joined$w * (joined$rating_this - wm_x) * (joined$D_excl - wm_y),
              na.rm = TRUE)
  wvx  <- sum(joined$w * (joined$rating_this - wm_x)^2, na.rm = TRUE)
  wvy  <- sum(joined$w * (joined$D_excl      - wm_y)^2, na.rm = TRUE)
  if (wvx == 0 || wvy == 0) return(NA_real_)
  wcov / sqrt(wvx * wvy)
}

clip_stats <- clip_stats |>
  rowwise() |>
  mutate(r_item_D_weighted = round(
    compute_r_item_D_weighted(responses_valid, clip_id, clip_type,
                              participant_stats), 3)) |>
  ungroup()

# ── Δ_rating_aligned per clip ─────────────────────────────────────────────────
# (mean_rating_expert − mean_rating_casual) × sign_align
# Per clip AI    sign_align = +1 → expert dà rating alto = buono
# Per clip Human sign_align = −1 → expert dà rating basso = buono
# Continuo: cattura confidenza, non solo % corretti (→ sostituisce expertise_gap binario)
expert_mean_r <- responses_valid |>
  filter(source %in% EXPERT_SOURCES, !nonso) |>
  group_by(clip_id) |>
  summarise(mean_rating_expert = round(mean(rating, na.rm = TRUE), 3),
            .groups = "drop")

casual_mean_r <- responses_valid |>
  filter(source %in% CASUAL_SOURCES, !nonso) |>
  group_by(clip_id) |>
  summarise(mean_rating_casual_d = round(mean(rating, na.rm = TRUE), 3),
            .groups = "drop")

delta_df <- full_join(expert_mean_r, casual_mean_r, by = "clip_id") |>
  left_join(clip_stats |> select(clip_id, clip_type), by = "clip_id") |>
  mutate(
    sign_align           = ifelse(clip_type == "AI", 1, -1),
    delta_rating_aligned = round(
      (mean_rating_expert - mean_rating_casual_d) * sign_align, 3)
  )

clip_stats <- clip_stats |>
  left_join(delta_df |>
              select(clip_id, mean_rating_expert, mean_rating_casual_d,
                     delta_rating_aligned),
            by = "clip_id")

cat("\n── r_item_D_weighted e Δ_rating_aligned per clip ────\n")
cat("   (r_item_D_weighted: tutti i part. pesati | Δ: gap continuo expert−casual)\n")
print(clip_stats |>
        arrange(clip_type, desc(r_item_D_weighted * ifelse(clip_type == "AI", 1, -1))) |>
        select(clip_id, clip_type, genre,
               r_item_D_casual, r_item_D_weighted,
               mean_rating_expert, mean_rating_casual_d, delta_rating_aligned))

cat("── Statistiche per clip ─────────────────────────────\n")
print(clip_stats |> select(clip_id, clip_type, genre, n,
                            mean_rating, sd_rating, pct_correct,
                            pct_familiar, pct_nonso))

write.csv(clip_stats, OUT_STATS, row.names = FALSE)
cat("\nStatistiche salvate in:", OUT_STATS, "\n\n")

# ══════════════════════════════════════════════════════════════════════════════
# SELEZIONE CLIP — FRAMEWORK A 3 LIVELLI (vedi config pre-specificata in testa)
# Livello 1: hard gate filter
# Livello 2: composite informativeness score (z-score di r_it + sd_quality + mean_centered)
# Livello 3: top-1 per cella del design 2×2 (AI/HUMAN × Rock/Pop)
# ══════════════════════════════════════════════════════════════════════════════

# Normalizza il nome del genere (Rock variants → "Rock", Pop variants → "Pop")
clip_stats <- clip_stats |>
  mutate(genre_grp = case_when(
    grepl("Rock", genre, ignore.case = TRUE) ~ "Rock",
    grepl("Pop",  genre, ignore.case = TRUE) ~ "Pop",
    TRUE                                     ~ genre
  ))

# ── Livello 1: hard gate filter ───────────────────────────────────────────────
candidates <- clip_stats |>
  filter(genre_grp %in% c("Rock", "Pop")) |>
  mutate(
    pass_n        = n          >= GATE_N_MIN,
    pass_nonso    = pct_nonso  <= GATE_NONSO_MAX,
    pass_correct  = pct_correct >= GATE_CORRECT_MIN &
                    pct_correct <= GATE_CORRECT_MAX,
    pass_gate     = pass_n & pass_nonso & pass_correct
  )

cat("── Livello 1: gate filter ────────────────────────────\n")
cat("  Criteri (pre-specificati):\n")
cat(sprintf("    n          >= %d\n",          GATE_N_MIN))
cat(sprintf("    pct_nonso  <= %.2f\n",        GATE_NONSO_MAX))
cat(sprintf("    pct_correct in [%.2f, %.2f]\n",
            GATE_CORRECT_MIN, GATE_CORRECT_MAX))
cat("  Risultati per gate:\n")
print(candidates |>
        select(clip_id, clip_type, genre_grp, n,
               pct_correct, pct_nonso,
               pass_n, pass_nonso, pass_correct, pass_gate))

# ── Livello 2: composite informativeness score ────────────────────────────────
# Indicatori (più alto = meglio):
#   a) r_item_D_weighted * sign_align — weighted Pearson, tutti i partecipanti
#   b) Δ_rating_aligned               — gap continuo mean_rating expert−casual
#   c) sd_rating_casual               — spread continuo rating tra i casual
# Composite = sum(w_i * z(indicatore_i)) tra le clip che passano il gate.

z_safe <- function(x) {
  s <- sd(x, na.rm = TRUE)
  if (is.na(s) || s == 0) return(rep(0, length(x)))
  (x - mean(x, na.rm = TRUE)) / s
}

candidates <- candidates |>
  mutate(
    sd_quality    = pmax(0, 1 - abs(sd_rating - SD_OPTIMUM)),
    mean_centered = pmax(0, 1 - abs(mean_rating - MEAN_OPTIMUM) / MEAN_HALF_RANGE)
  )

# z-score calcolati SOLO sui pass_gate (così il composito è confrontabile entro
# il set di "candidati realistici"). Le clip che falliscono il gate ricevono -Inf.
gate_ok <- candidates |> filter(pass_gate)
if (nrow(gate_ok) >= 2) {
  gate_ok <- gate_ok |>
    mutate(
      # sign_align: +1 per AI (r attesa positiva), -1 per Human (r attesa negativa)
      r_item_D_w_adj = r_item_D_weighted * ifelse(clip_type == "AI", 1, -1),
      z_rDw    = z_safe(r_item_D_w_adj),
      z_delta  = z_safe(delta_rating_aligned),
      z_sd     = z_safe(sd_rating_casual),
      composite_score = round(
        W_ITEM_D_W  * z_rDw   +
        W_DELTA_R   * z_delta +
        W_SD_CASUAL * z_sd,
        3)
    )
  candidates <- candidates |>
    left_join(gate_ok |> select(clip_id, r_item_D_w_adj, z_rDw,
                                z_delta, z_sd, composite_score),
              by = "clip_id") |>
    mutate(composite_score = ifelse(is.na(composite_score),
                                    -Inf, composite_score))
} else {
  candidates <- candidates |>
    mutate(r_item_D_w_adj = NA, z_rDw = NA, z_delta = NA, z_sd = NA,
           composite_score = NA_real_)
  cat("\n⚠️  Meno di 2 clip passano il gate → composito non calcolabile.\n")
}

cat("\n── Livello 2: composite score (solo clip pass_gate) ──\n")
print(candidates |> filter(pass_gate) |>
        arrange(desc(composite_score)) |>
        select(clip_id, clip_type, genre_grp,
               r_item_D_weighted, r_item_D_w_adj,
               delta_rating_aligned, sd_rating_casual,
               composite_score))

# ── Sensitivity analysis: robustezza dei pesi del composite ──────────────────
# Verifica se la clip selezionata cambia al variare dei pesi.
# Scenari scelti per testare variazioni realistiche attorno ai pesi pre-specificati
# (non azzeramenti estremi). SD fissa a 0.4 in tutti gli scenari (indicatore debole).
sens_scenarios <- list(
  "Attuale   (r=2.0, Δ=1.0, SD=0.4)" = c(2.0, 1.0, 0.4),
  "r ridotto (r=1.5, Δ=1.0, SD=0.4)" = c(1.5, 1.0, 0.4),
  "Δ alzato  (r=2.0, Δ=1.5, SD=0.4)" = c(2.0, 1.5, 0.4),
  "r≈Δ       (r=1.5, Δ=1.5, SD=0.4)" = c(1.5, 1.5, 0.4),
  "Δ domina  (r=1.0, Δ=2.0, SD=0.4)" = c(1.0, 2.0, 0.4)
)

CELLS_ORD <- c("AI × Pop", "AI × Rock", "HUMAN × Pop", "HUMAN × Rock")

get_sens_winners <- function(w) {
  gate_ok |>
    mutate(
      cell  = paste0(clip_type, " × ", genre_grp),
      score = w[1] * z_rDw + w[2] * z_delta + w[3] * z_sd
    ) |>
    group_by(cell) |>
    slice_max(score, n = 1, with_ties = FALSE) |>
    ungroup() |>
    select(cell, clip_id) |>
    tibble::deframe()   # → named vector cell → clip_id
}

sens_matrix <- do.call(rbind, lapply(sens_scenarios, get_sens_winners))
sens_df     <- as.data.frame(sens_matrix[, CELLS_ORD, drop = FALSE])

cat("\n── Sensitivity analysis: vincitore per cella ────────────────────────\n")
print(sens_df)

# Evidenzia celle in cui il vincitore cambia rispetto allo scenario base
base_w <- sens_matrix[1, CELLS_ORD]
changed_any <- FALSE
for (i in seq(2, nrow(sens_matrix))) {
  row_i   <- sens_matrix[i, CELLS_ORD]
  changed <- CELLS_ORD[row_i != base_w]
  if (length(changed) > 0) {
    cat(sprintf("  ⚠  '%s'\n     → cambia in: %s\n",
                rownames(sens_matrix)[i], paste(changed, collapse = ", ")))
    changed_any <- TRUE
  }
}
if (!changed_any)
  cat("  ✓  Selezione robusta: nessun cambio in nessuno scenario.\n")
cat("─────────────────────────────────────────────────────────────────────\n\n")

# ── Livello 3: top-1 per cella del design 2×2 ─────────────────────────────────
cat("\n── Livello 3: candidati per cella (type × genre) ────\n")
for (ct in c("AI", "HUMAN")) {
  for (g in c("Rock", "Pop")) {
    sub <- candidates |>
      filter(clip_type == ct, genre_grp == g) |>
      arrange(desc(pass_gate), desc(composite_score)) |>
      select(clip_id, n, pct_correct, pct_expert, pct_casual,
             delta_rating_aligned, r_item_D_weighted, composite_score, pass_gate)
    cat(sprintf("\n  ── %s × %s (%d candidati, %d pass_gate) ──\n",
                ct, g, nrow(sub), sum(sub$pass_gate, na.rm = TRUE)))
    if (nrow(sub) > 0) print(sub)
  }
}

# Selezione finale: massimo composite_score per cella (preferisce pass_gate)
selected <- candidates |>
  group_by(clip_type, genre_grp) |>
  arrange(desc(pass_gate), desc(composite_score)) |>
  slice_head(n = 1) |>
  ungroup() |>
  arrange(clip_type, genre_grp)

cat("\n══ CLIP SELEZIONATE (design 2×2) ════════════════════\n")
print(selected |> select(clip_id, clip_type, genre, genre_grp,
                          title, artist,
                          n, pct_correct, pct_expert, pct_casual,
                          delta_rating_aligned, r_item_D_weighted,
                          composite_score, pass_gate))

# Warning se qualche cella non passa il gate
n_failed <- sum(!selected$pass_gate, na.rm = TRUE)
if (n_failed > 0) {
  cat(sprintf("\n⚠️  %d clip selezionate FALLISCONO il gate filter:\n", n_failed))
  print(selected |> filter(!pass_gate) |>
          select(clip_id, clip_type, genre_grp,
                 n, pct_correct, pct_nonso,
                 pass_n, pass_nonso, pass_correct))
  cat("   → Documentare in tesi: cella riempita con best-available,\n")
  cat("     ma stime non affidabili. Considerare data collection extra\n")
  cat("     o riformulare il design.\n")
}

# Mantengo `eligible` per il plot (definito ora come pass_gate)
eligible <- candidates |> filter(pass_gate)

# ── Palette colori globale ────────────────────────────────────────────────────
# Definita qui: usata sia dal grafico standalone che dalla dashboard.
# 6 colori senza sovrapposizioni tra i ruoli "clip type" e "cluster partecipanti".
COL_AI       <- "#476F84"   # blu acciaio  → clip AI
COL_HUMAN    <- "#72874E"   # verde oliva  → clip Human
COL_EXPERT   <- "#453947"   # prugna scuro → cluster Expert
COL_CASUAL   <- "#A4BED5"   # blu polvere  → cluster Casual
COL_OTHER    <- "#023743"   # navy scuro   → cluster Other / Δ negativo
COL_SELECTED <- "#FED789"   # oro caldo    → clip selezionata

# ── Grafico detection rate ────────────────────────────────────────────────────
plot_data <- clip_stats |>
  mutate(
    label    = paste0(clip_id, "\n(", genre, ")"),
    selected = clip_id %in% selected$clip_id
  )

ggplot(plot_data, aes(x = reorder(label, pct_correct),
                      y = pct_correct, fill = clip_type)) +
  geom_col(alpha = 0.85) +
  geom_errorbar(aes(ymin = pct_correct - se_correct,
                    ymax = pct_correct + se_correct),
                width = 0.3, color = "grey30") +
  geom_point(data = filter(plot_data, selected),
             aes(y = pct_correct + se_correct + 0.04),
             shape = 25, size = 3, fill = COL_SELECTED, color = "grey30") +
  annotate("rect", xmin = -Inf, xmax = Inf,
           ymin = GATE_CORRECT_MIN, ymax = GATE_CORRECT_MAX,
           alpha = 0.08, fill = COL_HUMAN) +
  geom_hline(yintercept = c(GATE_CORRECT_MIN, GATE_CORRECT_MAX),
             linetype = "dashed", color = COL_HUMAN, alpha = 0.6) +
  scale_fill_manual(values = c("AI" = COL_AI, "HUMAN" = COL_HUMAN),
                    labels = c("AI" = "AI (Suno)", "HUMAN" = "Umana (Jamendo)")) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1.05)) +
  coord_flip() +
  labs(
    title    = "Detection rate per clip — Pretest combinato",
    subtitle = sprintf("Zona verde = gate target (%.0f–%.0f%%) | ±SE | ▼ = selezionata 2×2",
                       GATE_CORRECT_MIN * 100, GATE_CORRECT_MAX * 100),
    x = NULL, y = "% risposte corrette", fill = "Tipo"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

ggsave(OUT_PLOT, width = 8, height = 7, dpi = 150)
cat("Grafico salvato:", OUT_PLOT, "\n\n")

# ── Self-ability vs performance ───────────────────────────────────────────────
sa_perf <- participant_stats |>
  filter(!is.na(self_ability)) |>
  select(participant_id, pct_correct, self_ability, source)

if (nrow(sa_perf) >= 3) {
  r <- cor(sa_perf$self_ability, sa_perf$pct_correct, use = "complete.obs")
  cat("── Self-ability vs Accuracy (% correct) ──────────────\n")
  cat(sprintf("Correlazione di Pearson r = %.3f  (n = %d)\n", r, nrow(sa_perf)))
  cat(if (abs(r) > 0.3) "→ Correlazione moderata/forte\n"
      else "→ Correlazione debole o assente\n")

  print(sa_perf |> arrange(desc(pct_correct)))
} else {
  cat("Self-ability: dati insufficienti per la correlazione.\n")
}

# ── Riepilogo per source (UTM tracking) ───────────────────────────────────────
src_summary <- participant_stats |>
  group_by(source) |>
  summarise(
    n_participants = n(),
    mean_pct_correct = round(mean(pct_correct, na.rm = TRUE), 2),
    .groups        = "drop"
  ) |>
  arrange(desc(n_participants))
cat("\n── Riepilogo per source ──────────────────────────────\n")
print(src_summary)

# ══════════════════════════════════════════════════════════════════════════════
# DASHBOARD 4 QUADRANTI (visualizzazione di sintesi)
# ══════════════════════════════════════════════════════════════════════════════
if (!requireNamespace("patchwork", quietly = TRUE)) {
  install.packages("patchwork")
}
library(patchwork)

dash_theme <- theme_minimal(base_size = 10) +
  theme(
    plot.title    = element_text(size = 11, face = "bold"),
    plot.subtitle = element_text(size = 9,  color = "grey40"),
    legend.position = "bottom",
    legend.key.size = unit(0.4, "cm"),
    panel.grid.minor = element_blank()
  )

# Palette ad alto contrasto per source individuali (Set1 + Dark2 mix, 12 colori
# distinti scelti per essere visivamente discriminabili anche con bar adiacenti).
DISTINCT_PALETTE <- c(
  "#e41a1c",  # rosso
  "#377eb8",  # blu
  "#4daf4a",  # verde
  "#984ea3",  # viola
  "#ff7f00",  # arancione
  "#a65628",  # marrone
  "#f781bf",  # rosa
  "#1b9e77",  # teal scuro
  "#d95f02",  # arancio scuro
  "#7570b3",  # viola-blu
  "#e7298a",  # magenta
  "#66a61e"   # verde lime
)
make_palette <- function(n) {
  if (n <= length(DISTINCT_PALETTE)) DISTINCT_PALETTE[seq_len(n)]
  else grDevices::colorRampPalette(DISTINCT_PALETTE)(n)
}
n_src_total <- n_distinct(participant_stats$source)
src_palette <- make_palette(n_src_total)
names(src_palette) <- sort(unique(participant_stats$source))

# ── Quadrante 1: distribuzione D-index per partecipante ───────────────────────
# D_i = mean(AI_ratings) − mean(Human_ratings): la variabile che il CBC misurerà.
# Mostra quanto si distribuisce il D-index nel sample e se i cluster si separano.
n_total  <- nrow(participant_stats)

d_individual <- responses_valid |>
  filter(!nonso) |>
  group_by(participant_id) |>
  summarise(
    mean_ai = mean(rating[clip_type == "AI"],    na.rm = TRUE),
    mean_hu = mean(rating[clip_type == "HUMAN"], na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(D_index = mean_ai - mean_hu) |>
  left_join(participant_stats |> select(participant_id, source),
            by = "participant_id") |>
  mutate(cluster = case_when(
    source %in% EXPERT_SOURCES ~ "Expert (AI-aware)",
    source %in% CASUAL_SOURCES ~ "Casual (general)",
    TRUE                       ~ "Other"
  )) |>
  filter(!is.na(D_index))

d_cluster_means <- d_individual |>
  group_by(cluster) |>
  summarise(m = mean(D_index, na.rm = TRUE), .groups = "drop")

# n per cluster → etichette legenda
cluster_n <- d_individual |>
  dplyr::count(cluster) |>
  tibble::deframe()

# Media D-index totale (linea rossa)
overall_d <- mean(d_individual$D_index, na.rm = TRUE)

CLUSTER_COLORS <- c(
  "Expert (AI-aware)" = COL_EXPERT,
  "Casual (general)"  = COL_CASUAL,
  "Other"             = COL_OTHER
)

p1 <- ggplot(d_individual, aes(x = D_index, fill = cluster)) +
  geom_histogram(binwidth = 0.25, color = "white", alpha = 0.85, boundary = 0) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey50",
             linewidth = 0.6) +
  # Media per cluster: colore = cluster (collegato alla legenda dal titolo "— = media")
  geom_vline(data = d_cluster_means,
             aes(xintercept = m, color = cluster),
             linewidth = 1.1, linetype = "solid", show.legend = FALSE) +
  geom_text(data = d_cluster_means,
            aes(x = m, y = Inf, label = sprintf("%.2f", m), color = cluster),
            vjust = 1.5, hjust = -0.15, size = 2.8, fontface = "bold",
            show.legend = FALSE) +
  # Media totale in rosso
  geom_vline(xintercept = overall_d, color = "red", linewidth = 1.0) +
  annotate("text", x = overall_d, y = Inf,
           label = sprintf("%.2f", overall_d),
           vjust = 1.5, hjust = -0.15, size = 2.8,
           color = "red", fontface = "bold") +
  scale_x_continuous(breaks = seq(-3, 3, 1)) +
  coord_cartesian(xlim = c(-3.2, 3.2)) +
  scale_fill_manual(
    values = CLUSTER_COLORS,
    labels = c(
      "Expert (AI-aware)" = sprintf("Expert  (n = %d)", cluster_n["Expert (AI-aware)"]),
      "Casual (general)"  = sprintf("Casual  (n = %d)", cluster_n["Casual (general)"]),
      "Other"             = sprintf("Other   (n = %d)", cluster_n["Other"])
    )
  ) +
  scale_color_manual(values = CLUSTER_COLORS, guide = "none") +
  labs(
    title    = "D-index per cluster: Expert vs Casual",
    subtitle = "D = mean(AI rating) − mean(Human rating)  |  linea rossa = media totale",
    x        = "D-index  (< 0: inversione  ·  0: nessuna discriminazione  ·  > 0: rilevamento corretto)",
    y        = "n partecipanti",
    fill     = "Cluster  (— = media)"
  ) +
  dash_theme +
  theme(legend.text = element_text(size = 7))

# ── Quadrante 2: detection rate per clip ──────────────────────────────────────
p2_data <- clip_stats |>
  mutate(label = sprintf("%s (%s)", clip_id,
                         ifelse(grepl("Rock", genre, ignore.case = TRUE), "Rock", "Pop"))) |>
  left_join(candidates |> select(clip_id, pass_gate), by = "clip_id") |>
  mutate(
    pass_gate   = tidyr::replace_na(pass_gate, FALSE),
    is_selected = clip_id %in% selected$clip_id
  )

mean_detect <- mean(clip_stats$pct_correct, na.rm = TRUE)

p2 <- ggplot(p2_data, aes(x = reorder(label, pct_correct),
                           y = pct_correct, fill = clip_type,
                           alpha = pass_gate)) +
  # Barre: alpha pieno se pass_gate, sbiadito se no
  geom_col() +
  geom_errorbar(aes(ymin = pmax(0, pct_correct - se_correct),
                    ymax = pmin(1, pct_correct + se_correct)),
                width = 0.3, color = "grey40") +
  # Gate zone in oro trasparente
  annotate("rect", xmin = -Inf, xmax = Inf,
           ymin = GATE_CORRECT_MIN, ymax = GATE_CORRECT_MAX,
           alpha = 0.15, fill = COL_SELECTED) +
  # Linea media detection in rosso
  geom_hline(yintercept = mean_detect, color = "red",
             linewidth = 0.8, linetype = "solid") +
  # Riferimento 50% (chance level)
  geom_hline(yintercept = 0.5, linetype = "dashed",
             color = "grey50", linewidth = 0.4) +
  # Diamanti oro per clip selezionate
  geom_point(data = p2_data |> filter(is_selected),
             aes(x = reorder(label, pct_correct),
                 y = pct_correct + se_correct + 0.03),
             shape = 18, size = 3.5, color = COL_SELECTED,
             inherit.aes = FALSE) +
  scale_fill_manual(values = c("AI" = COL_AI, "HUMAN" = COL_HUMAN),
                    labels = c("AI" = "AI generativa (Suno)", "HUMAN" = "Umana (Jamendo)")) +
  scale_alpha_manual(values = c("TRUE" = 0.88, "FALSE" = 0.30),
                     guide  = "none") +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  coord_flip() +
  labs(title    = "Tasso di rilevamento per clip (% risposte corrette)",
       subtitle = sprintf("Zona oro = gate [%.0f–%.0f%%] | ◆ = selezionata | rosso = media | sbiadito = fuori gate",
                          GATE_CORRECT_MIN * 100, GATE_CORRECT_MAX * 100),
       x = NULL, y = "% risposte corrette", fill = "Tipo clip") +
  dash_theme +
  theme(axis.text.y = element_text(size = 6))

# ── Quadrante 3: scatter composite — colore per cella 2×2 ────────────────────
# Ogni punto = una clip pass_gate. Colore = cella (chi compete con chi).
# Candidati non selezionati: cerchio semitrasparente + label piccola.
# Selezionati: diamante oro grande + label in grassetto.
# Assi = le 2 componenti principali del composite; ideale = top-right.
CELL_COLORS <- c(
  "AI × Rock"    = COL_AI,
  "AI × Pop"     = COL_CASUAL,    # blu polvere → AI più chiaro
  "HUMAN × Rock" = COL_HUMAN,
  "HUMAN × Pop"  = "#9aab6a"      # verde oliva chiaro → Human più chiaro
)

comp_vis <- gate_ok |>
  mutate(
    is_selected = clip_id %in% selected$clip_id,
    cell        = paste0(clip_type, " × ", genre_grp)
  )

p3 <- ggplot(comp_vis,
             aes(x = r_item_D_w_adj, y = delta_rating_aligned)) +
  # Quadrante ideale: leggera sfumatura top-right
  annotate("rect", xmin = 0, xmax = Inf, ymin = 0, ymax = Inf,
           alpha = 0.04, fill = COL_SELECTED) +
  annotate("text", x = Inf, y = Inf, label = "ideale ↗",
           hjust = 1.15, vjust = 1.5, size = 2.8,
           color = "grey60", fontface = "italic") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey65") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey65") +
  # Candidati non selezionati: cerchio semitrasparente
  geom_point(data = comp_vis |> filter(!is_selected),
             aes(color = cell),
             shape = 16, size = 3.5, alpha = 0.55) +
  geom_text(data = comp_vis |> filter(!is_selected),
            aes(label = clip_id, color = cell),
            size = 2.4, vjust = -0.9, check_overlap = TRUE,
            show.legend = FALSE) +
  # Clip selezionate: diamante oro con bordo scuro, label in evidenza
  geom_point(data = comp_vis |> filter(is_selected),
             aes(fill = cell),
             shape = 23, size = 5.5, color = COL_SELECTED, stroke = 1.5) +
  geom_text(data = comp_vis |> filter(is_selected),
            aes(label = clip_id),
            size = 2.8, vjust = -1.1, fontface = "bold", color = "grey15") +
  scale_color_manual(values = CELL_COLORS, name = "Cella 2×2") +
  scale_fill_manual(values  = CELL_COLORS, guide = "none") +
  scale_x_continuous(breaks = seq(-0.5, 0.5, 0.25)) +
  labs(title    = "Componenti del composite: discriminazione item-D vs expertise gap",
       subtitle = "◆ = clip selezionata per cella | colore = cella design 2×2 | top-right = candidata ideale",
       x = "r(rating, D-index)  — correlazione item-D pesata per accuratezza",
       y = "Δ rating (Expert − Casual, aggiustato per tipo clip)") +
  dash_theme

# ── Quadrante 4: Δ_rating_aligned — Cleveland dot plot expert vs casual ────────
# Per ogni clip: punto pieno (●) = mean_rating_expert, aperto (○) = mean_rating_casual.
# Il segmento connette i due; se il gap va nella direzione attesa (sign_align) il
# segmento è colorato (Δ > 0 = buono). Ordinato per Δ_rating_aligned crescente.
# Sostituisce il bar chart 2×2 (che aggregava senza distinguere le clip singole).
# Base delta_clev — deduplicato per sicurezza contro join multipli
delta_clev <- clip_stats |>
  filter(!is.na(mean_rating_expert), !is.na(mean_rating_casual_d)) |>
  distinct(clip_id, .keep_all = TRUE) |>
  mutate(
    is_selected = clip_id %in% selected$clip_id,
    sign_align  = ifelse(clip_type == "AI", 1, -1),
    delta_raw   = (mean_rating_expert - mean_rating_casual_d) * sign_align,
    gap_ok      = delta_raw > 0,
    genre_short = ifelse(grepl("Rock", genre, ignore.case = TRUE), "Rock", "Pop"),
    lbl         = paste0(clip_id, "  (", genre_short, ")")
  )

# Costruisco i livelli del factor esplicitamente:
# AI group (Δ crescente → livelli bassi = fondo asse y)
# HUMAN group (Δ crescente → sopra AI)
ai_lvls <- delta_clev |> filter(clip_type == "AI")    |> arrange(delta_raw) |> pull(lbl)
hu_lvls <- delta_clev |> filter(clip_type == "HUMAN") |> arrange(delta_raw) |> pull(lbl)
p4_levels <- c(ai_lvls, hu_lvls)   # AI in basso, HUMAN in alto

delta_clev <- delta_clev |>
  mutate(clip_label = factor(lbl, levels = p4_levels)) |>
  select(-lbl)

n_ai_p4 <- length(ai_lvls)

# Palette p4
P4_EXPERT_COLOR <- COL_EXPERT   # prugna scuro → Expert
P4_CASUAL_COLOR <- COL_CASUAL   # blu polvere  → Casual
P4_SEG_POS      <- COL_HUMAN    # verde oliva  → Δ > 0 (direzione corretta)
P4_SEG_NEG      <- COL_OTHER    # navy scuro   → Δ < 0 (inversione)

p4 <- ggplot(delta_clev) +
  geom_vline(xintercept = 2.5, linetype = "dashed", color = "grey55",
             linewidth = 0.5) +
  # Segmento casual → expert, colore = direzione del gap
  geom_segment(aes(x = mean_rating_casual_d, xend = mean_rating_expert,
                   y = clip_label, yend = clip_label,
                   color = gap_ok),
               linewidth = 1.1, alpha = 0.70) +
  # Expert: cerchio pieno viola
  geom_point(aes(x = mean_rating_expert, y = clip_label),
             shape = 16, size = 3.2, color = P4_EXPERT_COLOR) +
  # Casual: cerchio aperto grigio
  geom_point(aes(x = mean_rating_casual_d, y = clip_label),
             shape = 1, size = 3.2, stroke = 1.3, color = P4_CASUAL_COLOR) +
  # Diamante oro per clip selezionate
  geom_point(data = delta_clev |> filter(is_selected),
             aes(x = pmax(mean_rating_expert, mean_rating_casual_d) + 0.18,
                 y = clip_label),
             shape = 18, size = 4.5, color = COL_SELECTED) +
  # Valore Δ_rating_aligned in chiaro, allineato a destra
  # show.legend = FALSE: evita il bug ggplot2 che mostra "a" nella legenda colore
  geom_text(aes(x = 4.55, y = clip_label,
                label = sprintf("Δ %+.2f", delta_raw),
                color = gap_ok),
            hjust = 0, size = 2.5, fontface = "bold",
            show.legend = FALSE) +
  scale_color_manual(
    values = c("TRUE"  = P4_SEG_POS, "FALSE" = P4_SEG_NEG),
    labels = c("TRUE"  = "Δ > 0  (Expert riconosce correttamente)",
               "FALSE" = "Δ < 0  (Expert invertiti)"),
    name   = "Direzione gap"
  ) +
  scale_x_continuous(breaks = 1:4, limits = c(0.9, 5.3),
                     labels = c("1\n(Human)", "2", "3", "4\n(AI)")) +
  labs(title    = "Rating medio per clip: Expert vs Casual",
       subtitle = "● = Expert  |  ○ = Casual  |  segmento = direzione Δ  |  ◆ = clip selezionata  |  2.5 = neutro",
       x = "Rating medio (1 = Sicuramente Human  ·  4 = Sicuramente AI)", y = NULL) +
  dash_theme +
  theme(axis.text.y = element_text(size = 7))

# ── Quadrante 5: composite score ranking per cella 2×2 ───────────────────────
# Per ogni cella del design (AI×Rock, AI×Pop, Human×Rock, Human×Pop) mostra il
# composite score di tutte le clip pass_gate, ordinate dal più basso al più alto.
# Oro = clip selezionata per quella cella. Risponde a "perché questa e non un'altra?".
cell_rank <- gate_ok |>
  mutate(
    is_selected = clip_id %in% selected$clip_id,
    cell        = factor(paste0(clip_type, " × ", genre_grp),
                         levels = c("AI × Rock", "AI × Pop",
                                    "HUMAN × Rock", "HUMAN × Pop"))
  ) |>
  arrange(cell, composite_score) |>
  # Chiave per ordinamento within-facet: "clip_id__cell"
  mutate(y_key = factor(paste0(clip_id, "__", cell),
                        levels = unique(paste0(clip_id, "__", cell))))

# Componenti pesate in formato long — una riga per componente per clip
cell_rank_comp <- cell_rank |>
  select(clip_id, y_key, cell, z_rDw, z_delta, z_sd) |>
  mutate(
    `r(item,D)  ×2.0`      = W_ITEM_D_W  * z_rDw,
    `Δ expert-casual  ×1.0` = W_DELTA_R   * z_delta,
    `SD casual  ×0.4`      = W_SD_CASUAL * z_sd
  ) |>
  tidyr::pivot_longer(
    cols      = c(`r(item,D)  ×2.0`, `Δ expert-casual  ×1.0`, `SD casual  ×0.4`),
    names_to  = "componente",
    values_to = "valore"
  ) |>
  mutate(componente = factor(componente,
    levels = c("r(item,D)  ×2.0", "Δ expert-casual  ×1.0", "SD casual  ×0.4")))

COMP_COLORS <- c(
  "r(item,D)  ×2.0"       = COL_AI,      # blu acciaio — correlazione rating-Dindex
  "Δ expert-casual  ×1.0" = COL_HUMAN,   # verde oliva  — gap expert vs casual
  "SD casual  ×0.4"       = COL_OTHER    # navy          — spread rating casual
)

p5 <- ggplot(cell_rank) +
  geom_vline(xintercept = 0, color = "grey40", linewidth = 0.5) +
  # 1. Barre componenti in background: ognuna da 0 al proprio valore (faded, sovrapposte)
  geom_col(data = cell_rank_comp,
           aes(x = valore, y = y_key, fill = componente),
           alpha = 0.38, color = NA, position = "identity", width = 0.82) +
  # 2. Bordo del totale: grigio per candidati, oro per selezionata
  geom_col(aes(x = composite_score, y = y_key),
           fill = NA, color = "grey45", linewidth = 0.35) +
  geom_col(data = cell_rank |> filter(is_selected),
           aes(x = composite_score, y = y_key),
           fill = NA, color = COL_SELECTED, linewidth = 1.3) +
  # 3. Etichetta valore composito
  geom_text(aes(x = composite_score, y = y_key,
                label = sprintf("%.2f", composite_score),
                hjust = ifelse(composite_score >= 0, -0.15, 1.15)),
            size = 2.5, color = "grey20") +
  facet_wrap(~ cell, scales = "free_y", ncol = 2) +
  scale_y_discrete(labels = function(x) sub("__.*", "", x)) +
  scale_fill_manual(values = COMP_COLORS, name = "Componente (pesata)") +
  scale_x_continuous(expand = expansion(mult = c(0.22, 0.22))) +
  labs(title    = "Quale clip per ciascuna condizione? Ranking per informatività",
       subtitle = "Solo clip che superano il gate: N ≥ 30, det. rate 30–70%  |  bordo oro = selezionata",
       x = "Punteggio composito  (> 0 = sopra la media  |  barre colorate = contributo di ciascun indicatore)",
       y = NULL) +
  dash_theme +
  theme(
    strip.text       = element_text(face = "bold", size = 8),
    axis.text.y      = element_text(size = 7),
    legend.position  = "bottom",
    legend.key.size  = unit(0.5, "lines")
  )

# ── Assembla dashboard ────────────────────────────────────────────────────────
# Layout:
#   Riga 1: p1 (D-index dist.) | p2 (detection rate)        — validazione campione
#   Riga 2: p3 (scatter comp.) | p4 (Cleveland Δ_rating) | p5 (ranking per cella)
# p5 ha 4 facet interni → gli assegnamo più larghezza relativa (1.5×)
top_row    <- p1 | p2
bottom_row <- (p3 | p4 | p5) + plot_layout(widths = c(1, 1, 1.5))

dashboard <- top_row / bottom_row +
  plot_annotation(
    title    = sprintf("Audio Pretest Dashboard — N = %d", n_total),
    subtitle = sprintf("Pretest combinato (Full + EN) | Aggiornato a %s",
                       format(Sys.Date(), "%Y-%m-%d")),
    theme    = theme(
      plot.title    = element_text(size = 14, face = "bold"),
      plot.subtitle = element_text(size = 10, color = "grey40")
    )
  )


print(dashboard)
ggsave(OUT_DASH, dashboard, width = 18, height = 10, dpi = 150)
cat("\nDashboard salvata:", OUT_DASH, "\n")
