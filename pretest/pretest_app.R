library(shiny)
library(bslib)
library(shinyjs)
library(googlesheets4)
library(dplyr)

# ── Config ────────────────────────────────────────────────────────────────────
SHEET_ID  <- "1oVruAANYslwX066U3YcqhCYJd5Mxol1fBe0A-J9XlsY"
MAX_SCORE <- 60L
N_CLIPS   <- 20L

gs4_auth(path = "service_account.json")

CLIPS <- data.frame(
  clip_id = c(sprintf("ai_%02d", 1:10), sprintf("hu_%02d", 1:10)),
  type    = c(rep("AI", 10), rep("HUMAN", 10)),
  file    = c(sprintf("audio/ai_%02d.mp3", 1:10), sprintf("audio/hu_%02d.mp3", 1:10)),
  stringsAsFactors = FALSE
)

# ── Sheet init ────────────────────────────────────────────────────────────────
tryCatch({
  if (!"Responses" %in% sheet_names(SHEET_ID)) {
    sheet_add(SHEET_ID, sheet = "Responses")
    sheet_write(
      data.frame(
        timestamp=character(), username=character(), clip_id=character(),
        clip_type=character(), position=integer(), rating=integer(),
        nonso=logical(), familiar=logical(), points=integer(),
        correct=logical(), lang=character(), self_ability=integer()
      ),
      ss = SHEET_ID, sheet = "Responses"
    )
  }
}, error = function(e) warning("Sheet init: ", e$message))

