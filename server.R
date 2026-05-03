server <- function(input, output, session) {

  # ── Language (from URL ?lang=XX, fixed for the whole session) ─────────────
  .q        <- parseQueryString(isolate(session$clientData$url_search))
  .lang     <- if (!is.null(.q$lang) && .q$lang %in% c("it","en","fr")) .q$lang else "it"
  .has_lang <- !is.null(.q$lang) && .q$lang %in% c("it","en","fr")

  # Shortcut: tr() returns TR[[.lang]] — a plain function call, not reactive
  tr <- TR[[.lang]]

  # ── Session-level state ────────────────────────────────────────────────────
  ts_start <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  resp_id  <- paste0("R", format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000L:9999L, 1L))

  rv <- reactiveValues(
    page                = if (.has_lang) "intro" else "lang",
    lang                = .lang,
    cbc_design          = generate_cbc_design(),
    cbc_task            = 1L,
    cbc_choices         = integer(N_TASKS),   # 0 = not yet answered
    audio_order         = sample(1L:4L),      # randomized presentation of 4 clips
    d_index             = NA_real_,
    gaais_pos           = NA_real_,
    gaais_neg           = NA_real_,
    cbc_answers_written = FALSE               # guard against duplicate Survey_Answers write
  )

  # ── Helpers ────────────────────────────────────────────────────────────────
  # persist = FALSE suppresses the localStorage page update (used on go_to("thankyou")
  # after clearSavedState has already been sent, and on restore-driven navigation).
  go_to <- function(new_page, persist = TRUE) {
    hide(paste0("page_", rv$page))
    show(paste0("page_", new_page))
    rv$page <- new_page
    runjs("window.scrollTo(0, 0);")
    if (persist) session$sendCustomMessage("persistState", list(page = new_page))
  }

  set_progress <- function(pct) {
    runjs(sprintf(
      "document.getElementById('progress-bar-inner').style.width = '%s%%';", pct
    ))
  }

  err <- function(msg) showNotification(msg, type = "error", duration = 4L)

  gs_append <- function(sheet, data) {
    tryCatch(
      sheet_append(ss = SHEET_ID, sheet = sheet, data = data),
      error = function(e) message("[GSheets] ", sheet, ": ", e$message)
    )
  }

  # ── Format a price in the session language ─────────────────────────────────
  fmt_price <- function(price) {
    p_str <- formatC(price, format = "f", digits = 2)
    # Replace decimal point with locale separator
    p_str <- gsub(".", tr$decimal_sep, p_str, fixed = TRUE)
    paste0("€", p_str, tr$per_month)
  }

  # ── Session init: send identifiers to JS localStorage ─────────────────────
  # persistStateInit only writes if no prior session exists (reconnect-safe).
  session$sendCustomMessage("persistStateInit", list(
    resp_id         = resp_id,
    lang            = .lang,
    audio_order     = as.list(rv$audio_order),
    cbc_design_flat = as.list(unlist(lapply(rv$cbc_design, function(df) {
      as.integer(unlist(t(df[, c("a1", "a2", "a3", "a4")])))
    })))
  ))

  # ── Restore handler: fires once on reconnect ───────────────────────────────
  # JS sends __restored_state__ (JSON string) on shiny:connected if localStorage
  # contains a prior resp_id.  We parse it and restore all session state.
  observeEvent(input[["__restored_state__"]], once = TRUE, {
    raw <- input[["__restored_state__"]]
    if (is.null(raw) || nchar(raw) < 5L) return()

    state <- tryCatch(
      jsonlite::fromJSON(raw, simplifyDataFrame = FALSE, simplifyVector = TRUE),
      error = function(e) { message("[Restore] JSON error: ", e$message); NULL }
    )
    if (is.null(state) || is.null(state$resp_id)) return()

    # Adopt saved identifiers
    resp_id <<- state$resp_id

    if (!is.null(state$audio_order) && length(state$audio_order) == 4L)
      rv$audio_order <- as.integer(state$audio_order)

    # Rebuild CBC design from flat int array (N_TASKS * N_ALTS * 4 integers)
    n_flat <- N_TASKS * N_ALTS * 4L
    if (!is.null(state$cbc_design_flat) && length(state$cbc_design_flat) == n_flat) {
      flat <- as.integer(state$cbc_design_flat)
      rv$cbc_design <- lapply(seq_len(N_TASKS), function(t_idx) {
        start <- (t_idx - 1L) * N_ALTS * 4L + 1L
        df    <- as.data.frame(matrix(
          flat[start:(start + N_ALTS * 4L - 1L)],
          nrow = N_ALTS, ncol = 4L, byrow = TRUE
        ))
        colnames(df) <- c("a1", "a2", "a3", "a4")
        df
      })
    }

    # Restore computed scores
    if (!is.null(state$d_index))   rv$d_index   <- as.numeric(state$d_index)
    if (!is.null(state$gaais_pos)) rv$gaais_pos <- as.numeric(state$gaais_pos)
    if (!is.null(state$gaais_neg)) rv$gaais_neg <- as.numeric(state$gaais_neg)

    # Restore CBC choices vector
    if (!is.null(state$cbc_choices)) {
      choices <- integer(N_TASKS)
      for (nm in names(state$cbc_choices)) {
        t_idx <- suppressWarnings(as.integer(sub("^t", "", nm)))
        if (!is.na(t_idx) && t_idx >= 1L && t_idx <= N_TASKS)
          choices[t_idx] <- as.integer(state$cbc_choices[[nm]])
      }
      rv$cbc_choices <- choices
    }
    if (!is.null(state$cbc_task))
      rv$cbc_task <- max(1L, min(N_TASKS, as.integer(state$cbc_task)))

    # Guard flag — prevents double-write of Survey_Answers
    if (isTRUE(state$cbc_answers_written))
      rv$cbc_answers_written <- TRUE

    # Restore native Shiny inputs (dropdowns, radioButtons)
    ans <- state$answers
    if (!is.null(ans)) {
      if (!is.null(ans$dsp_user))
        updateRadioButtons(session, "dsp_user", selected = ans$dsp_user)
      for (nm in c("dsp_current", "dsp_tier",
                   "demo_age", "demo_gender", "demo_country", "demo_education")) {
        raw_nm <- ans[[nm]]
        if (is.null(raw_nm)) next                # missing key → skip
        coerced <- as.character(raw_nm)
        if (length(coerced) == 0L || !nzchar(coerced)) next  # character(0) or "" → skip
        updateSelectInput(session, nm, selected = coerced)
      }
    }

    # Navigate to the saved page
    target <- if (!is.null(state$page)) state$page else "intro"

    if (target == "thankyou") {
      # Survey already completed — wipe state and show thank-you without re-persisting
      session$sendCustomMessage("clearSavedState", list())
      go_to("thankyou", persist = FALSE)
      set_progress(100)
      return()
    }

    restorable <- c("audio", "gaais", "framing", "cbc", "proxy", "demo")
    if (target %in% restorable) {
      go_to(target, persist = FALSE)   # navigation already saved; don't double-write
      base_pct <- c(audio = 12L, gaais = 25L, framing = 38L,
                    cbc   = 45L, proxy = 72L, demo    = 85L)[[target]]
      if (target == "cbc") {
        tasks_done <- sum(rv$cbc_choices > 0L)
        base_pct   <- 45L + round((tasks_done / N_TASKS) * 25L)
      }
      set_progress(base_pct)
    }

    # Re-check btn-check inputs (audio ratings, GAAIS, proxy) via JS
    native_inputs <- c("dsp_user", "dsp_current", "dsp_tier",
                       "demo_age", "demo_gender", "demo_country", "demo_education")
    if (!is.null(ans)) {
      btn_ans <- ans[!names(ans) %in% native_inputs]
      for (nm in names(btn_ans)) {
        raw_val <- btn_ans[[nm]]
        if (is.null(raw_val)) next               # JSON null → skip silently
        val <- as.character(raw_val)
        if (length(val) == 0L || !nzchar(val)) next  # character(0) or "" → skip
        runjs(sprintf(
          paste0('(function(){',
                 'var el=document.querySelector("input[name=%s][value=%s]");',
                 'if(el){el.checked=true;el.dispatchEvent(new Event("change"));}',
                 '})()'),
          jsonlite::toJSON(nm,  auto_unbox = TRUE),
          jsonlite::toJSON(val, auto_unbox = TRUE)
        ))
      }
    }

    # Re-select the current CBC card (if on CBC page)
    if (target == "cbc") {
      t_idx  <- rv$cbc_task
      choice <- rv$cbc_choices[t_idx]
      if (choice > 0L) runjs(sprintf(
        paste0('setTimeout(function(){',
               'var c=document.querySelector(".cbc-card[data-choice=\\"%d\\"][data-task=\\"%d\\"]");',
               'if(c)c.click();',
               '},300);'),
        choice, t_idx
      ))
    }
  })

  # ── Audio clips UI ──────────────────────────────────────────────────────────
  output$audio_clips_ui <- renderUI({
    clips  <- AUDIO_CLIPS[rv$audio_order, ]
    ch     <- tr$audio_ch   # named vector: label → "4"/"3"/"2"/"1"/"5"
    # First 4 entries = scored buttons (values 4,3,2,1); 5th = noscore (value 5)
    scored_labels   <- names(ch)[1:4]
    scored_values   <- ch[1:4]
    noscore_label   <- names(ch)[5]

    lapply(seq_len(nrow(clips)), function(i) {
      div(class = "audio-clip-card",
        div(class = "clip-header",
          div(class = "clip-title", paste(tr$clip_lbl, i)),
          div(class = "clip-rated-badge", style = "display:none;", tr$clip_rated)
        ),
        tags$audio(
          id       = paste0("audio_player_", i),
          controls = NA,
          preload  = "none",
          style    = "width:100%; margin: 0.5rem 0 1rem;",
          tags$source(src = clips$file[i], type = "audio/mpeg"),
          tr$audio_msg
        ),
        # Single flex-wrap group: 4 scored + 1 noscore — wraps cleanly on mobile
        div(class = "audio-btn-group mt-2",
          lapply(seq_along(scored_labels), function(v) tagList(
            tags$input(type = "radio", class = "btn-check",
                       name  = paste0("audio_rating_", i),
                       id    = paste0("ar_", i, "_", scored_values[v]),
                       value = scored_values[v], autocomplete = "off"),
            tags$label(class = "btn btn-audio btn-sm",
                       `for` = paste0("ar_", i, "_", scored_values[v]),
                       scored_labels[v])
          )),
          tags$input(type = "radio", class = "btn-check",
                     name  = paste0("audio_rating_", i),
                     id    = paste0("ar_", i, "_5"),
                     value = "5", autocomplete = "off"),
          tags$label(class = "btn btn-noscore btn-sm",
                     `for` = paste0("ar_", i, "_5"),
                     noscore_label)
        )
      )
    })
  })

  # ── CBC task UI (re-renders on each task advance) ──────────────────────────
  output$cbc_task_ui <- renderUI({
    t    <- rv$cbc_task
    prof <- rv$cbc_design[[t]]

    prev_choice <- rv$cbc_choices[t]

    cards <- lapply(seq_len(N_ALTS), function(a) {
      p   <- prof[a, ]
      cls <- paste0("cbc-card", if (prev_choice == a) " cbc-card-selected" else "")
      div(class = cls, `data-choice` = as.character(a), `data-task` = as.character(t),
        div(class = "cbc-card-header",
            paste(tr$cbc_opt, LETTERS[a])),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc attr-lbl-a", tr$cbc_a1lbl),
          div(class = paste0("attr-value-cbc lv lv-a", p$a1), tr$A1[p$a1])
        ),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc attr-lbl-b", tr$cbc_a2lbl),
          div(class = paste0("attr-value-cbc lv lv-b", p$a2), tr$A2[p$a2])
        ),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc attr-lbl-c", tr$cbc_a3lbl),
          div(class = paste0("attr-value-cbc lv lv-c", p$a3), tr$A3[p$a3])
        ),
        div(class = "price-display", fmt_price(A4_PRICES[p$a4]))
      )
    })

    # Task progress dots (top-right)
    dots <- lapply(seq_len(N_TASKS), function(j) {
      cls <- if (j < t) "task-dot dot-done"
             else if (j == t) "task-dot dot-current"
             else "task-dot dot-pending"
      tags$span(class = cls, title = paste("Task", j))
    })

    tagList(
      div(class = "survey-header",
        div(class = "cbc-task-header d-flex justify-content-between align-items-center mb-2",
          div(class = "page-badge mb-0", tr$cbc_badge),
          div(class = "d-flex align-items-center gap-2",
            tags$span(class = "text-muted small fw-semibold", paste0(t, " / ", N_TASKS)),
            div(class = "task-dots-row mb-0", dots)
          )
        ),
        h4(tr$cbc_q),
        p(class = "text-muted", tr$cbc_instr),
        if (t > 1L) p(class = "text-muted fst-italic small", tr$cbc_instr_cont) else NULL
      ),
      div(class = "cbc-cards", cards)
    )
  })

  # ═══════════════════════════════════════════════════════════════════════════
  # Navigation handlers
  # ═══════════════════════════════════════════════════════════════════════════

  # INTRO → AUDIO
  observeEvent(input$btn_intro_next, {
    if (!isTRUE(input$consent_check)) {
      err(tr$err_consent); return()
    }
    go_to("audio")
    set_progress(12)
    session$sendCustomMessage("surveyStarted", list())  # activates beforeunload warning
  })

  # AUDIO → GAAIS
  observeEvent(input$btn_audio_next, {
    ratings <- sapply(1L:4L, function(i) input[[paste0("audio_rating_", i)]])
    if (any(sapply(ratings, is.null))) {
      err(tr$err_audio); return()
    }
    ratings_int   <- as.integer(unlist(ratings))
    ordered_types <- AUDIO_CLIPS$type[rv$audio_order]
    rv$d_index    <- compute_d_index(ratings_int, ordered_types)
    session$sendCustomMessage("persistState", list(d_index = rv$d_index))
    go_to("gaais")
    set_progress(25)
  })

  # GAAIS → FRAMING
  observeEvent(input$btn_gaais_next, {
    responses <- sapply(GAAIS_ITEMS$code, function(code) input[[paste0("gaais_", code)]])
    if (any(sapply(responses, is.null))) {
      err(tr$err_gaais); return()
    }
    g            <- score_gaais(unlist(responses))
    rv$gaais_pos <- g$pos
    rv$gaais_neg <- g$neg
    session$sendCustomMessage("persistState", list(gaais_pos = rv$gaais_pos,
                                                   gaais_neg = rv$gaais_neg))
    go_to("framing")
    set_progress(38)
  })

  # FRAMING → CBC  (no network call — design written at submit)
  observeEvent(input$btn_framing_next, {
    rv$cbc_task <- 1L
    go_to("cbc")
    set_progress(45)
  })

  # CBC: advance task or exit to proxy
  observeEvent(input$btn_cbc_next, {
    t      <- rv$cbc_task
    choice <- input[[paste0("cbc_choice_", t)]]
    if (is.null(choice) || choice == "") {
      err(tr$err_cbc); return()
    }
    rv$cbc_choices[t] <- as.integer(choice)

    if (t < N_TASKS) {
      rv$cbc_task <- t + 1L
      session$sendCustomMessage("persistState", list(cbc_task = t + 1L))
      set_progress(45L + round((t / N_TASKS) * 25L))
      runjs("setTimeout(function(){ document.body.scrollTop=0; document.documentElement.scrollTop=0; }, 120);")
      # Re-enable the Next button immediately (spinner was set by client-side JS)
      runjs("(function(){
        var b = document.getElementById('btn_cbc_next');
        if (b) {
          b.disabled = false;
          var orig = b.getAttribute('data-orig-html');
          if (orig) b.innerHTML = orig;
        }
      })();")
    } else {
      # All tasks done — write Survey_Answers once (guard prevents duplicate on reconnect)
      if (!rv$cbc_answers_written) {
        local({
          answers <- as.data.frame(t(rv$cbc_choices))
          colnames(answers) <- paste0("choice_", seq_len(N_TASKS))
          answers <- cbind(data.frame(respondent_id = resp_id, stringsAsFactors = FALSE), answers)
          later::later(function() gs_append("Survey_Answers", answers), delay = 0)
        })
        rv$cbc_answers_written <- TRUE
        session$sendCustomMessage("persistState", list(cbc_answers_written = TRUE))
      }
      go_to("proxy")
      set_progress(72)
    }
  })

  # PROXY → DEMO
  observeEvent(input$btn_proxy_next, {
    proxy_vals <- sapply(PROXY_ITEMS$code, function(code) input[[code]])
    churn      <- input$churn_intent
    # music_freq only required when dsp_user == "yes" (shown conditionally)
    behav_codes <- if (!is.null(input$dsp_user) && input$dsp_user == "yes")
                     c("music_freq", "ai_awareness") else "ai_awareness"
    behav <- sapply(behav_codes, function(x) input[[x]])
    if (any(sapply(proxy_vals, is.null)) || is.null(churn) || any(sapply(behav, is.null))) {
      err(tr$err_proxy); return()
    }
    # Validate DSP
    if (is.null(input$dsp_user)) {
      err(tr$err_dsp_user); return()
    }
    if (input$dsp_user == "yes") {
      if (is.null(input$dsp_current) || input$dsp_current == "") {
        err(tr$err_dsp_svc); return()
      }
      if (is.null(input$dsp_tier) || input$dsp_tier == "") {
        err(tr$err_dsp_tier); return()
      }
    }
    go_to("demo")
    set_progress(85)
  })

  # DEMO → THANKYOU (final save)
  observeEvent(input$btn_demo_submit, {

    # ── Validate demographics ────────────────────────────────────────────────
    if (input$demo_age == "" || input$demo_gender == "" ||
        input$demo_education == "" || input$demo_country == "") {
      err(tr$err_demo_req); return()
    }

    # ── Collect audio raw ratings ────────────────────────────────────────────
    audio_ratings <- sapply(1L:4L, function(i) as.integer(input[[paste0("audio_rating_", i)]]))
    audio_df <- setNames(
      as.data.frame(t(audio_ratings)),
      paste0("audio_clip", 1L:4L, "_rating")
    )
    audio_type_df <- setNames(
      as.data.frame(t(AUDIO_CLIPS$type[rv$audio_order])),
      paste0("audio_clip", 1L:4L, "_type")
    )

    # ── Collect GAAIS raw responses ──────────────────────────────────────────
    gaais_raw <- sapply(GAAIS_ITEMS$code, function(code) as.integer(input[[paste0("gaais_", code)]]))
    gaais_df  <- setNames(
      as.data.frame(t(gaais_raw)),
      paste0("gaais_", GAAIS_ITEMS$code)
    )

    # ── Collect proxy responses ──────────────────────────────────────────────
    proxy_vals <- sapply(PROXY_ITEMS$code, function(code) as.integer(input[[code]]))
    proxy_df   <- setNames(as.data.frame(t(proxy_vals)), PROXY_ITEMS$code)

    # ── Build Demography row ─────────────────────────────────────────────────
    demo_row <- cbind(
      data.frame(respondent_id = resp_id, lang = .lang, stringsAsFactors = FALSE),
      audio_df,
      audio_type_df,
      data.frame(d_index = rv$d_index),
      gaais_df,
      data.frame(gaais_pos = rv$gaais_pos, gaais_neg = rv$gaais_neg),
      proxy_df,
      data.frame(
        churn_intent = as.integer(input$churn_intent),
        music_freq   = if (!is.null(input$dsp_user) && input$dsp_user == "yes") input$music_freq else "",
        ai_awareness = input$ai_awareness,
        dsp_user         = input$dsp_user,
        dsp_current      = if (isTRUE(input$dsp_user == "yes")) input$dsp_current else "",
        dsp_tier         = if (isTRUE(input$dsp_user == "yes")) input$dsp_tier    else "",
        age              = input$demo_age,
        gender           = input$demo_gender,
        education        = input$demo_education,
        country          = input$demo_country,
        stringsAsFactors = FALSE
      )
    )

    ts_complete <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

    # Build Choices rows (one row per alternative per task)
    choices_rows <- do.call(rbind, lapply(seq_len(N_TASKS), function(t) {
      prof <- rv$cbc_design[[t]]
      do.call(rbind, lapply(seq_len(N_ALTS), function(a) {
        p <- prof[a, ]
        data.frame(
          respondent_id = resp_id,
          task          = t,
          alt           = a,
          a1_labeling   = tr$A1[p$a1],
          a2_promotion  = tr$A2[p$a2],
          a3_control    = tr$A3[p$a3],
          a4_price      = A4_PRICES[p$a4],
          stringsAsFactors = FALSE
        )
      }))
    }))

    # Clear localStorage before navigating (prevents restore on future visits)
    session$sendCustomMessage("clearSavedState", list())

    # Navigate first, then write all sheets after the flush (non-blocking)
    # Survey_Answers was already written when the last CBC task was completed
    go_to("thankyou", persist = FALSE)
    set_progress(100)
    session$sendCustomMessage("surveyComplete", list())  # disables beforeunload warning
    later::later(function() {
      gs_append("Choices",   choices_rows)
      gs_append("Demography", demo_row)
      gs_append("Respondents", data.frame(
        respondent_id      = resp_id,
        lang               = .lang,
        timestamp_start    = ts_start,
        timestamp_complete = ts_complete,
        completed          = "TRUE",
        stringsAsFactors   = FALSE
      ))
    }, delay = 0)
  })
}
