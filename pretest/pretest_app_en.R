library(shiny)
library(bslib)
library(shinyjs)
library(googlesheets4)
library(dplyr)

# ── Config ────────────────────────────────────────────────────────────────────
SHEET_ID  <- "1oVruAANYslwX066U3YcqhCYJd5Mxol1fBe0A-J9XlsY"
N_CLIPS   <- 10L        # clips shown per participant (random subset of 20)
MAX_SCORE <- 30L        # 3 pts × 10 clips

gs4_auth(path = "service_account.json")

ALL_CLIPS <- data.frame(
  clip_id = c(sprintf("ai_%02d", 1:10), sprintf("hu_%02d", 1:10)),
  type    = c(rep("AI", 10), rep("HUMAN", 10)),
  file    = c(sprintf("audio/ai_%02d.mp3", 1:10), sprintf("audio/hu_%02d.mp3", 1:10)),
  stringsAsFactors = FALSE
)

# ── Sheet init ────────────────────────────────────────────────────────────────
tryCatch({
  if (!"Responses_Short_EN" %in% sheet_names(SHEET_ID)) {
    sheet_add(SHEET_ID, sheet = "Responses_Short_EN")
    sheet_write(
      data.frame(
        timestamp    = character(), session_id = character(),
        utm_source   = character(), clip_id    = character(),
        clip_type    = character(), position   = integer(),
        rating       = integer(),  nonso       = logical(),
        points       = integer(),  correct     = logical(),
        play_count   = integer(),  self_ability = integer()
      ),
      ss = SHEET_ID, sheet = "Responses_Short_EN"
    )
  }
}, error = function(e) warning("Sheet init: ", e$message))

# ── Helpers ───────────────────────────────────────────────────────────────────
score_clip <- function(type, rating_val) {
  r <- as.integer(rating_val)
  if (r == 5L) return(0L)
  if (type == "AI") r - 1L else 4L - r
}

correct_clip <- function(type, rating_val) {
  r <- as.integer(rating_val)
  if (r == 5L) return(FALSE)
  if (type == "AI") r >= 3L else r <= 2L
}

player_profile <- function(score) {
  profiles <- list(
    list(thr = 30, emoji = "🏆", title = "Perfect Ear",
         desc  = "Flawless. Apply to Deezer as AI-detection lead."),
    list(thr = 25, emoji = "🎼", title = "Music Sommelier",
         desc  = "You'd tell a vintage from a knockoff by the first bar."),
    list(thr = 20, emoji = "🎧", title = "Critic in Training",
         desc  = "You sense something is off. Keep sharpening that ear."),
    list(thr = 15, emoji = "🕵️", title = "Suspicious Bloodhound",
         desc  = "Your musical instinct is waking up."),
    list(thr = 10, emoji = "😐", title = "Homo Streamingensis",
         desc  = "Average listener — like most of us. No shame."),
    list(thr =  5, emoji = "🎲", title = "Coin Flipper",
         desc  = "Results close to random chance. Maybe blame the Wi-Fi."),
    list(thr =  0, emoji = "🪵", title = "Plywood Ear",
         desc  = "The AI fooled you completely. Respect the machine.")
  )
  for (p in profiles) { if (score >= p$thr) return(p) }
  profiles[[length(profiles)]]
}

AUDIO_CHOICES <- c(
  "Definitely AI"    = "4",
  "Probably AI"      = "3",
  "Probably human"   = "2",
  "Definitely human" = "1"
)

