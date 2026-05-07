library(googlesheets4)
library(dplyr)
library(ggplot2)

# ── Config ────────────────────────────────────────────────────────────────────
SHEET_ID    <- "1oVruAANYslwX066U3YcqhCYJd5Mxol1fBe0A-J9XlsY"
AUTH_PATH   <- "../pretest/service_account.json"   # relativo a analysis/
META_PATH   <- "../sampling/clips_metadata.csv"
OUT_STATS   <- "clip_stats_results.csv"
OUT_ANON    <- "responses_anonymized.csv"
OUT_PLOT    <- "detection_rate_plot.png"

# Criteri selezione (dichiarati PRIMA di vedere i dati — documentare in tesi)
CRIT_FAM_MAX     <- 0.15   # max % partecipanti che conosce già il brano
CRIT_CORRECT_MIN <- 0.50   # min detection rate
CRIT_CORRECT_MAX <- 0.80   # max detection rate

# ── Auth + carica dati ────────────────────────────────────────────────────────
gs4_auth(path = AUTH_PATH)

responses_raw <- read_sheet(SHEET_ID, sheet = "Responses") |>
  mutate(
    points       = as.integer(points),
    correct      = as.logical(correct),
    familiar     = as.logical(familiar),
    nonso        = as.logical(nonso),
    rating       = as.integer(rating),
    self_ability = as.integer(self_ability)
  )

metadata <- read.csv(META_PATH, stringsAsFactors = FALSE)

cat("── Dati grezzi ──────────────────────────────────────\n")
cat("Partecipanti totali:", n_distinct(responses_raw$username), "\n")
cat("Risposte totali:    ", nrow(responses_raw), "\n\n")

# ── Anonimizzazione ───────────────────────────────────────────────────────────
# Sostituisce username reali con P001, P002, ... prima di qualsiasi analisi
user_map <- responses_raw |>
  distinct(username) |>
  arrange(username) |>
  mutate(participant_id = sprintf("P%03d", row_number()))

responses <- responses_raw |>
  left_join(user_map, by = "username") |>
  select(-username) |>
  relocate(participant_id, .before = clip_id)

write.csv(responses, OUT_ANON, row.names = FALSE)
cat("Dati anonimizzati salvati in:", OUT_ANON, "\n\n")

# ── Statistiche per partecipante ──────────────────────────────────────────────
participant_stats <- responses |>
  group_by(participant_id) |>
  summarise(
    score        = sum(points),
    n_correct    = sum(correct),
    pct_nonso    = round(mean(nonso), 2),
    self_ability = first(self_ability),
    lang         = first(lang),
    .groups      = "drop"
  ) |>
  arrange(desc(score))

cat("── Statistiche per partecipante ─────────────────────\n")
print(participant_stats)

# Escludi chi ha risposto "Non so" a più del 50% delle clip
valid_ids <- participant_stats |>
  filter(pct_nonso < 0.5) |>
  pull(participant_id)

cat("\nPartecipanti validi (non-so < 50%):", length(valid_ids),
    "su", nrow(participant_stats), "\n\n")

responses_valid <- responses |> filter(participant_id %in% valid_ids)

# ── Statistiche per clip ──────────────────────────────────────────────────────
clip_stats <- responses_valid |>
  group_by(clip_id, clip_type) |>
  summarise(
    n            = n(),
    mean_rating  = round(mean(rating[!nonso], na.rm = TRUE), 2),  # escludi nonso dal rating
    sd_rating    = round(sd(rating[!nonso],   na.rm = TRUE), 2),
    pct_correct  = round(mean(correct,  na.rm = TRUE), 2),
    pct_familiar = round(mean(familiar, na.rm = TRUE), 2),
    pct_nonso    = round(mean(nonso,    na.rm = TRUE), 2),
    mean_points  = round(mean(points,   na.rm = TRUE), 2),
    se_correct   = round(sd(correct, na.rm = TRUE) / sqrt(n()), 3),
    .groups      = "drop"
  ) |>
  left_join(metadata, by = c("clip_id", "clip_type")) |>
  arrange(clip_type, desc(sd_rating))

cat("── Statistiche per clip ─────────────────────────────\n")
print(clip_stats |> select(clip_id, clip_type, genre, n,
                            mean_rating, sd_rating, pct_correct,
                            pct_familiar, pct_nonso))

write.csv(clip_stats, OUT_STATS, row.names = FALSE)
cat("\nStatistiche salvate in:", OUT_STATS, "\n\n")

# ── Selezione clip finali ─────────────────────────────────────────────────────
eligible <- clip_stats |>
  filter(
    pct_familiar <= CRIT_FAM_MAX,
    pct_correct  >= CRIT_CORRECT_MIN,
    pct_correct  <= CRIT_CORRECT_MAX
  )

cat("── Clip eleggibili (criteri pre-specificati) ────────\n")
cat("  familiar ≤", CRIT_FAM_MAX,
    "| correct", CRIT_CORRECT_MIN, "–", CRIT_CORRECT_MAX, "\n")
print(eligible |> select(clip_id, clip_type, genre,
                          sd_rating, pct_correct, pct_familiar))

# Top-1 per sd_rating per ogni combinazione tipo × genere
selected <- eligible |>
  group_by(clip_type, genre) |>
  slice_max(order_by = sd_rating, n = 1) |>
  ungroup()

cat("\n── Clip selezionate per il sondaggio finale ─────────\n")
print(selected |> select(clip_id, clip_type, genre, title,
                          artist, mean_rating, sd_rating, pct_correct))

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
             shape = 25, size = 3, fill = "gold", color = "grey30") +
  annotate("rect", xmin = -Inf, xmax = Inf,
           ymin = CRIT_CORRECT_MIN, ymax = CRIT_CORRECT_MAX,
           alpha = 0.08, fill = "green") +
  geom_hline(yintercept = c(CRIT_CORRECT_MIN, CRIT_CORRECT_MAX),
             linetype = "dashed", color = "darkgreen", alpha = 0.6) +
  scale_fill_manual(values = c("AI" = "#2563eb", "HUMAN" = "#16a34a"),
                    labels = c("AI" = "AI (Suno)", "HUMAN" = "Umana (Jamendo)")) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1.05)) +
  coord_flip() +
  labs(
    title    = "Detection rate per clip — Pretest",
    subtitle = "Zona verde = range target (50–80%) | Barre = ±SE | ▼ = clip selezionata",
    x = NULL, y = "% risposte corrette", fill = "Tipo"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

ggsave(OUT_PLOT, width = 8, height = 7, dpi = 150)
cat("Grafico salvato:", OUT_PLOT, "\n\n")

# ── Self-ability vs performance ───────────────────────────────────────────────
sa_perf <- participant_stats |>
  filter(!is.na(self_ability)) |>
  select(participant_id, score, self_ability, lang)

if (nrow(sa_perf) >= 3) {
  r <- cor(sa_perf$self_ability, sa_perf$score, use = "complete.obs")
  cat("── Self-ability vs Score ─────────────────────────────\n")
  cat(sprintf("Correlazione di Pearson r = %.3f  (n = %d)\n", r, nrow(sa_perf)))
  cat(if (abs(r) > 0.3) "→ Correlazione moderata/forte\n"
      else "→ Correlazione debole o assente\n")

  print(sa_perf |> arrange(desc(score)))
} else {
  cat("Self-ability: dati insufficienti per la correlazione.\n")
}
