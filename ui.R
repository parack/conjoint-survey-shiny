ui <- page_fluid(
  theme = bs_theme(
    version   = 5,
    bootswatch = "flatly",
    primary   = "#1DB954",
    font_scale = 1.05
  ),
  useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css"),
    tags$script(HTML("
      // Disable browser back button between survey pages
      history.pushState(null, null, location.href);
      window.addEventListener('popstate', function() {
        history.pushState(null, null, location.href);
      });

      // Auto-stop all other audio players when one starts playing
      document.addEventListener('play', function(e) {
        document.querySelectorAll('audio').forEach(function(a) {
          if (a !== e.target) { a.pause(); a.currentTime = 0; }
        });
      }, true);

      // Highlight selected CBC card when a choice radio is clicked
      $(document).on('change', '.cbc-choice-section input[type=radio]', function() {
        var val = parseInt($(this).val()) - 1;
        var cards = $(this).closest('.survey-container').find('.cbc-card');
        cards.removeClass('cbc-card-selected');
        if (val >= 0 && val < cards.length) cards.eq(val).addClass('cbc-card-selected');
      });

      // Mark audio clip card as rated when a rating is selected
      $(document).on('change', '.audio-clip-card input[type=radio]', function() {
        var card = $(this).closest('.audio-clip-card');
        card.addClass('clip-rated');
        card.find('.clip-rated-badge').show();
      });
    "))
  ),

  # ── Global progress bar ───────────────────────────────────────────────────
  div(class = "progress-wrapper",
    div(id = "progress-bar-inner", class = "progress-bar-fill", style = "width:0%")
  ),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 1 — Intro + Consenso informato
  # ═══════════════════════════════════════════════════════════════════════════
  div(id = "page_intro", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header text-center",
        h2("Preferenze dei consumatori per la governance dell'AI",
           br(), "nei servizi musicali in streaming"),
        p(class = "lead text-muted",
          "Sondaggio per tesi magistrale | Università degli Studi di Trento")
      ),
      hr(),
      h5("Informativa sulla privacy e consenso informato"),
      div(class = "consent-box",
        p(strong("Oggetto della ricerca:"),
          " Preferenze dei consumatori rispetto a diverse configurazioni di governance del contenuto musicale generato dall'intelligenza artificiale nei servizi di streaming digitale."),
        p(strong("Chi conduce la ricerca:"),
          " Lorenzo Paravano, tesi magistrale, Università degli Studi di Trento."),
        p(strong("Partecipazione:"),
          " Volontaria e anonima. Nessun dato identificativo personale è raccolto."),
        p(strong("Dati raccolti:"),
          " Risposte alle domande del sondaggio (preferenze, atteggiamenti, dati demografici aggregati). I dati saranno presentati esclusivamente in forma aggregata."),
        p(strong("Durata stimata:"), " 10–15 minuti."),
        p(strong("Trattamento dei dati:"),
          " I dati sono trattati in conformità al GDPR (Reg. UE 2016/679) esclusivamente per finalità di ricerca accademica.")
      ),
      div(class = "mt-3",
        checkboxInput("consent_check",
          label = tags$span(
            "Ho letto l'informativa e acconsento volontariamente a partecipare al sondaggio."
          ),
          value = FALSE
        )
      ),
      div(class = "nav-buttons",
        actionButton("btn_intro_next", "Inizia →",
                     class = "btn btn-primary btn-lg")
      )
    )
  ),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 2 — Discriminazione audio
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_audio", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "page-badge", "Sezione 1 di 5"),
        h3("Task di Discriminazione Audio"),
        p("Ascolta ciascuna delle ", strong("4 clip musicali"), " qui sotto e indica, per ognuna, ",
          "quanto pensi che sia stata prodotta dall'intelligenza artificiale o da un musicista umano. ",
          "Usa la scala a 4 punti, da ", em("Sicuramente umana"), " a ", em("Sicuramente AI"), ". ",
          "Se non sei sicuro/a, seleziona ", em('"Non so"'), ".")
      ),
      uiOutput("audio_clips_ui"),
      div(class = "nav-buttons",
        actionButton("btn_audio_next", "Avanti →", class = "btn btn-primary")
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 3 — GAAIS-10
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_gaais", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "page-badge", "Sezione 2 di 5"),
        h3("Atteggiamenti verso l'Intelligenza Artificiale"),
        p("Per ciascuna affermazione, indica il tuo grado di accordo su una scala da ",
          strong("1 (Fortemente in disaccordo)"), " a ", strong("5 (Fortemente d'accordo)"), ".")
      ),
      div(class = "scale-anchor-header",
        span("1"), span("2"), span("3"), span("4"), span("5")
      ),
      div(class = "gaais-list",
        lapply(seq_len(nrow(GAAIS_ITEMS)), function(i) {
          div(class = "gaais-item",
            p(class = "item-text", paste0(i, ". ", GAAIS_ITEMS$text[i])),
            div(class = "likert-radios",
              radioButtons(
                inputId  = paste0("gaais_", GAAIS_ITEMS$code[i]),
                label    = NULL,
                choices  = LIKERT5_CHOICES,
                selected = character(0),
                inline   = TRUE
              )
            )
          )
        })
      ),
      div(class = "nav-buttons",
        actionButton("btn_gaais_next", "Avanti →", class = "btn btn-primary")
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 4 — Framing pre-CBC
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_framing", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "page-badge", "Sezione 3 di 5"),
        h3("Politiche AI nei servizi di streaming musicale")
      ),
      div(class = "framing-box",
        h5("Contesto attuale"),
        p("I servizi di streaming musicale (Spotify, Apple Music, Amazon Music, ecc.) ospitano ",
          "una quantità crescente di tracce generate interamente o parzialmente dall'intelligenza ",
          "artificiale. Nella maggior parte delle piattaforme oggi:"),
        tags$ul(
          tags$li(strong("Non esiste alcuna label"), " consumer-facing che identifichi le tracce AI."),
          tags$li("Le tracce AI vengono ", strong("incluse nelle playlist raccomandate"),
                  " accanto alla musica umana."),
          tags$li(strong("Non è disponibile alcun filtro"), " per escludere le tracce AI.")
        ),
        div(class = "status-quo-card",
          h6("Configurazione attuale (status quo — punto di riferimento)"),
          tags$ul(
            tags$li("Policy labeling AI: ", em("Nessuna label consumer-facing")),
            tags$li("Struttura promozionale: ", em("Musica AI nelle playlist raccomandate")),
            tags$li("Controllo utente: ", em("Nessun filtro disponibile")),
            tags$li("Prezzo abbonamento: ", em("€11,99/mese"))
          )
        )
      ),
      hr(),
      div(class = "framing-task",
        h5("Come leggere le scelte"),
        p("Nelle pagine successive vedrai ", strong("12 situazioni ipotetiche"), ". ",
          "In ciascuna sono presentate ", strong("3 alternative di abbonamento"), " che differiscono per:"),
        div(class = "attr-list",
          div(class = "attr-row-framing",
            tags$span(class = "attr-icon", tags$b("[A]")),
            div(strong("Policy di labeling AI:"), " come la piattaforma comunica quale musica è generata dall'AI.")
          ),
          div(class = "attr-row-framing",
            tags$span(class = "attr-icon", tags$b("[B]")),
            div(strong("Struttura promozionale:"), " se e come la musica AI è inclusa nelle playlist raccomandate.")
          ),
          div(class = "attr-row-framing",
            tags$span(class = "attr-icon", tags$b("[C]")),
            div(strong("Controllo utente:"), " quali strumenti hai per filtrare o bloccare la musica AI.")
          ),
          div(class = "attr-row-framing",
            tags$span(class = "attr-icon", tags$b("[D]")),
            div(strong("Prezzo mensile:"), " il costo dell'abbonamento.")
          )
        ),
        p(class = "mt-3",
          "Per ciascuna situazione, ", strong("scegli l'alternativa che preferiresti"),
          " come tuo piano di abbonamento. ",
          "Non esistono risposte giuste o sbagliate: conta esclusivamente la tua preferenza personale.")
      ),
      div(class = "nav-buttons",
        actionButton("btn_framing_next", "Inizia le scelte →", class = "btn btn-primary btn-lg")
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 5 — CBC tasks (dynamic, 1 task at a time)
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_cbc", class = "survey-page",
    div(class = "survey-container",
      uiOutput("cbc_task_ui"),
      div(class = "nav-buttons",
        actionButton("btn_cbc_next", "Avanti →", class = "btn btn-primary")
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 6 — Proxy items + churn_intent
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_proxy", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "page-badge", "Sezione 4 di 5"),
        h3("Esperienze musicali e percezione dell'AI"),
        p("Indica il tuo grado di accordo su una scala da ", strong("1 (Per nulla d'accordo)"),
          " a ", strong("7 (Completamente d'accordo)"), ".")
      ),
      div(class = "proxy-list",
        lapply(seq_len(nrow(PROXY_ITEMS)), function(i) {
          div(class = "proxy-item",
            p(class = "item-text", paste0(i, ". ", PROXY_ITEMS$text[i])),
            div(class = "likert7-row",
              radioButtons(
                inputId  = PROXY_ITEMS$code[i],
                label    = NULL,
                choices  = LIKERT7_CHOICES,
                selected = character(0),
                inline   = TRUE
              ),
              div(class = "scale-anchors-7",
                span("Per nulla d'accordo"),
                span("Completamente d'accordo")
              )
            )
          )
        })
      ),
      hr(),
      div(class = "churn-section",
        h5("Intenzione di abbandono"),
        p("Ipotizzando che il tuo servizio di streaming attuale ", strong("non apportasse alcuna modifica"),
          " alle politiche sulla musica AI nei prossimi 12 mesi, quanto saresti propenso/a a ",
          "cancellare o cambiare abbonamento?"),
        div(class = "likert7-row",
          radioButtons(
            inputId  = "churn_intent",
            label    = NULL,
            choices  = LIKERT7_CHOICES,
            selected = character(0),
            inline   = TRUE
          ),
          div(class = "scale-anchors-7",
            span("1 – Per nulla probabile"),
            span("7 – Molto probabile")
          )
        )
      ),
      div(class = "nav-buttons",
        actionButton("btn_proxy_next", "Avanti →", class = "btn btn-primary")
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 7 — Demografiche
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_demo", class = "survey-page",
    div(class = "survey-container",
      div(class = "survey-header",
        div(class = "page-badge", "Sezione 5 di 5"),
        h3("Dati demografici e utilizzo dei servizi"),
        p("Ultima sezione. Tutte le informazioni sono anonime e usate esclusivamente a fini statistici.")
      ),
      fluidRow(
        column(6,
          selectInput("demo_age", "Fascia d'eta *",
            choices  = c("-- Seleziona --" = "", "18-24", "25-34", "35-44", "45-54", "55-64", "65+"),
            selected = "")
        ),
        column(6,
          selectInput("demo_gender", "Genere *",
            choices  = c("-- Seleziona --" = "", "Uomo", "Donna",
                         "Non binario / Terzo genere", "Preferisco non specificare"),
            selected = "")
        )
      ),
      fluidRow(
        column(12,
          selectInput("demo_education", "Titolo di studio piu elevato conseguito *",
            choices = c("-- Seleziona --" = "",
                        "Licenza media", "Diploma di scuola superiore",
                        "Laurea triennale (L)", "Laurea magistrale / Ciclo unico (LM / LMU)",
                        "Dottorato di ricerca / Post-laurea"),
            selected = "")
        )
      ),
      hr(),
      h5("Utilizzo dei servizi di streaming musicale"),
      radioButtons("dsp_user",
        label    = "Sei attualmente abbonato/a o utilizzi regolarmente un servizio di streaming musicale? *",
        choices  = c("Si" = "yes", "No" = "no"),
        selected = character(0),
        inline   = TRUE
      ),
      conditionalPanel(
        condition = "input.dsp_user === 'yes'",
        selectInput("dsp_current", "Quale servizio utilizzi principalmente? *",
          choices = c("-- Seleziona --" = "", "Spotify", "Apple Music", "Amazon Music Unlimited",
                      "YouTube Music", "Tidal", "Deezer", "Altro"),
          selected = ""),
        selectInput("dsp_tier", "Tipo di abbonamento *",
          choices = c("-- Seleziona --" = "", "Gratuito (con pubblicita)", "Premium individuale",
                      "Premium famiglia / Duo", "Studente", "Altro"),
          selected = "")
      ),
      hr(),
      div(class = "submit-section",
        p(class = "text-muted small",
          "(!) Controlla le tue risposte: dopo l'invio non sarà possibile modificarle."),
        actionButton("btn_demo_submit", "Invia le risposte",
                     class = "btn btn-success btn-lg",
                     icon  = icon("paper-plane"))
      )
    )
  )),

  # ═══════════════════════════════════════════════════════════════════════════
  # PAGE 8 — Thank you
  # ═══════════════════════════════════════════════════════════════════════════
  hidden(div(id = "page_thankyou", class = "survey-page",
    div(class = "survey-container thankyou-container text-center",
      div(class = "thankyou-icon", icon("circle-check")),
      h2("Grazie per la tua partecipazione!"),
      p(class = "lead", "Le tue risposte sono state registrate con successo."),
      hr(),
      p("Puoi ora chiudere questa finestra."),
      p(class = "text-muted small",
        "Per informazioni sulla ricerca: ",
        tags$a(href = "mailto:lorenzo.paravano@gmail.com", "lorenzo.paravano@gmail.com"))
    )
  ))
)
