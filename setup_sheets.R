# Run this script ONCE before launching the survey app.
# It creates the 4 required tabs in the Google Sheet with the correct headers.

source("global.R")   # loads auth + SHEET_ID + item definitions

# ── Expected headers per tab ───────────────────────────────────────────────────

headers <- list(

  Respondents = data.frame(
    respondent_id      = character(),
    timestamp_start    = character(),
    timestamp_complete = character(),
    completed          = logical(),
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
    audio_cols    <- paste0(rep(c("audio_clip","audio_clip"), each=4), 1:4,
                            rep(c("_rating","_type"), each=4))
    gaais_cols    <- paste0("gaais_", GAAIS_ITEMS$code)
    proxy_cols    <- PROXY_ITEMS$code
    other_cols    <- c("churn_intent","dsp_user","dsp_current","dsp_tier",
                       "age","gender","education")
    all_cols      <- c("respondent_id", audio_cols, "d_index",
                       gaais_cols, "gaais_pos","gaais_neg",
                       proxy_cols, other_cols)
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
