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
        div(class = "intro-logo-wrap text-center",
          tags$img(src = "logo_unitrento.jpg", class = "intro-logo",
                   alt = "Universita di Trento")
        ),
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
        div(class = "alert alert-warning py-2 mt-3 small", tr$survey_warn),
        div(class = "consent-check-row mt-2",
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
      primary    = "#2563eb",
      font_scale = 1.05
    ),
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", href = "style.css?v=32"),
      tags$script(src = "survey.js?v=5")
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
          div(class = "section-instr", tr$gaais_context_intro),
          div(class = "audio-context-box",
            div(class = "context-q", tags$strong(tr$gaais_context_q)),
            div(class = "context-a", tr$gaais_ai_def)
          ),
          div(class = "section-instr", tr$gaais_context_scale)
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
        p(class = "text-muted mb-2", tr$framing_p1),
        p(class = "text-muted mb-3", tr$framing_p2),
        div(class = "dsp-policy-box",
          h6(tr$dsp_policy_h),
          tags$table(class = "dsp-table",
            tags$tbody(
              tags$tr(
                tags$th(tagList(tags$img(src="logo_deezer.svg",       class="dsp-logo"), "Deezer",       tags$br(), tags$span(class="dsp-badge badge-algo",  tr$dsp_badge_deezer))),
                tags$td(tr$dsp_deezer)),
              tags$tr(
                tags$th(tagList(tags$img(src="logo_spotify.svg",      class="dsp-logo"), "Spotify",      tags$br(), tags$span(class="dsp-badge badge-self",  tr$dsp_badge_spotify))),
                tags$td(tr$dsp_spotify)),
              tags$tr(
                tags$th(tagList(tags$img(src="logo_apple_music.svg",  class="dsp-logo"), "Apple Music",  tags$br(), tags$span(class="dsp-badge badge-self",  tr$dsp_badge_apple))),
                tags$td(tr$dsp_apple)),
              tags$tr(
                tags$th(tagList(tags$img(src="logo_amazon_music.svg", class="dsp-logo"), "Amazon Music", tags$br(), tags$span(class="dsp-badge badge-none",  tr$dsp_badge_amazon))),
                tags$td(tr$dsp_amazon))
            )
          ),
          p(class = "text-muted small mt-2", tr$dsp_policy_note)
        ),
        hr(),
        p(class = "mt-2 mb-3", tr$framing_bridge),
        div(class = "framing-task",
          h5(tr$task_h5),
          p(tr$task_p1),
          div(class = "attr-list",
            div(class = "attr-row-framing attr-row-a",
              tags$span(class = "attr-icon", "•"),
              div(tags$strong(class = "attr-lbl-colored", tr$attr_a_lbl),
                  tr$attr_a_desc,
                  tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;",
                              `data-img` = "ai_label.png", tr$attr_a_pill),
                  tr$attr_a_levels)
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
          div(class = "audio-context-box mt-3",
            div(class = "context-a", tr$sq_note)
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
          }),
          # Item 6: AI tools acceptability checkbox (behavioural proxy for GAAIS_neg)
          div(class = "gaais-item",
            p(class = "item-text", paste0(nrow(PROXY_ITEMS) + 1, ". ", tr$ai_tools_q)),
            div(class = "ai-tools-check",
              checkboxGroupInput("ai_tools_acceptable",
                label = NULL,
                choiceNames  = tr$ai_tools_opts_html,
                choiceValues = tr$ai_tools_opts_val,
                selected = character(0)
              )
            )
          )
        ),
        hr(),
        h5(tr$dsp_h5),
        div(class = "gaais-item",
          p(class = "item-text", tr$dsp_user_q),
          div(class = "gaais-btn-group",
            btn_check_group(tr$dsp_yn, "dsp_user", "dsp_user",
                            extra_lbl_class = "gaais-btn")
          )
        ),
        conditionalPanel(
          condition = "input.dsp_user === 'yes' || input.dsp_user === 'yes_free'",
          div(class = "gaais-item",
            sel("dsp_current", tr$dsp_svc_lbl,  tr$dsp_opts)
          ),
          div(class = "gaais-item mt-2",
            p(class = "item-text", tr$switching_past_q),
            div(class = "gaais-btn-group",
              btn_check_group(tr$switching_past_opts, "switching_past", "sp",
                              extra_lbl_class = "gaais-btn")
            )
          ),
          conditionalPanel(
            condition = "input.switching_past === 'yes_switched'",
            div(class = "gaais-item mt-1",
              p(class = "item-text", tr$switching_reason_q),
              div(class = "radio-v-group",
                btn_check_group(tr$switching_reason_opts, "switching_reason", "sr",
                                extra_lbl_class = "btn-radio-v")
              )
            )
          )
        ),
        conditionalPanel(
          condition = "input.dsp_user === 'yes' || input.dsp_user === 'yes_free'",
          div(class = "gaais-item churn-section mt-3",
            p(class = "item-text", tr$churn_q),
            div(class = "gaais-btn-group mt-2",
              btn_check_group(
                setNames(as.character(1:5), tr$lik5p),
                name = "churn_intent", id_prefix = "churn",
                extra_lbl_class = "gaais-btn"
              )
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
          column(6, sel("demo_country", tr$country_lbl, tr$country_opts)),
          column(6, sel("demo_role",    tr$role_lbl,    tr$role_opts))
        ),
        div(class = "submit-section mt-3",
          actionButton("btn_demo_submit", tr$btn_submit,
                       class = "btn btn-primary btn-lg",
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

        # ── Share section ───────────────────────────────────────────────────
        div(class = "share-section",
          h6(class = "share-title", icon("share-nodes"), " ", tr$ty_share_h),
          div(class = "share-url-row",
            tags$input(type = "text", id = "share_url_box", readOnly = TRUE,
                       class = "form-control form-control-sm share-url-input",
                       value = "https://parlor.shinyapps.io/AI_music_governance_cbc_survey/"),
            tags$button(type = "button", id = "btn_copy_link",
                        class = "btn btn-outline-secondary btn-sm share-copy-btn",
                        onclick = "copySurveyLink(this)",
                        `data-label` = tr$ty_share_copy,
                        `data-copied` = tr$ty_share_copied,
                        icon("copy"), " ", tr$ty_share_copy)
          ),
          div(class = "share-btn-row mt-2",
            tags$a(class = "btn btn-share-wa btn-sm",
                   href = "https://api.whatsapp.com/send?text=https%3A%2F%2Fparlor.shinyapps.io%2FAI_music_governance_cbc_survey%2F",
                   target = "_blank", rel = "noopener",
                   icon("whatsapp"), " ", tr$ty_share_wa),
            tags$a(class = "btn btn-share-email btn-sm",
                   href = paste0("mailto:?body=https%3A%2F%2Fparlor.shinyapps.io%2FAI_music_governance_cbc_survey%2F"),
                   icon("envelope"), " ", tr$ty_share_email)
          )
        ),

        p(class = "small mt-3", style = "color:#2563eb;", tr$ty_close),
        hr(),
        div(class = "thankyou-logo-wrap text-center mb-3",
          tags$img(src = "logo_unitrento.jpg", class = "thankyou-logo",
                   alt = "Universita di Trento")
        ),
        div(class = "text-muted small",
          p(tr$ty_contact),
          tr$contact_info
        )
      )
    ))
  )
}