# ── UI ────────────────────────────────────────────────────────────────────────
ui <- page_fluid(
  theme = bs_theme(
    version    = 5,
    bootswatch = "flatly",
    primary    = "#1DB954",
    font_scale = 1.05
  ),
  useShinyjs(),

  tags$head(
    tags$link(rel = "stylesheet", href = "style.css?v=1"),
    tags$style(HTML("
      .pretest-welcome { max-width: 540px; margin: 60px auto; }
      .results-score   { font-size: 3rem; font-weight: 800; color: #2563eb; }
      .likert-anchor   { font-size:0.78rem; color:#6c757d; }
      @media (max-width: 576px) {
        .audio-btn-group { flex-direction: column !important; }
        .btn-audio, .btn-noscore { width: 100% !important; text-align: center !important; }
      }
    ")),
    tags$script(HTML("
      // ── One audio at a time ────────────────────────────────────────────────
      document.addEventListener('play', function(e) {
        document.querySelectorAll('audio').forEach(function(a) {
          if (a !== e.target) { a.pause(); a.currentTime = 0; }
        });
      }, true);

      // ── Track play_count per clip ─────────────────────────────────────────
      var playCounts = {};
      document.addEventListener('play', function(e) {
        var audio = e.target;
        var idx = audio.getAttribute('data-clip-idx');
        if (idx) {
          playCounts[idx] = (playCounts[idx] || 0) + 1;
          Shiny.setInputValue('play_counts', playCounts);
        }
      }, true);

      // ── Clip-rated badge ──────────────────────────────────────────────────
      $(document).on('change', 'input.btn-check', function() {
        var card = $(this).closest('.audio-clip-card');
        if (card.length && $(this).attr('name') !== 'self_ability') {
          card.addClass('clip-rated');
          card.find('.clip-rated-badge').show();
        }
      });

      // ── Flash red border on unrated card ──────────────────────────────────
      function flashInvalid(el) {
        if (!el) return;
        el.style.outline = '2px solid #dc3545';
        el.style.borderRadius = '4px';
        setTimeout(function() {
          el.style.outline = ''; el.style.borderRadius = '';
        }, 1500);
      }

      // ── Submit validation ─────────────────────────────────────────────────
      $(document).on('click', '#btn_submit', function() {
        var ok = true;
        var n  = parseInt($('#n_clips').val() || 10);
        for (var i = 1; i <= n; i++) {
          if (!document.querySelector('input[name=\"audio_rating_' + i + '\"]:checked')) {
            var cards = document.querySelectorAll('.audio-clip-card');
            flashInvalid(cards[i]);   // cards[0] = self-ability
            ok = false;
          }
        }
        if (!document.querySelector('input[name=\"self_ability\"]:checked')) {
          flashInvalid(document.querySelectorAll('.audio-clip-card')[0]);
          ok = false;
        }
        if (!ok) {
          document.getElementById('submit_error').style.display = 'block';
          window.scrollTo(0, document.body.scrollHeight);
          return false;
        }
        document.getElementById('submit_error').style.display = 'none';
      });
    "))
  ),

  # ── Welcome page ────────────────────────────────────────────────────────────
  div(id = "page_welcome",
    div(class = "pretest-welcome",
      div(class = "survey-header text-center",
        h2(class = "intro-h2",
           "Audio Discrimination Task",
           tags$br(),
           tags$small(class = "text-muted fs-5 fw-normal",
                      "Can you tell AI music from human-made music?")
        )
      ),
      hr(),
      p("You'll hear ", tags$strong("10 short music clips"), ". For each one, ",
        "rate how confident you are that it was made by AI or by a human musician, ",
        "using a 4-point scale from ", tags$em("Definitely human"), " to ",
        tags$em("Definitely AI"), ". If you genuinely can't tell, select ",
        tags$em("'Don't know'"), "."),
      div(class = "alert alert-warning py-2 px-3", style = "font-size:0.85rem;",
          "🎧 Headphones or a quiet environment recommended. ",
          "Keep the screen active to avoid disconnections."),
      div(class = "alert alert-info py-2 px-3", style = "font-size:0.85rem;",
          tags$strong("What counts as AI music? "),
          "Music fully composed and produced by generative AI systems — ",
          "no human contribution to composition, writing, or recording. ",
          "These systems learn patterns from existing music and generate new ",
          "tracks from text prompts."),
      div(class = "nav-buttons mt-3",
        actionButton("btn_start", "Start", class = "btn btn-primary btn-lg")
      )
    )
  ),

  # ── Audio task page ──────────────────────────────────────────────────────────
  hidden(div(id = "page_audio", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "audio-header-row",
          div(class = "page-badge", "Pretest"),
          div(class = "audio-hint-chip", "🎧 Headphones recommended")
        ),
        h3("Audio Discrimination Task")
      ),
      tags$input(type = "hidden", id = "n_clips", value = as.character(N_CLIPS)),
      uiOutput("selfability_ui"),
      uiOutput("clips_ui"),
      uiOutput("submit_area_ui")
    )
  )),

  # ── Results page ─────────────────────────────────────────────────────────────
  hidden(div(id = "page_results", class = "survey-page",
    div(class = "survey-container thankyou-container text-center",
      div(class = "thankyou-icon", icon("circle-check")),
      h2("Results"),
      uiOutput("results_ui"),
      hr(),
      div(class = "alert alert-success py-2 px-3", style = "font-size:0.9rem;",
          "🙏 Thank you for participating! Your responses have been recorded.")
    )
  ))
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  session$allowReconnect("force")

  rv <- reactiveValues(
    session_id   = paste0("en_", format(Sys.time(), "%Y%m%d%H%M%S"), "_",
                          sample(1000L:9999L, 1L)),
    utm_source   = "direct",
    clip_order   = NULL,
    submitted    = FALSE,
    score        = NULL,
    n_correct    = NULL
  )

  # ── Capture UTM source from URL query string ──────────────────────────────
  observe({
    query <- parseQueryString(session$clientData$url_search)
    if (!is.null(query$utm_source) && nzchar(query$utm_source)) {
      rv$utm_source <- query$utm_source
    }
  })

  # ── Start ─────────────────────────────────────────────────────────────────
  observeEvent(input$btn_start, {
    # Stratified random sample: 5 AI + 5 Human
    ai_idx  <- which(ALL_CLIPS$type == "AI")
    hu_idx  <- which(ALL_CLIPS$type == "HUMAN")
    sel_idx <- c(sample(ai_idx, 5L), sample(hu_idx, 5L))
    rv$clip_order <- sel_idx[sample(length(sel_idx))]  # randomise order
    hide("page_welcome")
    show("page_audio")
    runjs("window.scrollTo(0,0);")
  })

  # ── Self-ability card ──────────────────────────────────────────────────────
  output$selfability_ui <- renderUI({
    req(rv$clip_order)
    div(class = "audio-clip-card",
      div(class = "clip-header",
        div(class = "clip-title",
            "How good do you think you are at telling AI music from human music?")
      ),
      div(class = "d-flex justify-content-between mt-2",
          style = "font-size:0.78rem; color:#6c757d;",
        span("Not at all"),
        span("Perfectly")
      ),
      div(style = "display:flex; justify-content:center; gap:8px; margin-top:6px;",
        lapply(1:5, function(v) tagList(
          tags$input(type = "radio", class = "btn-check",
                     name  = "self_ability",
                     id    = paste0("sa_", v),
                     value = v, autocomplete = "off"),
          tags$label(class = "btn btn-audio btn-sm",
                     `for` = paste0("sa_", v), as.character(v))
        ))
      ),
      div(id    = "selfability_error",
          style = "color:#dc3545; display:none; font-size:.9em; margin-top:4px;",
          "⚠️ Please answer this question before submitting.")
    )
  })

  # ── Clip UI ────────────────────────────────────────────────────────────────
  output$clips_ui <- renderUI({
    req(rv$clip_order)
    clips <- ALL_CLIPS[rv$clip_order, ]

    lapply(seq_len(nrow(clips)), function(i) {
      div(class = "audio-clip-card",
        div(class = "clip-header",
          div(class = "clip-title", paste("Clip", i)),
          div(class = "clip-rated-badge", style = "display:none;", "Rated")
        ),
        tags$audio(
          controls = NA, preload = "none",
          `data-clip-idx` = as.character(i),
          style    = "width:100%; margin: 0.5rem 0 1rem;",
          tags$source(src = clips$file[i], type = "audio/mpeg"),
          "Your browser does not support audio playback."
        ),
        div(class = "audio-btn-group mt-2",
          lapply(seq_along(AUDIO_CHOICES), function(v) tagList(
            tags$input(type = "radio", class = "btn-check",
                       name  = paste0("audio_rating_", i),
                       id    = paste0("ar_", i, "_", AUDIO_CHOICES[v]),
                       value = AUDIO_CHOICES[v], autocomplete = "off"),
            tags$label(class = "btn btn-audio btn-sm",
                       `for` = paste0("ar_", i, "_", AUDIO_CHOICES[v]),
                       names(AUDIO_CHOICES)[v])
          )),
          # Don't know
          tags$input(type = "radio", class = "btn-check",
                     name  = paste0("audio_rating_", i),
                     id    = paste0("ar_", i, "_5"),
                     value = "5", autocomplete = "off"),
          tags$label(class = "btn btn-noscore btn-sm",
                     `for` = paste0("ar_", i, "_5"), "Don't know")
        )
      )
    })
  })

  # ── Submit area ────────────────────────────────────────────────────────────
  output$submit_area_ui <- renderUI({
    tagList(
      div(id    = "submit_error",
          class = "alert alert-warning mt-3",
          style = "display:none;",
          "⚠️ Please rate all clips (or select 'Don't know') and answer the self-ability question before submitting."),
      div(class = "nav-buttons",
        actionButton("btn_submit", "Submit", class = "btn btn-primary btn-lg")
      )
    )
  })

  # ── Submit handler ─────────────────────────────────────────────────────────
  observeEvent(input$btn_submit, {
    req(rv$clip_order)
    clips <- ALL_CLIPS[rv$clip_order, ]

    if (is.null(input$self_ability)) {
      runjs('document.getElementById("selfability_error").style.display="block";
             document.querySelector(".audio-clip-card").scrollIntoView({behavior:"smooth"});')
      return()
    }

    ratings <- lapply(seq_len(nrow(clips)), function(i) input[[paste0("audio_rating_", i)]])
    if (any(sapply(ratings, is.null))) {
      runjs('document.getElementById("submit_error").style.display="block";')
      return()
    }

    play_counts <- if (!is.null(input$play_counts)) input$play_counts else list()
    ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")

    rows <- lapply(seq_len(nrow(clips)), function(i) {
      rt   <- as.integer(ratings[[i]])
      ctyp <- clips$type[i]
      cid  <- clips$clip_id[i]
      pc   <- as.integer(play_counts[[as.character(i)]] %||% 0L)
      data.frame(
        timestamp    = ts,
        session_id   = rv$session_id,
        utm_source   = rv$utm_source,
        clip_id      = cid,
        clip_type    = ctyp,
        position     = i,
        rating       = rt,
        nonso        = (rt == 5L),
        points       = score_clip(ctyp, rt),
        correct      = correct_clip(ctyp, rt),
        play_count   = pc,
        self_ability = as.integer(input$self_ability),
        stringsAsFactors = FALSE
      )
    })
    df <- do.call(rbind, rows)

    rv$score     <- sum(df$points)
    rv$n_correct <- sum(df$correct)
    rv$submitted <- TRUE

    tryCatch(
      sheet_append(SHEET_ID, df, sheet = "Responses_Short_EN"),
      error = function(e) warning("GSheets write: ", e$message)
    )

    runjs('document.querySelectorAll("audio").forEach(function(a){ a.pause(); a.currentTime=0; });')
    hide("page_audio")
    show("page_results")
    runjs("window.scrollTo(0,0);")
  })

  # ── Results ────────────────────────────────────────────────────────────────
  output$results_ui <- renderUI({
    req(rv$submitted)
    prof <- player_profile(rv$score)
    avg  <- round(rv$score / N_CLIPS, 1)
    tagList(
      p(class = "results-score", paste0(rv$score, " / ", MAX_SCORE)),
      p(class = "lead",       paste0("Correct answers: ", rv$n_correct, " / ", N_CLIPS)),
      p(class = "text-muted", paste0("Average points per clip: ", avg, " / 3")),
      div(class = "mt-3 p-3",
          style = "background:#f0f4ff; border-radius:10px; border-left:4px solid #2563eb;",
        div(style = "font-size:2rem; line-height:1;",    prof$emoji),
        div(style = "font-weight:700; font-size:1.1rem; margin-top:4px;", prof$title),
        div(style = "color:#555; font-size:0.9rem; margin-top:2px;",      prof$desc)
      )
    )
  })

}

# ── NULL-coalescing helper ────────────────────────────────────────────────────
`%||%` <- function(a, b) if (!is.null(a)) a else b

shinyApp(ui, server)
