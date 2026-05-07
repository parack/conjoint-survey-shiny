# sample_tracks.R
# Campionamento riproducibile delle tracce candidate per il pretest.
# Eseguire dalla cartella sampling/ oppure adattare i path.
# set.seed(57) garantisce riproducibilità — documentare in tesi.

set.seed(57)

# ── JAMENDO POP ───────────────────────────────────────────────────────────────
popcandidates <- read.csv("jamendo_pop_candidates.csv", sep = ";", header = TRUE)
popcandidates <- popcandidates[popcandidates$listens >= 300000 &
                                 popcandidates$listens <= 1000000, ]
pop_sel <- popcandidates[sample(nrow(popcandidates), 6), ]
write.csv(pop_sel, "jamendo_pop_selected.csv", row.names = FALSE)
cat("=== JAMENDO POP (6 su", nrow(popcandidates), "candidati) ===\n")
print(pop_sel[, c("name", "artist", "listens", "url")])

# ── JAMENDO ROCK ──────────────────────────────────────────────────────────────
rockcandidates <- read.csv("jamendo_rock_candidates.csv", sep = ";", header = TRUE)
rockcandidates <- rockcandidates[rockcandidates$listens >= 300000, ]
rock_sel <- rockcandidates[sample(nrow(rockcandidates), 9), ]
write.csv(rock_sel, "jamendo_rock_selected.csv", row.names = FALSE)
cat("\n=== JAMENDO ROCK (9 su", nrow(rockcandidates), "candidati) ===\n")
print(rock_sel[, c("name", "artist", "listens", "url")])

# ── SUNO POP ──────────────────────────────────────────────────────────────────
suno_pop    <- read.csv("Suno_Pop_candidates.csv", sep = ";", header = TRUE)
suno_pop_v5 <- suno_pop[suno_pop$Version == 5, ]
suno_pop_sel <- suno_pop_v5[sample(nrow(suno_pop_v5), 5), ]
write.csv(suno_pop_sel, "suno_pop_selected.csv", row.names = FALSE)
cat("\n=== SUNO POP (5 su", nrow(suno_pop_v5), "candidati v5) ===\n")
print(suno_pop_sel[, c("Riga", "Canzone", "Artista", "Listens")])

# ── SUNO ROCK ─────────────────────────────────────────────────────────────────
suno_rock    <- read.csv("Suno_Rock_candidates.csv", sep = ";", header = TRUE)
suno_rock_v5 <- suno_rock[suno_rock$Version == 5, ]
suno_rock_sel <- suno_rock_v5[sample(nrow(suno_rock_v5), 5), ]
write.csv(suno_rock_sel, "suno_rock_selected.csv", row.names = FALSE)
cat("\n=== SUNO ROCK (5 su", nrow(suno_rock_v5), "candidati v5) ===\n")
print(suno_rock_sel[, c("Riga", "Canzone", "Artista", "Listens")])
