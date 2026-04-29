ui <- function(request) {

  # ── Language detection ─────────────────────────────────────────────────────
  lang_q   <- parseQueryString(request$QUERY_STRING)$lang
  has_lang <- !is.null(lang_q) && lang_q %in% c("it","en","fr")
  lang     <- if (has_lang) lang_q else "it"
  tr       <- TR[[lang]]

  # ── Helper: build a segmented btn-check group ──────────────────────────────
  btn_check_group <- function(opts, name, id_prefix, extra_lbl_class = "") {
    lapply(seq_along(opts), function(v) tagList(
      tags$input(type = "radio", class = "btn-check",
                 name = name, id = paste0(id_prefix, "_", v),
                 value = opts[[v]], autocomplete = "off"),
      tags$label(
        class = paste("btn btn-audio btn-sm", extra_lbl_class),
        `for` = paste0(id_prefix, "_", v),
        names(opts)[v]
      )
    ))
  }

  # ── selectInput helper with leading placeholder ────────────────────────────
  sel <- function(inputId, label, opts, selected = "") {
    selectInput(inputId, label,
      choices  = c(setNames("", tr$sel_placeholder), opts),
      selected = selected)
  }

  # ── Pre-compute conditional pages (avoids if/else inside page_fluid args) ──
  page_lang_div <- if (!has_lang)
    div(id = "page_lang", class = "survey-page",
      div(class = "survey-container text-center",
        # University logo — top of page
        div(class = "lang-logo-wrap",
          tags$img(src = "logo_unitrento.jpg", class = "lang-logo",
                   alt = "Universita di Trento")
        ),
        # Level 1: main title (bold)
        div(class = "survey-header",
          h3(class = "lang-page-title",
            "Musica generata dall'AI nei servizi di streaming"
          ),
          # Level 2: multilingual subtitle (muted, smaller)
          p(class = "lang-title-sub",
            "AI-Generated Music in Streaming · Musique générée par l'IA dans le streaming")
        ),
        # Level 3: survey description — same style as Seleziona (no hr here)
        p(class = "lang-prompt mt-3 mb-2",
          "Indagine sulla preferenza dei consumatori · Consumer preference survey · Sondage sur les préférences"),
        hr(class = "my-2"),
        # Level 3: language prompt — same style
        p(class = "lang-prompt mb-4",
          "Seleziona la lingua · Select your language · Choisissez la langue"),
        div(class = "d-flex justify-content-center gap-3 flex-wrap",
          tags$a(class = "btn btn-outline-primary btn-lg px-4",
                 href = "?lang=it", "Italiano"),
          tags$a(class = "btn btn-outline-primary btn-lg px-4",
                 href = "?lang=en", "English"),
          tags$a(class = "btn btn-outline-primary btn-lg px-4",
                 href = "?lang=fr", "Français")
        )
      )
    )
  else
    hidden(div(id = "page_lang"))

  page_intro_div <- if (has_lang)
    div(id = "page_intro", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header text-center",
          h2(class = "intro-h2", tr$intro_title, tags$br(), tr$intro_title2)
        ),
        hr(),
        h5(tr$privacy_head),
        div(class = "consent-box",
          p(tags$strong(tr$intro_salute), tr$intro_body),
          p(tags$strong(tr$what_asked_h)),
          tr$what_asked,
          hr(class = "my-2"),
          p(tags$strong(tr$c_part_lbl), tr$c_part),
          p(tags$strong(tr$c_data_lbl), tr$c_data),
          p(tags$strong(tr$c_time_lbl), tr$c_time),
          hr(class = "my-2"),
          p(tags$strong(tr$contact_h)),
          tr$contact_info
        ),
        div(class = "consent-check-row mt-3",
          checkboxInput("consent_check", label = tr$consent_chk, value = FALSE)
        ),
        div(class = "nav-buttons",
          actionButton("btn_intro_next", tr$btn_start,
                       class = "btn btn-primary btn-lg"))
      )
    )
  else
    hidden(div(id = "page_intro", class = "survey-page",
      div(class = "survey-container")
    ))

  # ── UI ─────────────────────────────────────────────────────────────────────
  page_fluid(
    theme = bs_theme(
      version    = 5,
      bootswatch = "flatly",
      primary    = "#1DB954",
      font_scale = 1.05
    ),
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", href = "style.css?v=6"),
      tags$script(HTML(
        "// ── Block back-button navigation ────────────────────────────────────
        history.pushState(null, null, location.href);
        window.addEventListener('popstate', function() {
          history.pushState(null, null, location.href);
        });

        // ── Warn on refresh / tab-close ──────────────────────────────────────
        // Active only after the user clicks 'Inizia' (surveyStarted message).
        // Disabled again when submission is complete (surveyComplete message).
        var _warnOnLeave = false;
        window.addEventListener('beforeunload', function(e) {
          if (!_warnOnLeave) return;
          e.preventDefault();
          e.returnValue = '';
          return '';
        });
        Shiny.addCustomMessageHandler('surveyStarted', function(msg) {
          _warnOnLeave = true;
        });
        Shiny.addCustomMessageHandler('surveyComplete', function(msg) {
          _warnOnLeave = false;
        });

        document.addEventListener('play', function(e) {
          document.querySelectorAll('audio').forEach(function(a) {
            if (a !== e.target) { a.pause(); a.currentTime = 0; }
          });
        }, true);

        $(document).on('click', '.cbc-card', function() {
          var choice = $(this).data('choice');
          var task   = $(this).data('task');
          $(this).closest('.cbc-cards').find('.cbc-card').removeClass('cbc-card-selected');
          $(this).addClass('cbc-card-selected');
          Shiny.setInputValue('cbc_choice_' + task, String(choice), {priority: 'event'});
        });

        // Consent state tracker — updated via click (not change) for iOS Safari
        var _consentOK = false;
        $(document).on('click', '#consent_check', function() {
          _consentOK = this.checked;
          Shiny.setInputValue('consent_check', this.checked, {priority: 'event'});
        });

        function flashInvalid(el) {
          if (!el) return;
          el.style.outline = '2px solid #dc3545';
          el.style.borderRadius = '4px';
          setTimeout(function() { el.style.outline = ''; el.style.borderRadius = ''; }, 1500);
        }

        function validatePage(btnId) {
          var ok = true;
          if (btnId === 'btn_audio_next') {
            [1,2,3,4].forEach(function(i) {
              if (!document.querySelector('input[name=\"audio_rating_' + i + '\"]:checked')) {
                flashInvalid(document.querySelectorAll('.audio-clip-card')[i-1]);
                ok = false;
              }
            });
          } else if (btnId === 'btn_gaais_next') {
            document.querySelectorAll('#page_gaais .gaais-item').forEach(function(item) {
              if (!item.querySelector('input.btn-check:checked')) { flashInvalid(item); ok = false; }
            });
          } else if (btnId === 'btn_cbc_next') {
            if (!document.querySelector('.cbc-card-selected')) {
              flashInvalid(document.querySelector('.cbc-cards'));
              ok = false;
            }
          } else if (btnId === 'btn_proxy_next') {
            document.querySelectorAll('#page_proxy .gaais-item').forEach(function(item) {
              if (!item.querySelector('input.btn-check:checked')) { flashInvalid(item); ok = false; }
            });
            var churn = document.querySelector('#page_proxy .churn-section');
            if (churn && !churn.querySelector('input.btn-check:checked')) { flashInvalid(churn); ok = false; }
          }
          return ok;
        }

        $(document).on('click', 'button[id^=\"btn_\"]', function() {
          var btn = $(this);
          if (btn.prop('disabled')) return false;
          // Gate: intro button requires consent (checked via _consentOK, Safari-safe)
          if (this.id === 'btn_intro_next') {
            var cb = document.getElementById('consent_check');
            if (!_consentOK && !(cb && cb.checked)) {
              flashInvalid(document.querySelector('.consent-check-row'));
              return false;
            }
            Shiny.setInputValue('consent_check', true, {priority: 'event'});
          }
          // Gate: validate required page inputs before showing spinner
          if (!validatePage(this.id)) return false;
          // Stop all audio players when leaving the audio section
          if (this.id === 'btn_audio_next') {
            document.querySelectorAll('audio').forEach(function(a) {
              a.pause(); a.currentTime = 0;
            });
          }
          btn.prop('disabled', true);
          var orig = btn.html();
          btn.attr('data-orig-html', orig);
          btn.empty().append(
            $('<span>').addClass('spinner-border spinner-border-sm me-1').attr('role','status')
          );
          setTimeout(function() {
            btn.prop('disabled', false).html(btn.attr('data-orig-html') || orig);
          }, 10000);
        });

        $(document).on('change', 'input.btn-check', function() {
          Shiny.setInputValue($(this).attr('name'), $(this).val());
          var card = $(this).closest('.audio-clip-card');
          if (card.length) {
            card.addClass('clip-rated');
            card.find('.clip-rated-badge').show();
          }
          var item = $(this).closest('.gaais-item');
          if (item.length) item.addClass('item-answered');
        });"
      ))
    ),

    # ── Progress bar ──────────────────────────────────────────────────────────
    div(class = "progress-wrapper",
      div(id = "progress-bar-inner", class = "progress-bar-fill", style = "width:0%")
    ),

    # PAGE 0 — Language picker  /  PAGE 1 — Intro  (pre-computed above)
    page_lang_div,
    page_intro_div,

    # ── PAGE 2 — Audio discrimination ─────────────────────────────────────────
    hidden(div(id = "page_audio", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header",
          div(class = "audio-header-row",
            div(class = "page-badge", tr$badge1),
            div(class = "audio-hint-chip", tr$audio_hint)
          ),
          h3(tr$audio_h3),
          p(tr$audio_instr),
          div(class = "audio-context-box",
            div(class = "context-q", tags$strong(tr$audio_context_q)),
            div(class = "context-a", tr$audio_context)
          )
        ),
        uiOutput("audio_clips_ui"),
        div(class = "nav-buttons",
          actionButton("btn_audio_next", tr$btn_next, class = "btn btn-primary"))
      )
    )),

    # ── PAGE 3 — GAAIS-10 ─────────────────────────────────────────────────────
    hidden(div(id = "page_gaais", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header",
          div(class = "page-badge", tr$badge2),
          h3(tr$gaais_h3),
          div(class = "section-instr", tr$gaais_context)
        ),
        div(class = "gaais-list",
          lapply(seq_len(nrow(GAAIS_ITEMS)), function(i) {
            nm <- paste0("gaais_", GAAIS_ITEMS$code[i])
            div(class = "gaais-item",
              p(class = "item-text", paste0(i, ". ", tr$gaais[i])),
              div(class = "gaais-btn-group",
                btn_check_group(
                  setNames(as.character(1:5), tr$lik5),
                  name = nm, id_prefix = nm, extra_lbl_class = "gaais-btn"
                )
              )
            )
          })
        ),
        div(class = "nav-buttons",
          actionButton("btn_gaais_next", tr$btn_next, class = "btn btn-primary"))
      )
    )),

    # ── PAGE 4 — Framing pre-CBC ──────────────────────────────────────────────
    hidden(div(id = "page_framing", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header",
          div(class = "page-badge", tr$badge3),
          h3(tr$framing_h3)
        ),
        div(class = "framing-box",
          h5(tr$framing_ctx),
          p(tr$framing_p1)
        ),
        div(class = "stat-cards-row",
          lapply(1:4, function(i) {
            div(class = "stat-card",
              div(class = "stat-number", tr[[paste0("stat_", i, "_num")]]),
              div(class = "stat-label",  tr[[paste0("stat_", i, "_label")]]),
              div(class = "stat-source", tr[[paste0("stat_", i, "_src")]])
            )
          })
        ),
        div(class = "dsp-policy-box",
          h6(tr$dsp_policy_h),
          tags$table(class = "dsp-table",
            tags$tbody(
              tags$tr(tags$th("Spotify"),      tags$td(tr$dsp_spotify)),
              tags$tr(tags$th("Apple Music"),  tags$td(tr$dsp_apple)),
              tags$tr(tags$th("Deezer"),       tags$td(tr$dsp_deezer)),
              tags$tr(tags$th("Amazon Music"), tags$td(tr$dsp_amazon))
            )
          ),
          p(class = "text-muted small mt-2", tr$dsp_policy_note)
        ),
        div(class = "status-quo-card mt-3",
          tags$h6(tr$sq_title),
          p(class = "sq-intro", tr$sq_intro),
          tags$ul(
            tags$li(tr$sq_li1),
            tags$li(tr$sq_li2),
            tags$li(tr$sq_li3),
            tags$li(tr$sq_li4)
          )
        ),
        hr(),
        div(class = "framing-task",
          h5(tr$task_h5),
          p(tr$task_p1),
          div(class = "attr-list",
            # Attribute rows: colored bullet + colored label name
            div(class = "attr-row-framing attr-row-a",
              tags$span(class = "attr-icon", "•"),
              div(tags$strong(class = "attr-lbl-colored", tr$attr_a_lbl),
                  tr$attr_a_desc, tr$attr_a_levels)
            ),
            div(class = "attr-row-framing attr-row-b",
              tags$span(class = "attr-icon", "•"),
              div(tags$strong(class = "attr-lbl-colored", tr$attr_b_lbl),
                  tr$attr_b_desc, tr$attr_b_levels)
            ),
            div(class = "attr-row-framing attr-row-c",
              tags$span(class = "attr-icon", "•"),
              div(tags$strong(class = "attr-lbl-colored", tr$attr_c_lbl),
                  tr$attr_c_desc, tr$attr_c_levels)
            ),
            div(class = "attr-row-framing attr-row-d",
              tags$span(class = "attr-icon", "•"),
              div(tags$strong(class = "attr-lbl-colored", tr$attr_d_lbl),
                  tr$attr_d_desc, tr$attr_d_levels)
            )
          ),
          p(class = "mt-3", tr$task_p2)
        ),
        div(class = "nav-buttons",
          actionButton("btn_framing_next", tr$btn_start_cbc,
                       class = "btn btn-primary btn-lg"))
      )
    )),

    # ── PAGE 5 — CBC tasks ────────────────────────────────────────────────────
    hidden(div(id = "page_cbc", class = "survey-page",
      div(class = "survey-container",
        uiOutput("cbc_task_ui"),
        div(class = "nav-buttons",
          actionButton("btn_cbc_next", tr$btn_next, class = "btn btn-primary"))
      )
    )),

    # ── PAGE 6 — Proxy + behavioural + churn ──────────────────────────────────
    hidden(div(id = "page_proxy", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header",
          div(class = "page-badge", tr$badge4),
          h3(tr$proxy_h3),
          p(tr$proxy_instr)
        ),
        div(class = "gaais-list",
          lapply(seq_len(nrow(PROXY_ITEMS)), function(i) {
            nm <- PROXY_ITEMS$code[i]
            div(class = "gaais-item",
              p(class = "item-text", paste0(i, ". ", tr$proxy[i])),
              div(class = "gaais-btn-group",
                btn_check_group(
                  setNames(as.character(1:5), tr$lik5),
                  name = nm, id_prefix = nm, extra_lbl_class = "gaais-btn"
                )
              )
            )
          })
        ),
        hr(),
        h5(tr$behav_h5),
        div(class = "gaais-list",
          div(class = "gaais-item",
            p(class = "item-text", tr$freq_q),
            div(class = "gaais-btn-group",
              btn_check_group(tr$freq_opts, "music_freq", "music_freq", extra_lbl_class = "gaais-btn"))
          ),
          div(class = "gaais-item",
            p(class = "item-text", tr$aware_q),
            div(class = "gaais-btn-group",
              btn_check_group(tr$aware_opts, "ai_awareness", "ai_aware", extra_lbl_class = "gaais-btn"))
          )
        ),
        hr(),
        div(class = "churn-section",
          h5(tr$churn_h5),
          p(tr$churn_q),
          div(class = "gaais-btn-group mt-2",
            btn_check_group(
              setNames(as.character(1:5), tr$lik5p),
              name = "churn_intent", id_prefix = "churn",
              extra_lbl_class = "gaais-btn"
            )
          )
        ),
        div(class = "nav-buttons",
          actionButton("btn_proxy_next", tr$btn_next, class = "btn btn-primary"))
      )
    )),

    # ── PAGE 7 — Demographics ─────────────────────────────────────────────────
    hidden(div(id = "page_demo", class = "survey-page",
      div(class = "survey-container",
        div(class = "survey-header",
          div(class = "page-badge", tr$badge5),
          h3(tr$demo_h3),
          p(tr$demo_instr)
        ),
        fluidRow(
          column(6, sel("demo_age",    tr$age_lbl,    tr$age_opts)),
          column(6, sel("demo_gender", tr$gender_lbl, tr$gender_opts))
        ),
        fluidRow(
          column(6, sel("demo_country",   tr$country_lbl, tr$country_opts)),
          column(6, sel("demo_education", tr$edu_lbl,     tr$edu_opts))
        ),
        hr(),
        h5(tr$dsp_h5),
        radioButtons("dsp_user",
          label    = tr$dsp_user_q,
          choices  = tr$dsp_yn,
          selected = character(0),
          inline   = TRUE
        ),
        conditionalPanel(
          condition = "input.dsp_user === 'yes'",
          sel("dsp_current", tr$dsp_svc_lbl,  tr$dsp_opts),
          sel("dsp_tier",    tr$dsp_tier_lbl, tr$tier_opts)
        ),
        hr(),
        div(class = "submit-section",
          p(class = "text-muted small", tr$submit_warn),
          actionButton("btn_demo_submit", tr$btn_submit,
                       class = "btn btn-success btn-lg",
                       icon  = icon("paper-plane"))
        )
      )
    )),

    # ── PAGE 8 — Thank you ────────────────────────────────────────────────────
    hidden(div(id = "page_thankyou", class = "survey-page",
      div(class = "survey-container thankyou-container text-center",
        div(class = "thankyou-icon", icon("circle-check")),
        h2(tr$ty_h2),
        p(class = "lead", tr$ty_lead),
        hr(),
        p(tr$ty_close),
        div(class = "text-muted small",
          p(tr$ty_contact),
          tr$contact_info
        )
      )
    ))
  )
}
