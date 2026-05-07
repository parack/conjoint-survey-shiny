# crop_audio.R
# Ritaglia tutti gli MP3 in audio_raw/ a 45 secondi con fade in/out 2s.
# Modifica FFMPEG_PATH e le cartelle se necessario.

# ── Configura qui ─────────────────────────────────────────────────────────────
FFMPEG_PATH <- "ffmpeg"   # se ffmpeg è nel PATH di sistema
# FFMPEG_PATH <- "C:/path/to/ffmpeg.exe"  # altrimenti percorso assoluto

input_dir  <- "www/audio_raw"   # MP3 originali (non in repo)
output_dir <- "www/audio"       # MP3 croppati (in repo, max ~20MB)

# ── Crop ──────────────────────────────────────────────────────────────────────
dir.create(output_dir, showWarnings = FALSE)

files <- list.files(input_dir, pattern = "\\.mp3$", full.names = TRUE)
cat("File trovati:", length(files), "\n\n")

for (f in files) {
  fname  <- basename(f)
  output <- file.path(output_dir, fname)

  cmd <- sprintf(
    '"%s" -ss 45 -i "%s" -t 45 -map 0:a -af "afade=t=in:st=0:d=2,afade=t=out:st=43:d=2" -q:a 2 "%s" -y',
    FFMPEG_PATH, f, output
  )

  system(cmd)
  cat("✓", fname, "\n")
}

cat("\nFatto! File croppati:", length(files), "\n")
