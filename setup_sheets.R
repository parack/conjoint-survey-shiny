# Run this script ONCE before launching the survey app.
# It creates the 4 required tabs in the Google Sheet with the correct headers.

source("global.R")   # loads auth + SHEET_ID + item definitions

# ── Expected headers per tab ───────────────────────────────────────────────────

headers <- list(

  Respondents = data.frame(
    respondent_id      = character(),
    lang               = character(),
    utm_source         = character(),
    timestamp_start    = character(),
    timestamp_complete = character(),
    completed          = character(),
    stringsAsFactors   = FALSE
  ),

  Survey_Answers = {
    cols <- c("respondent_id", paste0("choice_", 1:N_TASKS))
    setNames(as.data.frame(matrix(character(0), ncol = length(cols))), cols)
  },

  Choices = data.frame(
    respondent_id = character(),
    task          = integer(),
    alt           = integer(),
    a1_labeling   = character(),
    a2_promotion  = character(),
    a3_control    = character(),
    a4_price      = numeric(),
    stringsAsFactors = FALSE
  ),

  Demography = {
    audio_cols    <- c(
      paste0("audio_clip", 1:4, "_rating"),
      paste0("audio_clip", 1:4, "_type"),
      paste0("audio_clip", 1:4, "_play_count")
    )
    gaais_cols    <- paste0("gaais_", GAAIS_ITEMS$code)
    proxy_cols    <- PROXY_ITEMS$code   # proxy_p1 … proxy_p6
    proxy6_cols   <- c("proxy_p6","proxy_p6_raw")
    other_cols    <- c("churn_intent","switching_past","switching_reason",
                       "dsp_user","dsp_current","dsp_tier",
                       "year_birth","gender","role","country")
    all_cols      <- c("respondent_id", "lang", audio_cols, "d_index",
                       gaais_cols, "gaais_pos","gaais_neg",
                       proxy_cols, proxy6_cols, other_cols)
    setNames(as.data.frame(matrix(character(0), ncol = length(all_cols))), all_cols)
  },

  # ── Feedback: free-text comments left by respondents on the thank-you page ──
  Feedback = data.frame(
    respondent_id = character(),
    lang          = character(),
    utm_source    = character(),
    ts            = character(),
    feedback_text = character(),
    stringsAsFactors = FALSE
  ),

  # ── Funnel: one row per navigation event (step-by-step dropout tracking) ──
  # The very first event of every session is `session_start`, logged immediately
  # at app load. Dropouts are detectable as session_start without a subsequent
  # `completed` event. utm_source carries the URL traffic-source tag.
  # duration_sec = seconds spent in the section that just ended (= time since
  # the previous funnel event for the same respondent, or since session start
  # for the first event).
  Funnel = data.frame(
    respondent_id = character(),
    lang          = character(),
    utm_source    = character(),
    event         = character(),
    detail        = character(),
    ts            = character(),
    duration_sec  = integer(),
    stringsAsFactors = FALSE
  ),

  # ── Partial: snapshot after proxy section (survives abandonment at demo) ──
  Partial = {
    audio_cols  <- c(paste0("audio_clip", 1:4, "_rating"),
                     paste0("audio_clip", 1:4, "_type"),
                     paste0("audio_clip", 1:4, "_play_count"))
    gaais_cols  <- paste0("gaais_", GAAIS_ITEMS$code)
    proxy_cols  <- PROXY_ITEMS$code
    choice_cols <- paste0("choice_", seq_len(N_TASKS))
    proxy6_cols <- c("proxy_p6","proxy_p6_raw")
    dsp_cols    <- c("churn_intent","switching_past","switching_reason",
                     "dsp_user","dsp_current","dsp_tier")
    all_cols    <- c("respondent_id","lang","ts",
                     audio_cols, "d_index","gaais_pos","gaais_neg",
                     gaais_cols, proxy_cols, proxy6_cols, choice_cols, dsp_cols)
    setNames(as.data.frame(matrix(character(0), ncol = length(all_cols))), all_cols)
  }
)

# ── Existing tabs in the sheet ─────────────────────────────────────────────────
existing_tabs <- sheet_names(SHEET_ID)
cat("Existing tabs:", paste(existing_tabs, collapse=", "), "\n\n")

# ── Create or verify each tab ─────────────────────────────────────────────────
for (tab_name in names(headers)) {
  hdr <- headers[[tab_name]]

  if (tab_name %in% existing_tabs) {
    # Tab exists — check first row for headers
    existing <- tryCatch(
      read_sheet(SHEET_ID, sheet = tab_name, n_max = 1, col_names = TRUE),
      error = function(e) NULL
    )
    existing_cols <- if (!is.null(existing) && nrow(existing) >= 0) names(existing) else character(0)
    expected_cols <- names(hdr)

    # Tab is empty (no headers yet) — write them
    if (length(existing_cols) == 0) {
      sheet_write(hdr, ss = SHEET_ID, sheet = tab_name)
      cat("[HEADERS] ", tab_name, "— headers written (", ncol(hdr), "columns)\n")
      next
    }

    missing <- setdiff(expected_cols, existing_cols)
    extra   <- setdiff(existing_cols, expected_cols)

    if (length(missing) == 0 && length(extra) == 0) {
      cat("[OK]     ", tab_name, "— headers match\n")
    } else {
      cat("[WARN]   ", tab_name, "— header mismatch\n")
      if (length(missing) > 0) cat("  Missing columns:", paste(missing, collapse=", "), "\n")
      if (length(extra)   > 0) cat("  Extra columns  :", paste(extra,   collapse=", "), "\n")
      cat("  -> Clear the tab manually and re-run this script to reset headers.\n")
    }

  } else {
    # Tab does not exist — create it with headers
    sheet_add(SHEET_ID, sheet = tab_name)
    sheet_write(hdr, ss = SHEET_ID, sheet = tab_name)
    cat("[CREATED]", tab_name, "— tab created with", ncol(hdr), "columns\n")
  }
}

cat("\nSetup complete. You can now run the survey app.\n")