# ── Translations ──────────────────────────────────────────────────────────────
LANG <- list(

  it = list(
    audio_ch = c("Sicuramente AI"="4","Probabilmente AI"="3",
                 "Probabilmente umana"="2","Sicuramente umana"="1","Non so"="5"),
    clip_lbl     = "Clip",
    clip_rated   = "Valutata",
    audio_msg    = "Il tuo browser non supporta la riproduzione audio.",
    familiar_lbl = "Ho già sentito questo brano",
    btn_start    = "Inizia",
    audio_badge  = "Pre-test",
    audio_hint   = "\U0001F3A7 Consigliamo cuffiette o un ambiente silenzioso",
    audio_h3     = "Task di Discriminazione Audio",
    audio_instr  = tagList(
      "Ti presentiamo ", tags$strong("20 brevi clip musicali"),
      ". Per ciascuna traccia, indica in che misura ritieni che sia stata prodotta tramite \
intelligenza artificiale generativa o da un musicista umano, utilizzando la scala a 4 punti da ",
      tags$em("Sicuramente umana"), " a ", tags$em("Sicuramente AI"),
      ". Se non riesci a esprimere un giudizio, seleziona l'opzione ", tags$em("'Non so'"), "."
    ),
    audio_ctx_q  = "Cos'è la musica generata dall'AI?",
    audio_ctx    = "Ai fini di questo studio, per 'musica generata dall'AI' si intende musica \
composta e prodotta interamente da sistemi di intelligenza artificiale generativa, senza alcun \
contributo umano nella composizione, nella scrittura o nella registrazione. Questi sistemi \
analizzano grandi quantità di musica esistente per apprenderne i pattern (ritmo, armonia, timbro, \
stile) e generano nuove composizioni originali a partire da prompt testuali o indicazioni dell'utente.",
    submit_btn   = "Invia le risposte",
    submit_err   = "⚠️ Valuta tutte le clip (o seleziona 'Non so') prima di inviare.",
    results_h2   = "Risultati",
    correct_fmt  = function(n) paste0("Risposte corrette: ", n, " / ", N_CLIPS),
    avg_fmt      = function(a) paste0("Punteggio medio per risposta: ", a, " / 3"),
    selfability_q   = "Quanto ritieni di essere capace di distinguere la musica generata dall'AI da quella umana?",
    selfability_lo  = "Per nulla capace",
    selfability_hi  = "Perfettamente capace",
    selfability_err = "⚠️ Rispondi alla domanda prima di continuare.",
    restore_banner  = "⚡ Progresso ripristinato. Puoi continuare da dove eri rimasto.",
    profiles = list(
      list(thr=60, emoji="🏆", title="Orecchio Assoluto",
           desc="Perfetto! Candidati da Deezer come responsabile anti-AI."),
      list(thr=50, emoji="🎼", title="Sommelier Musicale",
           desc="Distingueresti un Brunello da una bottiglia di tetrapak."),
      list(thr=40, emoji="🎧", title="Critico in Formazione",
           desc="Riesci a sentire qualcosa che non torna. Continua così."),
      list(thr=30, emoji="🕵️", title="Segugio Sospettoso",
           desc="Il tuo istinto musicale comincia a svegliarsi."),
      list(thr=20, emoji="😐", title="Homo Streamingensis",
           desc="Nella media, come la maggior parte degli ascoltatori."),
      list(thr=10, emoji="🎲", title="Lanciatore di Monete",
           desc="Risultato simile a lanciare una moneta. Forse era la connessione."),
      list(thr=0,  emoji="🪵", title="Orecchio di Compensato",
           desc="L'AI ti ha ingannato completamente. Rispetti.")
    )
  ),

  fr = list(
    audio_ch = c("Sûrement IA"="4","Probablement IA"="3",
                 "Probablement humaine"="2","Sûrement humaine"="1","Je ne sais pas"="5"),
    clip_lbl     = "Clip",
    clip_rated   = "Évaluée",
    audio_msg    = "Votre navigateur ne prend pas en charge la lecture audio.",
    familiar_lbl = "J'ai déjà entendu ce morceau",
    btn_start    = "Commencer",
    audio_badge  = "Pré-test",
    audio_hint   = "\U0001F3A7 Casque ou environnement calme recommandé",
    audio_h3     = "Tâche de discrimination audio",
    audio_instr  = tagList(
      "Nous vous présentons ", tags$strong("20 courts extraits musicaux"),
      ". Pour chaque piste, indiquez dans quelle mesure vous pensez qu'elle a été produite par \
l'intelligence artificielle générative ou par un musicien humain, en utilisant l'échelle à 4 points de ",
      tags$em("Sûrement humaine"), " à ", tags$em("Sûrement IA"),
      ". Si vous n'êtes pas en mesure de formuler un jugement, sélectionnez l'option ",
      tags$em("'Je ne sais pas'"), "."
    ),
    audio_ctx_q  = "Qu'est-ce que la musique générée par l'IA ?",
    audio_ctx    = "Dans le cadre de cette étude, la « musique générée par l'IA » désigne la \
musique composée et produite entièrement par des systèmes d'IA générative, sans aucune contribution \
humaine dans la composition, l'écriture ou l'enregistrement. Ces systèmes analysent de vastes \
ensembles de musique existante pour en apprendre les patterns (rythme, harmonie, timbre, style) et \
génèrent de nouvelles compositions originales à partir d'invites textuelles ou d'indications de \
l'utilisateur.",
    submit_btn   = "Soumettre les réponses",
    submit_err   = "⚠️ Évaluez tous les extraits (ou sélectionnez 'Je ne sais pas') avant d'envoyer.",
    results_h2   = "Résultats",
    correct_fmt  = function(n) paste0("Réponses correctes : ", n, " / ", N_CLIPS),
    avg_fmt      = function(a) paste0("Score moyen par réponse : ", a, " / 3"),
    selfability_q   = "Dans quelle mesure pensez-vous être capable de distinguer la musique générée par l'IA de la musique humaine ?",
    selfability_lo  = "Pas du tout capable",
    selfability_hi  = "Parfaitement capable",
    selfability_err = "⚠️ Répondez à la question avant de continuer.",
    restore_banner  = "⚡ Progression restaurée. Vous pouvez reprendre là où vous en étiez.",
    profiles = list(
      list(thr=60, emoji="🏆", title="Oreille Absolue",
           desc="Parfait ! Candidatez chez Deezer comme responsable anti-IA."),
      list(thr=50, emoji="🎼", title="Sommelier Musical",
           desc="Vous distingueriez un grand cru d'une piquette."),
      list(thr=40, emoji="🎧", title="Critique en Formation",
           desc="Vous sentez que quelque chose cloche. Continuez ainsi."),
      list(thr=30, emoji="🕵️", title="Limier Suspicieux",
           desc="Votre instinct musical commence à s'éveiller."),
      list(thr=20, emoji="😐", title="Homo Streamingensis",
           desc="Dans la moyenne, comme la plupart des auditeurs."),
      list(thr=10, emoji="🎲", title="Lanceur de Pièce",
           desc="Résultat similaire à lancer une pièce. C'était peut-être la connexion."),
      list(thr=0,  emoji="🪵", title="Oreille de Contreplaqué",
           desc="L'IA vous a complètement trompé. Respect.")
    )
  )
)

