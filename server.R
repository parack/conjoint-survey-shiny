server <- function(input, output, session) {

  # ── Session-level state ────────────────────────────────────────────────────
  ts_start <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  resp_id  <- paste0("R", format(Sys.time(), "%Y%m%d%H%M%S"), sample(1000L:9999L, 1L))

  rv <- reactiveValues(
    page        = "intro",
    cbc_design  = generate_cbc_design(),
    cbc_task    = 1L,
    cbc_choices = integer(N_TASKS),   # 0 = not yet answered
    audio_order = sample(1L:4L),      # randomized presentation of 4 clips
    d_index     = NA_real_,
    gaais_pos   = NA_real_,
    gaais_neg   = NA_real_
  )

  # ── Helpers ────────────────────────────────────────────────────────────────
  go_to <- function(new_page) {
    hide(paste0("page_", rv$page))
    show(paste0("page_", new_page))
    rv$page <- new_page
    runjs("window.scrollTo(0, 0);")
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

  # ── Audio clips UI ──────────────────────────────────────────────────────────
  output$audio_clips_ui <- renderUI({
    clips <- AUDIO_CLIPS[rv$audio_order, ]
    lapply(seq_len(nrow(clips)), function(i) {
      div(class = "audio-clip-card",
        div(class = "clip-header",
          div(class = "clip-title", paste("Clip", i)),
          div(class = "clip-rated-badge", style = "display:none;", "Valutata")
        ),
        tags$audio(
          id       = paste0("audio_player_", i),
          controls = NA,
          preload  = "metadata",
          style    = "width:100%; margin: 0.5rem 0 1rem;",
          tags$source(src = clips$file[i], type = "audio/mpeg"),
          "Il tuo browser non supporta la riproduzione audio."
        ),
        div(class = "audio-rating-wrap",
          radioButtons(
            inputId  = paste0("audio_rating_", i),
            label    = NULL,
            choices  = AUDIO_CHOICES,
            selected = character(0),
            inline   = TRUE
          )
        )
      )
    })
  })

  # ── CBC task UI (re-renders on each task advance) ──────────────────────────
  output$cbc_task_ui <- renderUI({
    t    <- rv$cbc_task
    prof <- rv$cbc_design[[t]]

    cards <- lapply(seq_len(N_ALTS), function(a) {
      p <- prof[a, ]
      div(class = "cbc-card",
        div(class = "cbc-card-header", paste("Opzione", LETTERS[a])),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc", "Policy labeling AI"),
          div(class = "attr-value-cbc", A1_LEVELS[p$a1])
        ),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc", "Struttura promozionale"),
          div(class = "attr-value-cbc", A2_LEVELS[p$a2])
        ),
        div(class = "attr-row-cbc",
          div(class = "attr-label-cbc", "Controllo utente"),
          div(class = "attr-value-cbc", A3_LEVELS[p$a3])
        ),
        div(class = "price-display", sprintf("€%.2f/mese", A4_PRICES[p$a4]))
      )
    })

    prev_choice <- rv$cbc_choices[t]

    # Task progress dots
    dots <- lapply(seq_len(N_TASKS), function(j) {
      cls <- if (j < t) "task-dot dot-done" else if (j == t) "task-dot dot-current" else "task-dot dot-pending"
      tags$span(class = cls, title = paste("Task", j))
    })

    tagList(
      div(class = "survey-header",
        div(class = "page-badge",
          paste0("Sezione 3 di 5 — Scelta ", t, " di ", N_TASKS)
        ),
        div(class = "task-dots-row", dots),
        h4("Quale di queste configurazioni di abbonamento preferiresti?"),
        p(class = "text-muted",
          "Le 3 alternative differiscono per policy AI e prezzo. ",
          "Scegli quella che preferiresti realmente adottare.")
      ),
      div(class = "cbc-cards", cards),
      div(class = "cbc-choice-section",
        radioButtons(
          inputId  = paste0("cbc_choice_", t),
          label    = strong("La mia preferenza:"),
          choices  = setNames(as.character(1L:3L), paste("Opzione", LETTERS[1L:3L])),
          selected = if (prev_choice > 0L) as.character(prev_choice) else character(0),
          inline   = TRUE
        )
      )
    )
  })

  # ═══════════════════════════════════════════════════════════════════════════
  # Navigation handlers
  # ═══════════════════════════════════════════════════════════════════════════

  # INTRO → AUDIO
  observeEvent(input$btn_intro_next, {
    if (!isTRUE(input$consent_check)) {
      err("Devi acconsentire alla partecipazione per continuare.")
      return()
    }
    go_to("audio")
    set_progress(12)
  })

  # AUDIO → GAAIS
  observeEvent(input$btn_audio_next, {
    ratings <- sapply(1L:4L, function(i) input[[paste0("audio_rating_", i)]])
    if (any(sapply(ratings, is.null))) {
      err("Valuta tutte e 4 le clip prima di procedere.")
      return()
    }
    ratings_int    <- as.integer(unlist(ratings))
    ordered_types  <- AUDIO_CLIPS$type[rv$audio_order]
    rv$d_index     <- compute_d_index(ratings_int, ordered_types)
    go_to("gaais")
    set_progress(25)
  })

  # GAAIS → FRAMING
  observeEvent(input$btn_gaais_next, {
    responses <- sapply(GAAIS_ITEMS$code, function(code) input[[paste0("gaais_", code)]])
    if (any(sapply(responses, is.null))) {
      err("Rispondi a tutti gli item prima di procedere.")
      return()
    }
    g            <- score_gaais(unlist(responses))
    rv$gaais_pos <- g$pos
    rv$gaais_neg <- g$neg
    go_to("framing")
    set_progress(38)
  })

  # FRAMING → CBC (write Choices sheet with full design)
  observeEvent(input$btn_framing_next, {
    choices_rows <- do.call(rbind, lapply(seq_len(N_TASKS), function(t) {
      prof <- rv$cbc_design[[t]]
      do.call(rbind, lapply(seq_len(N_ALTS), function(a) {
        p <- prof[a, ]
        data.frame(
          respondent_id = resp_id,
          task          = t,
          alt           = a,
          a1_labeling   = paste0("L", p$a1),
          a2_promotion  = paste0("L", p$a2),
          a3_control    = paste0("L", p$a3),
          a4_price      = A4_PRICES[p$a4],
          stringsAsFactors = FALSE
        )
      }))
    }))
    gs_append("Choices", choices_rows)

    rv$cbc_task <- 1L
    go_to("cbc")
    set_progress(45)
  })

  # CBC: advance task or exit to proxy
  observeEvent(input$btn_cbc_next, {
    t      <- rv$cbc_task
    choice <- input[[paste0("cbc_choice_", t)]]
    if (is.null(choice) || choice == "") {
      err("Seleziona un'opzione prima di procedere.")
      return()
    }
    rv$cbc_choices[t] <- as.integer(choice)

    if (t < N_TASKS) {
      rv$cbc_task <- t + 1L
      set_progress(45L + round((t / N_TASKS) * 25L))
    } else {
      # All tasks done — write Survey_Answers
      answers <- as.data.frame(t(rv$cbc_choices))
      colnames(answers) <- paste0("choice_", seq_len(N_TASKS))
      answers <- cbind(data.frame(respondent_id = resp_id, stringsAsFactors = FALSE), answers)
      gs_append("Survey_Answers", answers)

      go_to("proxy")
      set_progress(72)
    }
  })

  # PROXY → DEMO
  observeEvent(input$btn_proxy_next, {
    proxy_vals <- sapply(PROXY_ITEMS$code, function(code) input[[code]])
    churn      <- input$churn_intent
    if (any(sapply(proxy_vals, is.null)) || is.null(churn)) {
      err("Rispondi a tutti gli item prima di procedere.")
      return()
    }
    go_to("demo")
    set_progress(85)
  })

  # DEMO → THANKYOU (final save)
  observeEvent(input$btn_demo_submit, {

    # ── Validate demographics ────────────────────────────────────────────────
    if (input$demo_age == "" || input$demo_gender == "" || input$demo_education == "") {
      err("Compila tutti i campi demografici obbligatori (*).")
      return()
    }
    if (is.null(input$dsp_user)) {
      err("Indica se utilizzi un servizio di streaming musicale.")
      return()
    }
    if (input$dsp_user == "yes") {
      if (is.null(input$dsp_current) || input$dsp_current == "") {
        err("Indica il servizio di streaming che utilizzi principalmente.")
        return()
      }
      if (is.null(input$dsp_tier) || input$dsp_tier == "") {
        err("Indica il tipo di abbonamento.")
        return()
      }
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
      data.frame(respondent_id = resp_id, stringsAsFactors = FALSE),
      audio_df,
      audio_type_df,
      data.frame(d_index = rv$d_index),
      gaais_df,
      data.frame(gaais_pos = rv$gaais_pos, gaais_neg = rv$gaais_neg),
      proxy_df,
      data.frame(
        churn_intent  = as.integer(input$churn_intent),
        dsp_user      = input$dsp_user,
        dsp_current   = if (input$dsp_user == "yes") input$dsp_current  else NA_character_,
        dsp_tier      = if (input$dsp_user == "yes") input$dsp_tier     else NA_character_,
        age           = input$demo_age,
        gender        = input$demo_gender,
        education     = input$demo_education,
        stringsAsFactors = FALSE
      )
    )

    ts_complete <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

    # ── Write Demography ─────────────────────────────────────────────────────
    gs_append("Demography", demo_row)

    # ── Write Respondents (one row with both timestamps) ─────────────────────
    gs_append("Respondents", data.frame(
      respondent_id      = resp_id,
      timestamp_start    = ts_start,
      timestamp_complete = ts_complete,
      completed          = TRUE,
      stringsAsFactors   = FALSE
    ))

    go_to("thankyou")
    set_progress(100)
  })
}