# ── Helpers ───────────────────────────────────────────────────────────────────
score_clip <- function(type, rating_val) {
  r <- as.integer(rating_val)
  if (r == 5L) return(0L)
  if (type == "AI") r - 1L else 4L - r
}

player_profile <- function(score, lang = "it") {
  for (p in LANG[[lang]]$profiles) {
    if (score >= p$thr) return(p)
  }
  LANG[[lang]]$profiles[[length(LANG[[lang]]$profiles)]]
}

correct_clip <- function(type, rating_val) {
  r <- as.integer(rating_val)
  if (r == 5L) return(FALSE)
  if (type == "AI") r >= 3L else r <= 2L
}

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
      .familiar-check { margin-top: 0.75rem; font-size: 0.88rem; color: #6c757d; }
      .familiar-check input[type=checkbox] { margin-right: 0.4rem; accent-color: #2563eb; }
      .pretest-welcome { max-width: 520px; margin: 60px auto; }
      .results-score   { font-size: 3rem; font-weight: 800; color: #2563eb; }
      .lang-selector   { text-align: center; margin: 1.5rem 0; }
      .btn-lang        { min-width: 140px; font-size: 1.05rem; }
      .likert-row      { display:flex; align-items:center; gap:6px; flex-wrap:wrap; margin-top:6px; }
      .likert-anchor   { font-size:0.78rem; color:#6c757d; flex-shrink:0; max-width:90px; line-height:1.2; }
      .likert-anchor.lo { text-align:right; }
      .likert-anchor.hi { text-align:left; }
      @media (max-width: 576px) {
        .audio-btn-group { flex-direction: column !important; }
        .btn-audio, .btn-noscore { width: 100% !important; text-align: center !important; }
      }
    ")),
    tags$script(HTML("
      // ── localStorage helpers ───────────────────────────────────────────────
      function getLS() {
        try { return JSON.parse(localStorage.getItem('audioPretest') || '{}'); }
        catch(e) { return {}; }
      }
      function setLS(updates) {
        var s = getLS();
        Object.assign(s, updates);
        localStorage.setItem('audioPretest', JSON.stringify(s));
      }

      $(document).ready(function() {

        // Registra message handlers dopo che Shiny è pronto
        Shiny.addCustomMessageHandler('saveLS', function(data) {
          setLS(data);
        });
        Shiny.addCustomMessageHandler('clearLS', function(data) {
          localStorage.removeItem('audioPretest');
        });

        // Invia stato salvato a R non appena la sessione è connessa
        $(document).on('shiny:connected', function() {
          var state = localStorage.getItem('audioPretest');
          if (state) {
            try {
              Shiny.setInputValue('ls_restore', JSON.parse(state), {priority: 'event'});
            } catch(e) {}
          }
        });

        // Dopo il render di clips_ui: ripristina badge sulle clip già valutate
        $(document).on('shiny:value', function(e) {
          if (e.name === 'clips_ui') {
            setTimeout(function() {
              // cards[0] = self_ability, cards[1..N] = clips
              var cards = document.querySelectorAll('.audio-clip-card');
              for (var i = 1; i <= 20; i++) {
                var checked = document.querySelector('input[name=\"audio_rating_' + i + '\"]:checked');
                if (checked && cards[i]) {
                  cards[i].classList.add('clip-rated');
                  var badge = cards[i].querySelector('.clip-rated-badge');
                  if (badge) badge.style.display = '';
                }
              }
            }, 150);
          }
        });

      }); // end document.ready

      // ── Un solo audio alla volta ───────────────────────────────────────────
      document.addEventListener('play', function(e) {
        document.querySelectorAll('audio').forEach(function(a) {
          if (a !== e.target) { a.pause(); a.currentTime = 0; }
        });
      }, true);

      // ── Clip-rated badge + salva rating in localStorage ───────────────────
      $(document).on('change', 'input.btn-check', function() {
        var name = $(this).attr('name');
        var val  = $(this).val();
        Shiny.setInputValue(name, val);
        var updates = {};
        updates[name] = val;
        setLS(updates);
        var card = $(this).closest('.audio-clip-card');
        if (card.length) {
          card.addClass('clip-rated');
          card.find('.clip-rated-badge').show();
        }
      });

      // ── Salva familiar in localStorage ────────────────────────────────────
      $(document).on('change', 'input[type=checkbox]', function() {
        var id = $(this).attr('id');
        if (id && id.startsWith('familiar_')) {
          var updates = {};
          updates[id] = $(this).prop('checked');
          setLS(updates);
        }
      });

      // ── Flash bordo rosso su card non valutata ────────────────────────────
      function flashInvalid(el) {
        if (!el) return;
        el.style.outline      = '2px solid #dc3545';
        el.style.borderRadius = '4px';
        setTimeout(function() {
          el.style.outline = ''; el.style.borderRadius = '';
        }, 1500);
      }

      // ── Validazione submit ────────────────────────────────────────────────
      $(document).on('click', '#btn_submit', function() {
        var ok = true;
        var n  = parseInt($('#n_clips').val() || 20);
        for (var i = 1; i <= n; i++) {
          if (!document.querySelector('input[name=\"audio_rating_' + i + '\"]:checked')) {
            flashInvalid(document.querySelectorAll('.audio-clip-card')[i-1]);
            ok = false;
          }
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

  # ── Pagina benvenuto ───────────────────────────────────────────────────────
  div(id = "page_welcome",
    div(class = "pretest-welcome",
      div(class = "survey-header text-center",
        h2(class = "intro-h2",
           "Audio Discrimination Task",
           tags$br(),
           tags$small(class = "text-muted fs-5 fw-normal",
                      "Pre-test · Musica AI vs Umana / Musique IA vs Humaine")
        )
      ),
      hr(),
      # ── Selettore lingua ──────────────────────────────────────────────────
      div(class = "lang-selector",
        p(class = "text-muted mb-3",
          "Seleziona la lingua / Choisissez la langue :"),
        actionButton("btn_lang_it", "🇮🇹  Italiano",
                     class = "btn btn-primary btn-lg btn-lang me-2"),
        actionButton("btn_lang_fr", "🇫🇷  Français",
                     class = "btn btn-outline-secondary btn-lg btn-lang")
      ),
      hr(),
      div(class = "alert alert-warning py-2 px-3",
          style = "font-size:0.85rem;",
          "📱 Tieni lo schermo attivo durante il test per evitare disconnessioni."),
      uiOutput("welcome_start_ui")
    )
  ),

  # ── Pagina audio ───────────────────────────────────────────────────────────
  hidden(div(id = "page_audio", class = "survey-page",
    div(class = "survey-container",
      uiOutput("audio_header_ui"),
      uiOutput("restore_banner_ui"),
      uiOutput("selfability_ui"),
      tags$input(type = "hidden", id = "n_clips", value = as.character(N_CLIPS)),
      uiOutput("clips_ui"),
      uiOutput("submit_area_ui")
    )
  )),

  # ── Pagina risultati ───────────────────────────────────────────────────────
  hidden(div(id = "page_results", class = "survey-page",
    div(class = "survey-container thankyou-container text-center",
      div(class = "thankyou-icon", icon("circle-check")),
      uiOutput("results_title_ui"),
      uiOutput("results_ui"),
      hr(),
      div(class = "alert alert-success py-2 px-3",
          style = "font-size:0.9rem;",
          "🙏 Grazie per la partecipazione! I tuoi dati sono stati registrati.")
    )
  ))
)

# ── Server ────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {

  session$allowReconnect("force")

  rv <- reactiveValues(
    lang         = "it",
    session_id   = paste0("anon_", format(Sys.time(), "%Y%m%d%H%M%S"), "_", sample(1000:9999, 1)),
    self_ability = NULL,
    clip_order   = NULL,
    submitted    = FALSE,
    score        = NULL,
    n_correct    = NULL,
    saved_state  = NULL,   # stato ripristinato da localStorage
    restored     = FALSE   # TRUE dopo ripristino riuscito
  )

  # ── Ripristino da localStorage ─────────────────────────────────────────────
  observeEvent(input$ls_restore, {
    state <- input$ls_restore
    if (is.null(state)) return()

    # Ripristina lingua
    if (!is.null(state$lang) && state$lang %in% c("it", "fr")) {
      rv$lang <- state$lang
      if (state$lang == "fr") {
        runjs('
          $("#btn_lang_fr").removeClass("btn-outline-secondary").addClass("btn-primary");
          $("#btn_lang_it").removeClass("btn-primary").addClass("btn-outline-primary");
        ')
      }
    }

    # Ripristina progresso (solo se session_id presente)
    sid <- trimws(as.character(if (!is.null(state$session_id)) state$session_id else ""))
    if (nchar(sid) > 0) {
      rv$session_id  <- sid
      rv$saved_state <- state
      rv$clip_order  <- c(1,20,16,11,7,5,8,3,13,12,6,18,4,9,19,14,17,2,15,10)
      rv$restored    <- TRUE
      hide("page_welcome")
      show("page_audio")
      runjs("window.scrollTo(0,0);")
    }
  }, ignoreNULL = TRUE)

  # ── Selezione lingua ───────────────────────────────────────────────────────
  observeEvent(input$btn_lang_it, {
    rv$lang <- "it"
    runjs('
      $("#btn_lang_it").removeClass("btn-outline-primary").addClass("btn-primary");
      $("#btn_lang_fr").removeClass("btn-primary").addClass("btn-outline-secondary");
    ')
  })
  observeEvent(input$btn_lang_fr, {
    rv$lang <- "fr"
    runjs('
      $("#btn_lang_fr").removeClass("btn-outline-secondary").addClass("btn-primary");
      $("#btn_lang_it").removeClass("btn-primary").addClass("btn-outline-primary");
    ')
  })

  # ── Pulsante start (lingua-reattivo) ──────────────────────────────────────
  output$welcome_start_ui <- renderUI({
    tx <- LANG[[rv$lang]]
    div(class = "nav-buttons mt-3",
      actionButton("btn_start", tx$btn_start, class = "btn btn-primary btn-lg")
    )
  })

  # ── Start ──────────────────────────────────────────────────────────────────
  observeEvent(input$btn_start, {
    rv$clip_order <- c(1,20,16,11,7,5,8,3,13,12,6,18,4,9,19,14,17,2,15,10)
    # Salva session_id e lingua in localStorage
    session$sendCustomMessage("saveLS", list(session_id = rv$session_id, lang = rv$lang))
    hide("page_welcome")
    show("page_audio")
    runjs("window.scrollTo(0,0);")
  })

  # ── Banner ripristino ──────────────────────────────────────────────────────
  output$restore_banner_ui <- renderUI({
    req(rv$restored)
    tx <- LANG[[rv$lang]]
    div(class = "alert alert-info alert-dismissible fade show py-2 px-3 mb-3",
        style = "font-size:0.88rem;",
        tx$restore_banner,
        tags$button(type = "button", class = "btn-close",
                    `data-bs-dismiss` = "alert", `aria-label` = "Close")
    )
  })

  # ── Header pagina audio (lingua-reattivo) ──────────────────────────────────
  output$audio_header_ui <- renderUI({
    tx <- LANG[[rv$lang]]
    div(class = "survey-header",
      div(class = "audio-header-row",
        div(class = "page-badge", tx$audio_badge),
        div(class = "audio-hint-chip", tx$audio_hint)
      ),
      h3(tx$audio_h3),
      p(tx$audio_instr),
      div(class = "audio-context-box",
        div(class = "context-q", tags$strong(tx$audio_ctx_q)),
        div(class = "context-a", tx$audio_ctx)
      )
    )
  })

  # ── Self-ability card ──────────────────────────────────────────────────────
  output$selfability_ui <- renderUI({
    req(rv$clip_order)
    tx       <- LANG[[rv$lang]]
    saved    <- rv$saved_state
    raw_sa   <- if (!is.null(saved)) saved$self_ability else NULL
    saved_sa <- if (!is.null(raw_sa)) as.character(raw_sa) else NULL

    div(class = "audio-clip-card",
      div(class = "clip-header",
        div(class = "clip-title", tx$selfability_q)
      ),
      div(class = "d-flex justify-content-between mt-2",
          style = "font-size:0.78rem; color:#6c757d;",
        span(tx$selfability_lo),
        span(tx$selfability_hi)
      ),
      div(style = "display:flex; justify-content:center; gap:8px; margin-top:6px;",
        lapply(1:5, function(v) tagList(
          tags$input(type = "radio", class = "btn-check",
                     name  = "self_ability",
                     id    = paste0("sa_", v),
                     value = v, autocomplete = "off",
                     checked = if (!is.null(saved_sa) && as.character(v) == saved_sa) NA else NULL),
          tags$label(class = "btn btn-audio btn-sm",
                     `for` = paste0("sa_", v), as.character(v))
        ))
      ),
      div(id    = "selfability_error",
          style = "color:#dc3545; display:none; font-size:.9em; margin-top:4px;",
          tx$selfability_err)
    )
  })

  # ── Clip UI (lingua-reattivo) ──────────────────────────────────────────────
  output$clips_ui <- renderUI({
    req(rv$clip_order)
    tx          <- LANG[[rv$lang]]
    ordered     <- CLIPS[rv$clip_order, ]
    scored_lbl  <- names(tx$audio_ch)[1:4]
    scored_val  <- tx$audio_ch[1:4]
    noscore_lbl <- names(tx$audio_ch)[5]
    saved       <- rv$saved_state   # NULL se nessun ripristino

    lapply(seq_len(nrow(ordered)), function(i) {
      rating_key     <- paste0("audio_rating_", i)
      familiar_key   <- paste0("familiar_", i)
      raw_rating     <- if (!is.null(saved)) saved[[rating_key]] else NULL
      saved_rating   <- if (!is.null(raw_rating)) as.character(raw_rating) else NULL
      raw_familiar   <- if (!is.null(saved)) saved[[familiar_key]] else NULL
      saved_familiar <- if (!is.null(raw_familiar)) isTRUE(raw_familiar) else FALSE
      is_rated       <- !is.null(saved_rating)

      div(class = paste0("audio-clip-card", if (is_rated) " clip-rated" else ""),
        div(class = "clip-header",
          div(class = "clip-title", paste(tx$clip_lbl, i)),
          div(class = "clip-rated-badge",
              style = if (is_rated) "display:block;" else "display:none;",
              tx$clip_rated)
        ),
        tags$audio(
          controls = NA, preload = "none",
          style    = "width:100%; margin: 0.5rem 0 1rem;",
          tags$source(src = ordered$file[i], type = "audio/mpeg"),
          tx$audio_msg
        ),
        div(class = "audio-btn-group mt-2",
          lapply(seq_along(scored_lbl), function(v) tagList(
            tags$input(type = "radio", class = "btn-check",
                       name  = paste0("audio_rating_", i),
                       id    = paste0("ar_", i, "_", scored_val[v]),
                       value = scored_val[v], autocomplete = "off",
                       checked = if (is_rated && scored_val[v] == saved_rating) NA else NULL),
            tags$label(class = "btn btn-audio btn-sm",
                       `for` = paste0("ar_", i, "_", scored_val[v]),
                       scored_lbl[v])
          )),
          tags$input(type = "radio", class = "btn-check",
                     name  = paste0("audio_rating_", i),
                     id    = paste0("ar_", i, "_5"),
                     value = "5", autocomplete = "off",
                     checked = if (is_rated && saved_rating == "5") NA else NULL),
          tags$label(class = "btn btn-noscore btn-sm",
                     `for` = paste0("ar_", i, "_5"),
                     noscore_lbl)
        ),
        div(class = "familiar-check",
          tags$input(type  = "checkbox",
                     id    = paste0("familiar_", i),
                     name  = paste0("familiar_", i),
                     value = "yes",
                     checked = if (saved_familiar) NA else NULL),
          tags$label(`for` = paste0("familiar_", i), tx$familiar_lbl)
        )
      )
    })
  })

  # ── Area submit (lingua-reattiva) ──────────────────────────────────────────
  output$submit_area_ui <- renderUI({
    tx <- LANG[[rv$lang]]
    tagList(
      div(id    = "submit_error",
          class = "alert alert-warning mt-3",
          style = "display:none;",
          tx$submit_err),
      div(class = "nav-buttons",
        actionButton("btn_submit", tx$submit_btn, class = "btn btn-primary btn-lg")
      )
    )
  })

  # ── Submit ─────────────────────────────────────────────────────────────────
  observeEvent(input$btn_submit, {
    req(rv$clip_order)
    ordered <- CLIPS[rv$clip_order, ]

    ratings <- sapply(seq_len(nrow(ordered)), function(i) {
      input[[paste0("audio_rating_", i)]]
    })

    if (is.null(input$self_ability)) {
      runjs('document.getElementById("selfability_error").style.display="block";
             document.querySelector(".audio-clip-card").scrollIntoView({behavior:"smooth"});')
      return()
    }
    if (any(sapply(ratings, is.null))) {
      runjs('document.getElementById("submit_error").style.display="block";')
      return()
    }

    ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    rows <- lapply(seq_len(nrow(ordered)), function(i) {
      rt      <- as.integer(ratings[[i]])
      ctyp    <- ordered$type[i]
      cid     <- ordered$clip_id[i]
      fam     <- isTRUE(input[[paste0("familiar_", i)]])
      pts     <- score_clip(ctyp, rt)
      corr    <- correct_clip(ctyp, rt)
      data.frame(
        timestamp = ts,       username  = rv$session_id,
        clip_id   = cid,      clip_type = ctyp,
        position  = i,        rating    = rt,
        nonso     = (rt==5L), familiar  = fam,
        points    = pts,      correct   = corr,
        lang      = rv$lang,  self_ability = as.integer(input$self_ability),
        stringsAsFactors = FALSE
      )
    })
    df <- do.call(rbind, rows)

    rv$score     <- sum(df$points)
    rv$n_correct <- sum(df$correct)
    rv$submitted <- TRUE

    tryCatch(
      sheet_append(SHEET_ID, df, sheet = "Responses"),
      error = function(e) warning("GSheets write: ", e$message)
    )

    # Pulisci localStorage — dati inviati con successo
    session$sendCustomMessage("clearLS", list())

    runjs('document.querySelectorAll("audio").forEach(function(a){ a.pause(); a.currentTime=0; });')
    hide("page_audio")
    show("page_results")
    runjs("window.scrollTo(0,0);")
  })

  # ── Titolo risultati ───────────────────────────────────────────────────────
  output$results_title_ui <- renderUI({
    req(rv$submitted)
    h2(LANG[[rv$lang]]$results_h2)
  })

  # ── Risultati ──────────────────────────────────────────────────────────────
  output$results_ui <- renderUI({
    req(rv$submitted)
    tx   <- LANG[[rv$lang]]
    prof <- player_profile(rv$score, rv$lang)
    avg  <- round(rv$score / N_CLIPS, 1)
    tagList(
      p(class = "results-score", paste0(rv$score, " / ", MAX_SCORE)),
      p(class = "lead",       tx$correct_fmt(rv$n_correct)),
      p(class = "text-muted", tx$avg_fmt(avg)),
      div(class = "mt-3 p-3",
          style = "background:#f0f4ff; border-radius:10px; border-left:4px solid #2563eb;",
        div(style = "font-size:2rem; line-height:1;", prof$emoji),
        div(style = "font-weight:700; font-size:1.1rem; margin-top:4px;", prof$title),
        div(style = "color:#555; font-size:0.9rem; margin-top:2px;",      prof$desc)
      )
    )
  })

}

shinyApp(ui, server)
