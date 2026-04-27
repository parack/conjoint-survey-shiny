# ── translations.R ────────────────────────────────────────────────────────────
# Single source of truth for all survey text (IT / EN / FR).
# Sourced from global.R after library(shiny) so tags$* functions are available.
# TR[[lang]]$key  →  used in ui.R (static) and server.R (dynamic renderUI / err)
# ─────────────────────────────────────────────────────────────────────────────

TR <- list(

  # ══════════════════════════════════════════════════════════════════════════
  # ITALIANO
  # ══════════════════════════════════════════════════════════════════════════
  it = list(

    # ── Number / price formatting ──────────────────────────────────────────
    decimal_sep = ",",
    per_month   = "/mese",

    # ── Audio discrimination choices (name = display label, value = code) ──
    # Order matches button order in server: 4, 3, 2, 1, 5
    audio_ch = c(
      "Sicuramente AI"    = "4",
      "Probabilmente AI"  = "3",
      "Probabilmente umana" = "2",
      "Sicuramente umana" = "1",
      "Non so"            = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Valutata",
    audio_msg  = "Il tuo browser non supporta la riproduzione audio.",

    # ── Likert scales ──────────────────────────────────────────────────────
    lik5  = c("Fortemente in disaccordo", "In disaccordo", "Neutrale",
              "D\u2019accordo", "Fortemente d\u2019accordo"),
    lik5p = c("Per nulla probabile", "Poco probabile", "Neutrale",
              "Probabile", "Molto probabile"),

    # ── Behavioural question options ───────────────────────────────────────
    freq_opts  = c("Mai"="never", "Qualche volta al mese"="monthly",
                   "Qualche volta a settimana"="weekly", "Ogni giorno"="daily"),
    bg_opts    = c("Nessuno"="none", "Appassionato"="enthusiast",
                   "Amatoriale"="amateur", "Musicista professionista"="professional"),
    fam_opts   = c("S\u00ec"="yes", "No"="no"),
    aware_opts = c("S\u00ec"="yes", "No"="no", "Non ero sicuro/a"="unsure"),
    dsp_yn     = c("S\u00ec"="yes", "No"="no"),

    # ── CBC attribute levels ───────────────────────────────────────────────
    A1 = c(
      "Nessuna label AI visibile (solo metadata interni, non accessibili agli utenti)",
      "Label AI volontaria (visibile solo se dichiarata dal distributore all\u2019upload)",
      "Label AI obbligatoria (garantita dalla piattaforma, indipendente dall\u2019artista)"
    ),
    A2 = c(
      "Musica AI non inclusa nelle playlist raccomandate",
      "Musica AI nelle playlist raccomandate e generaliste",
      "Musica AI nelle playlist raccomandate + spazio dedicato AI aggiuntivo"
    ),
    A3 = c(
      "Nessun controllo utente sulla musica AI",
      "Filtro parziale: esclusione musica AI dalle playlist personalizzate",
      "Filtro completo: blocco totale della musica AI dalla piattaforma"
    ),

    # ── GAAIS-10 item texts (Cicero et al. 2025 Italian validation) ────────
    gaais = c(
      "Sono interessato/a a utilizzare sistemi di intelligenza artificiale nella mia vita quotidiana.",
      "Trovo l\u2019intelligenza artificiale inquietante.",
      "L\u2019intelligenza artificiale potrebbe prendere il controllo delle persone.",
      "Penso che l\u2019intelligenza artificiale sia pericolosa.",
      "L\u2019intelligenza artificiale pu\u00f2 avere un impatto positivo sul benessere delle persone.",
      "L\u2019intelligenza artificiale \u00e8 entusiasmante.",
      "Gran parte della societ\u00e0 beneficier\u00e0 di un futuro ricco di intelligenza artificiale.",
      "Vorrei utilizzare l\u2019intelligenza artificiale nel mio lavoro.",
      "Rabbrividisco di disagio quando penso ai futuri utilizzi dell\u2019intelligenza artificiale.",
      "Persone come me soffriranno se l\u2019intelligenza artificiale verr\u00e0 utilizzata sempre di pi\u00f9."
    ),

    # ── Proxy item texts ───────────────────────────────────────────────────
    proxy = c(
      "Riesco a distinguere la musica creata dall\u2019intelligenza artificiale da quella suonata da musicisti umani.",
      "Percepisco differenze nella qualit\u00e0 emotiva tra musica AI e musica umana.",
      "Mi accorgo quando una canzone \u00e8 stata generata artificialmente.",
      "Sono preoccupato/a per l\u2019impatto dell\u2019intelligenza artificiale sull\u2019industria musicale.",
      "Preferisco ascoltare musica creata esclusivamente da musicisti umani.",
      "Ritengo che la musica generata dall\u2019AI non possa eguagliare quella umana sul piano emotivo."
    ),

    # ── Demographic option vectors (name = display label, value = code) ────
    sel_placeholder = "-- Seleziona --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Uomo"="man", "Donna"="woman",
                    "Non binario / Terzo genere"="nonbinary",
                    "Preferisco non specificare"="no_answer"),
    edu_opts    = c(
      "Licenza media"                              = "middle",
      "Diploma di scuola superiore"                = "highschool",
      "Laurea triennale (L)"                       = "bachelor",
      "Laurea magistrale / Ciclo unico (LM / LMU)" = "master",
      "Dottorato di ricerca / Post-laurea"         = "phd"
    ),
    country_opts = c(
      "Italia"="IT","Francia"="FR","Germania"="DE","Spagna"="ES","Portogallo"="PT",
      "Regno Unito"="GB","Paesi Bassi"="NL","Belgio"="BE","Svizzera"="CH","Austria"="AT",
      "Polonia"="PL","Romania"="RO","Repubblica Ceca"="CZ","Svezia"="SE","Norvegia"="NO",
      "Danimarca"="DK","Finlandia"="FI","Grecia"="GR","Ungheria"="HU","Croazia"="HR",
      "Stati Uniti"="US","Canada"="CA","Australia"="AU","Brasile"="BR","Argentina"="AR",
      "Altro"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Altro"="other"),
    tier_opts = c("Gratuito (con pubblicit\u00e0)"="free",
                  "Premium individuale"="premium_ind",
                  "Premium famiglia / Duo"="premium_fam",
                  "Studente"="student","Altro"="other"),

    # ── Error messages ─────────────────────────────────────────────────────
    err_consent  = "Devi acconsentire alla partecipazione per continuare.",
    err_audio    = "Valuta tutte e 4 le clip prima di procedere.",
    err_gaais    = "Rispondi a tutti gli item prima di procedere.",
    err_cbc      = "Seleziona un\u2019opzione prima di procedere.",
    err_proxy    = "Rispondi a tutti gli item prima di procedere.",
    err_demo_req = "Compila tutti i campi demografici obbligatori (*).",
    err_dsp_user = "Indica se utilizzi un servizio di streaming musicale.",
    err_dsp_svc  = "Indica il servizio di streaming che utilizzi principalmente.",
    err_dsp_tier = "Indica il tipo di abbonamento.",

    # ── Page strings ───────────────────────────────────────────────────────

    # Intro
    intro_title    = "Preferenze dei consumatori per la governance dell\u2019AI",
    intro_title2   = "nei servizi musicali in streaming",
    intro_subtitle = "Sondaggio per tesi magistrale \u2022 Universit\u00e0 degli Studi di Trento",
    privacy_head   = "Informativa sulla privacy e consenso informato",
    c_obj_lbl  = "Oggetto della ricerca:",
    c_obj      = " Preferenze dei consumatori rispetto a diverse configurazioni di governance del contenuto musicale generato dall\u2019intelligenza artificiale nei servizi di streaming digitale.",
    c_who_lbl  = "Chi conduce la ricerca:",
    c_who      = " Lorenzo Paravano, tesi magistrale, Universit\u00e0 degli Studi di Trento.",
    c_part_lbl = "Partecipazione:",
    c_part     = " Volontaria e anonima. Nessun dato identificativo personale \u00e8 raccolto.",
    c_data_lbl = "Dati raccolti:",
    c_data     = " Risposte alle domande del sondaggio (preferenze, atteggiamenti, dati demografici aggregati). I dati saranno presentati esclusivamente in forma aggregata.",
    c_time_lbl = "Durata stimata:",
    c_time     = " 10\u201315 minuti.",
    c_gdpr_lbl = "Trattamento dei dati:",
    c_gdpr     = " I dati sono trattati in conformit\u00e0 al GDPR (Reg. UE 2016/679) esclusivamente per finalit\u00e0 di ricerca accademica.",
    consent_chk = "Ho letto l\u2019informativa e acconsento volontariamente a partecipare al sondaggio.",
    btn_start   = "Inizia \u2192",

    # Audio
    badge1     = "Sezione 1 di 5",
    audio_h3   = "Task di Discriminazione Audio",
    audio_instr = tagList(
      "Ascolta ciascuna delle ", tags$strong("4 clip musicali"), " qui sotto e indica, per ognuna, ",
      "quanto pensi che sia stata prodotta dall\u2019intelligenza artificiale o da un musicista umano. ",
      "Usa la scala a 4 punti, da ", tags$em("Sicuramente umana"), " a ", tags$em("Sicuramente AI"), ". ",
      "Se non sei sicuro/a, seleziona ", tags$em("\u201cNon so\u201d"), "."
    ),
    btn_next = "Avanti \u2192",

    # GAAIS
    badge2      = "Sezione 2 di 5",
    gaais_h3    = "Atteggiamenti verso l\u2019Intelligenza Artificiale",
    gaais_instr = "Per ciascuna affermazione, indica il tuo grado di accordo.",

    # Framing
    badge3      = "Sezione 3 di 5",
    framing_h3  = "Politiche AI nei servizi di streaming musicale",
    framing_ctx = "Contesto attuale",
    framing_p1  = "I servizi di streaming musicale (Spotify, Apple Music, Amazon Music, ecc.) ospitano una quantit\u00e0 crescente di tracce generate interamente o parzialmente dall\u2019intelligenza artificiale. Nella maggior parte delle piattaforme oggi:",
    framing_li1 = tagList(tags$strong("Non esiste alcuna label"), " consumer-facing che identifichi le tracce AI."),
    framing_li2 = tagList("Le tracce AI vengono ", tags$strong("incluse nelle playlist raccomandate"), " accanto alla musica umana."),
    framing_li3 = tagList(tags$strong("Non \u00e8 disponibile alcun filtro"), " per escludere le tracce AI."),
    sq_title    = "Configurazione attuale (status quo \u2014 punto di riferimento)",
    sq_li1      = tagList("Policy labeling AI: ", tags$em("Nessuna label consumer-facing")),
    sq_li2      = tagList("Struttura promozionale: ", tags$em("Musica AI nelle playlist raccomandate")),
    sq_li3      = tagList("Controllo utente: ", tags$em("Nessun filtro disponibile")),
    sq_li4      = tagList("Prezzo abbonamento: ", tags$em("\u20ac11,99/mese")),
    task_h5     = "Come leggere le scelte",
    task_p1     = tagList(
      "Nelle pagine successive vedrai ", tags$strong("12 situazioni ipotetiche"), ". ",
      "In ciascuna sono presentate ", tags$strong("3 alternative di abbonamento"), " che differiscono per:"
    ),
    attr_a_lbl  = "Policy di labeling AI:",
    attr_a_desc = " come la piattaforma comunica quale musica \u00e8 generata dall\u2019AI.",
    attr_b_lbl  = "Struttura promozionale:",
    attr_b_desc = " se e come la musica AI \u00e8 inclusa nelle playlist raccomandate.",
    attr_c_lbl  = "Controllo utente:",
    attr_c_desc = " quali strumenti hai per filtrare o bloccare la musica AI.",
    attr_d_lbl  = "Prezzo mensile:",
    attr_d_desc = " il costo dell\u2019abbonamento.",
    task_p2     = tagList(
      "Per ciascuna situazione, ", tags$strong("scegli l\u2019alternativa che preferiresti"),
      " come tuo piano di abbonamento. ",
      "Non esistono risposte giuste o sbagliate: conta esclusivamente la tua preferenza personale."
    ),
    btn_start_cbc = "Inizia le scelte \u2192",

    # CBC
    cbc_badge = "Sezione 3 di 5",
    cbc_q     = "Quale di queste configurazioni di abbonamento preferiresti?",
    cbc_instr = tagList(
      "Le 3 alternative differiscono per policy AI e prezzo. ",
      "Clicca sulla configurazione che preferiresti realmente adottare."
    ),
    cbc_opt   = "Opzione",
    cbc_a1lbl = "Policy labeling AI",
    cbc_a2lbl = "Struttura promozionale",
    cbc_a3lbl = "Controllo utente",

    # Proxy
    badge4      = "Sezione 4 di 5",
    proxy_h3    = "Esperienze musicali e percezione dell\u2019AI",
    proxy_instr = "Indica il tuo grado di accordo con ciascuna affermazione.",
    behav_h5    = "Abitudini di ascolto e familiarit\u00e0 con l\u2019AI",
    freq_q      = "Con quale frequenza ascolti musica in streaming?",
    bg_q        = "Come descriveresti il tuo rapporto con la musica?",
    fam_q       = "Hai mai usato strumenti di AI generativa (es. ChatGPT, Suno, Midjourney)?",
    aware_q     = "Prima di questo sondaggio, sapevi che il tuo servizio di streaming include tracce generate dall\u2019AI?",
    churn_h5    = "Intenzione di abbandono",
    churn_q     = tagList(
      "Ipotizzando che il tuo servizio di streaming attuale ",
      tags$strong("non apportasse alcuna modifica"),
      " alle politiche sulla musica AI nei prossimi 12 mesi, quanto saresti propenso/a a ",
      "cancellare o cambiare abbonamento?"
    ),

    # Demographics
    badge5       = "Sezione 5 di 5",
    demo_h3      = "Dati demografici e utilizzo dei servizi",
    demo_instr   = "Ultima sezione. Tutte le informazioni sono anonime e usate esclusivamente a fini statistici.",
    age_lbl      = "Fascia d\u2019et\u00e0 *",
    gender_lbl   = "Genere *",
    country_lbl  = "Paese di residenza *",
    edu_lbl      = "Titolo di studio pi\u00f9 elevato conseguito *",
    dsp_h5       = "Utilizzo dei servizi di streaming musicale",
    dsp_user_q   = "Sei attualmente abbonato/a o utilizzi regolarmente un servizio di streaming musicale? *",
    dsp_svc_lbl  = "Quale servizio utilizzi principalmente? *",
    dsp_tier_lbl = "Tipo di abbonamento *",
    submit_warn  = "(\u26a0) Controlla le tue risposte: dopo l\u2019invio non sar\u00e0 possibile modificarle.",
    btn_submit   = "Invia le risposte",

    # Thank you
    ty_h2     = "Grazie per la tua partecipazione!",
    ty_lead   = "Le tue risposte sono state registrate con successo.",
    ty_close  = "Puoi ora chiudere questa finestra.",
    ty_contact = "Per informazioni sulla ricerca: "
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # ENGLISH
  # ══════════════════════════════════════════════════════════════════════════
  en = list(

    decimal_sep = ".",
    per_month   = "/month",

    audio_ch = c(
      "Definitely AI"    = "4",
      "Probably AI"      = "3",
      "Probably human"   = "2",
      "Definitely human" = "1",
      "Don\u2019t know"  = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Rated",
    audio_msg  = "Your browser does not support audio playback.",

    lik5  = c("Strongly disagree","Disagree","Neutral","Agree","Strongly agree"),
    lik5p = c("Not at all likely","Unlikely","Neutral","Likely","Very likely"),

    freq_opts  = c("Never"="never","A few times a month"="monthly",
                   "A few times a week"="weekly","Every day"="daily"),
    bg_opts    = c("None"="none","Enthusiast"="enthusiast",
                   "Amateur"="amateur","Professional musician"="professional"),
    fam_opts   = c("Yes"="yes","No"="no"),
    aware_opts = c("Yes"="yes","No"="no","I wasn\u2019t sure"="unsure"),
    dsp_yn     = c("Yes"="yes","No"="no"),

    A1 = c(
      "No visible AI label (internal metadata only, not accessible to users)",
      "Voluntary AI label (visible only if declared by the distributor at upload)",
      "Mandatory AI label (guaranteed by the platform, independent of the artist)"
    ),
    A2 = c(
      "AI music not included in recommended playlists",
      "AI music in recommended and general playlists",
      "AI music in recommended playlists + additional dedicated AI space"
    ),
    A3 = c(
      "No user control over AI music",
      "Partial filter: exclude AI music from personalised playlists",
      "Full filter: total block of AI music from the platform"
    ),

    # Schepman & Rodway (2020) validated English items
    gaais = c(
      "I am interested in using artificial intelligence systems in my everyday life.",
      "I find artificial intelligence unsettling.",
      "Artificial intelligence can take control of people.",
      "I think artificial intelligence is dangerous.",
      "Artificial intelligence can have a positive impact on people\u2019s wellbeing.",
      "Artificial intelligence is exciting.",
      "Much of society will benefit from a future full of artificial intelligence.",
      "I would like to use artificial intelligence in my work.",
      "I shudder with discomfort when I think about future uses of artificial intelligence.",
      "People like me will suffer if artificial intelligence is used more and more."
    ),

    proxy = c(
      "I can distinguish music created by artificial intelligence from music played by human musicians.",
      "I perceive differences in emotional quality between AI music and human music.",
      "I notice when a song has been artificially generated.",
      "I am concerned about the impact of artificial intelligence on the music industry.",
      "I prefer to listen to music created exclusively by human musicians.",
      "I believe AI-generated music cannot match human music on an emotional level."
    ),

    sel_placeholder = "-- Select --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Man"="man","Woman"="woman",
                    "Non-binary / Third gender"="nonbinary",
                    "Prefer not to say"="no_answer"),
    edu_opts    = c(
      "Middle school diploma"   = "middle",
      "High school diploma"     = "highschool",
      "Bachelor\u2019s degree"  = "bachelor",
      "Master\u2019s degree"    = "master",
      "PhD / Post-graduate"     = "phd"
    ),
    country_opts = c(
      "Italy"="IT","France"="FR","Germany"="DE","Spain"="ES","Portugal"="PT",
      "United Kingdom"="GB","Netherlands"="NL","Belgium"="BE","Switzerland"="CH","Austria"="AT",
      "Poland"="PL","Romania"="RO","Czech Republic"="CZ","Sweden"="SE","Norway"="NO",
      "Denmark"="DK","Finland"="FI","Greece"="GR","Hungary"="HU","Croatia"="HR",
      "United States"="US","Canada"="CA","Australia"="AU","Brazil"="BR","Argentina"="AR",
      "Other"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Other"="other"),
    tier_opts = c("Free (with ads)"="free","Premium individual"="premium_ind",
                  "Premium family / Duo"="premium_fam","Student"="student","Other"="other"),

    err_consent  = "You must consent to participate in order to continue.",
    err_audio    = "Please rate all 4 clips before proceeding.",
    err_gaais    = "Please answer all items before proceeding.",
    err_cbc      = "Please select an option before proceeding.",
    err_proxy    = "Please answer all items before proceeding.",
    err_demo_req = "Please fill in all required demographic fields (*).",
    err_dsp_user = "Please indicate whether you use a music streaming service.",
    err_dsp_svc  = "Please indicate the streaming service you use most.",
    err_dsp_tier = "Please indicate your subscription type.",

    intro_title    = "Consumer Preferences for AI Governance",
    intro_title2   = "in Music Streaming Services",
    intro_subtitle = "Master\u2019s thesis survey \u2022 University of Trento",
    privacy_head   = "Privacy notice and informed consent",
    c_obj_lbl  = "Research subject:",
    c_obj      = " Consumer preferences for different AI-generated music content governance configurations in digital streaming services.",
    c_who_lbl  = "Research conducted by:",
    c_who      = " Lorenzo Paravano, Master\u2019s thesis, University of Trento.",
    c_part_lbl = "Participation:",
    c_part     = " Voluntary and anonymous. No personal identifying data is collected.",
    c_data_lbl = "Data collected:",
    c_data     = " Survey responses (preferences, attitudes, aggregated demographic data). Data will be presented exclusively in aggregated form.",
    c_time_lbl = "Estimated duration:",
    c_time     = " 10\u201315 minutes.",
    c_gdpr_lbl = "Data processing:",
    c_gdpr     = " Data are processed in compliance with the GDPR (EU Reg. 2016/679) exclusively for academic research purposes.",
    consent_chk = "I have read the privacy notice and voluntarily consent to participate in the survey.",
    btn_start   = "Start \u2192",

    badge1     = "Section 1 of 5",
    audio_h3   = "Audio Discrimination Task",
    audio_instr = tagList(
      "Listen to each of the ", tags$strong("4 music clips"), " below and indicate, for each one, ",
      "how much you think it was produced by artificial intelligence or by a human musician. ",
      "Use the 4-point scale, from ", tags$em("Definitely human"), " to ", tags$em("Definitely AI"), ". ",
      "If you are unsure, select ", tags$em("\u201cDon\u2019t know\u201d"), "."
    ),
    btn_next = "Next \u2192",

    badge2      = "Section 2 of 5",
    gaais_h3    = "Attitudes towards Artificial Intelligence",
    gaais_instr = "For each statement, indicate your level of agreement.",

    badge3      = "Section 3 of 5",
    framing_h3  = "AI Policies in Music Streaming Services",
    framing_ctx = "Current context",
    framing_p1  = "Music streaming services (Spotify, Apple Music, Amazon Music, etc.) host a growing number of tracks generated entirely or partially by artificial intelligence. On most platforms today:",
    framing_li1 = tagList(tags$strong("No consumer-facing label"), " exists to identify AI tracks."),
    framing_li2 = tagList("AI tracks are ", tags$strong("included in recommended playlists"), " alongside human music."),
    framing_li3 = tagList(tags$strong("No filter is available"), " to exclude AI tracks."),
    sq_title    = "Current configuration (status quo \u2014 reference point)",
    sq_li1      = tagList("AI labelling policy: ", tags$em("No consumer-facing label")),
    sq_li2      = tagList("Promotional structure: ", tags$em("AI music in recommended playlists")),
    sq_li3      = tagList("User control: ", tags$em("No filter available")),
    sq_li4      = tagList("Subscription price: ", tags$em("\u20ac11.99/month")),
    task_h5     = "How to read the choices",
    task_p1     = tagList(
      "On the following pages you will see ", tags$strong("12 hypothetical situations"), ". ",
      "Each presents ", tags$strong("3 subscription alternatives"), " that differ in:"
    ),
    attr_a_lbl  = "AI labelling policy:",
    attr_a_desc = " how the platform communicates which music is AI-generated.",
    attr_b_lbl  = "Promotional structure:",
    attr_b_desc = " whether and how AI music is included in recommended playlists.",
    attr_c_lbl  = "User control:",
    attr_c_desc = " what tools you have to filter or block AI music.",
    attr_d_lbl  = "Monthly price:",
    attr_d_desc = " the cost of the subscription.",
    task_p2     = tagList(
      "For each situation, ", tags$strong("choose the alternative you would prefer"),
      " as your subscription plan. ",
      "There are no right or wrong answers: only your personal preference counts."
    ),
    btn_start_cbc = "Start choices \u2192",

    cbc_badge = "Section 3 of 5",
    cbc_q     = "Which of these subscription configurations would you prefer?",
    cbc_instr = tagList(
      "The 3 alternatives differ in AI policy and price. ",
      "Click on the configuration you would really adopt."
    ),
    cbc_opt   = "Option",
    cbc_a1lbl = "AI labelling policy",
    cbc_a2lbl = "Promotional structure",
    cbc_a3lbl = "User control",

    badge4      = "Section 4 of 5",
    proxy_h3    = "Music experiences and AI perception",
    proxy_instr = "Indicate your level of agreement with each statement.",
    behav_h5    = "Listening habits and AI familiarity",
    freq_q      = "How often do you listen to streaming music?",
    bg_q        = "How would you describe your relationship with music?",
    fam_q       = "Have you ever used generative AI tools (e.g. ChatGPT, Suno, Midjourney)?",
    aware_q     = "Before this survey, did you know that your streaming service includes AI-generated tracks?",
    churn_h5    = "Switching intention",
    churn_q     = tagList(
      "Assuming your current streaming service made ",
      tags$strong("no changes"),
      " to its AI music policies over the next 12 months, how likely would you be to ",
      "cancel or switch your subscription?"
    ),

    badge5       = "Section 5 of 5",
    demo_h3      = "Demographics and service usage",
    demo_instr   = "Last section. All information is anonymous and used exclusively for statistical purposes.",
    age_lbl      = "Age group *",
    gender_lbl   = "Gender *",
    country_lbl  = "Country of residence *",
    edu_lbl      = "Highest educational qualification *",
    dsp_h5       = "Music streaming service usage",
    dsp_user_q   = "Are you currently subscribed to or regularly using a music streaming service? *",
    dsp_svc_lbl  = "Which service do you use most? *",
    dsp_tier_lbl = "Subscription type *",
    submit_warn  = "(\u26a0) Check your answers: once submitted they cannot be changed.",
    btn_submit   = "Submit answers",

    ty_h2      = "Thank you for participating!",
    ty_lead    = "Your answers have been successfully recorded.",
    ty_close   = "You can now close this window.",
    ty_contact = "For information about the research: "
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # FRANÇAIS
  # ══════════════════════════════════════════════════════════════════════════
  fr = list(

    decimal_sep = ",",
    per_month   = "/mois",

    audio_ch = c(
      "S\u00fbrement IA"       = "4",
      "Probablement IA"        = "3",
      "Probablement humaine"   = "2",
      "S\u00fbrement humaine"  = "1",
      "Je ne sais pas"         = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "\u00c9valu\u00e9e",
    audio_msg  = "Votre navigateur ne prend pas en charge la lecture audio.",

    lik5  = c("Tout \u00e0 fait en d\u00e9saccord","En d\u00e9saccord","Neutre",
              "D\u2019accord","Tout \u00e0 fait d\u2019accord"),
    lik5p = c("Pas du tout probable","Peu probable","Neutre","Probable","Tr\u00e8s probable"),

    freq_opts  = c("Jamais"="never","Quelques fois par mois"="monthly",
                   "Quelques fois par semaine"="weekly","Chaque jour"="daily"),
    bg_opts    = c("Aucun"="none","Passionn\u00e9(e)"="enthusiast",
                   "Amateur"="amateur","Musicien(ne) professionnel(le)"="professional"),
    fam_opts   = c("Oui"="yes","Non"="no"),
    aware_opts = c("Oui"="yes","Non"="no","Je n\u2019\u00e9tais pas s\u00fbr(e)"="unsure"),
    dsp_yn     = c("Oui"="yes","Non"="no"),

    A1 = c(
      "Aucun label IA visible (m\u00e9tadonn\u00e9es internes uniquement, inaccessibles aux utilisateurs)",
      "Label IA volontaire (visible uniquement si d\u00e9clar\u00e9 par le distributeur lors du t\u00e9l\u00e9chargement)",
      "Label IA obligatoire (garanti par la plateforme, ind\u00e9pendamment de l\u2019artiste)"
    ),
    A2 = c(
      "Musique IA non incluse dans les playlists recommand\u00e9es",
      "Musique IA dans les playlists recommand\u00e9es et g\u00e9n\u00e9ralistes",
      "Musique IA dans les playlists recommand\u00e9es + espace IA d\u00e9di\u00e9 suppl\u00e9mentaire"
    ),
    A3 = c(
      "Aucun contr\u00f4le utilisateur sur la musique IA",
      "Filtre partiel\u00a0: exclusion de la musique IA des playlists personnalis\u00e9es",
      "Filtre complet\u00a0: blocage total de la musique IA sur la plateforme"
    ),

    gaais = c(
      "Je suis int\u00e9ress\u00e9(e) \u00e0 utiliser des syst\u00e8mes d\u2019intelligence artificielle dans ma vie quotidienne.",
      "Je trouve l\u2019intelligence artificielle inqui\u00e9tante.",
      "L\u2019intelligence artificielle pourrait prendre le contr\u00f4le des personnes.",
      "Je pense que l\u2019intelligence artificielle est dangereuse.",
      "L\u2019intelligence artificielle peut avoir un impact positif sur le bien-\u00eatre des personnes.",
      "L\u2019intelligence artificielle est passionnante.",
      "Une grande partie de la soci\u00e9t\u00e9 b\u00e9n\u00e9ficiera d\u2019un avenir riche en intelligence artificielle.",
      "Je voudrais utiliser l\u2019intelligence artificielle dans mon travail.",
      "Je frissonne d\u2019inconfort en pensant aux utilisations futures de l\u2019intelligence artificielle.",
      "Des personnes comme moi souffriront si l\u2019intelligence artificielle est utilis\u00e9e de plus en plus."
    ),

    proxy = c(
      "Je peux distinguer la musique cr\u00e9\u00e9e par l\u2019intelligence artificielle de celle jou\u00e9e par des musiciens humains.",
      "Je per\u00e7ois des diff\u00e9rences de qualit\u00e9 \u00e9motionnelle entre la musique IA et la musique humaine.",
      "Je remarque quand une chanson a \u00e9t\u00e9 g\u00e9n\u00e9r\u00e9e artificiellement.",
      "Je suis pr\u00e9occup\u00e9(e) par l\u2019impact de l\u2019intelligence artificielle sur l\u2019industrie musicale.",
      "Je pr\u00e9f\u00e8re \u00e9couter de la musique cr\u00e9\u00e9e exclusivement par des musiciens humains.",
      "Je pense que la musique g\u00e9n\u00e9r\u00e9e par l\u2019IA ne peut pas \u00e9galer la musique humaine sur le plan \u00e9motionnel."
    ),

    sel_placeholder = "-- S\u00e9lectionner --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Homme"="man","Femme"="woman",
                    "Non-binaire / Troisi\u00e8me genre"="nonbinary",
                    "Pr\u00e9f\u00e8re ne pas pr\u00e9ciser"="no_answer"),
    edu_opts    = c(
      "Brevet des coll\u00e8ges"                      = "middle",
      "Baccalaur\u00e9at / Dipl\u00f4me de lyc\u00e9e" = "highschool",
      "Licence (Bac+3)"                               = "bachelor",
      "Master / Dipl\u00f4me d\u2019ing\u00e9nieur (Bac+5)" = "master",
      "Doctorat / Post-dipl\u00f4me"                  = "phd"
    ),
    country_opts = c(
      "Italie"="IT","France"="FR","Allemagne"="DE","Espagne"="ES","Portugal"="PT",
      "Royaume-Uni"="GB","Pays-Bas"="NL","Belgique"="BE","Suisse"="CH","Autriche"="AT",
      "Pologne"="PL","Roumanie"="RO","R\u00e9publique tch\u00e8que"="CZ","Su\u00e8de"="SE","Norv\u00e8ge"="NO",
      "Danemark"="DK","Finlande"="FI","Gr\u00e8ce"="GR","Hongrie"="HU","Croatie"="HR",
      "\u00c9tats-Unis"="US","Canada"="CA","Australie"="AU","Br\u00e9sil"="BR","Argentine"="AR",
      "Autre"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Autre"="other"),
    tier_opts = c("Gratuit (avec publicit\u00e9)"="free","Premium individuel"="premium_ind",
                  "Premium famille / Duo"="premium_fam","\u00c9tudiant(e)"="student","Autre"="other"),

    err_consent  = "Vous devez consentir \u00e0 participer pour continuer.",
    err_audio    = "Veuillez \u00e9valuer les 4 clips avant de continuer.",
    err_gaais    = "Veuillez r\u00e9pondre \u00e0 tous les items avant de continuer.",
    err_cbc      = "Veuillez s\u00e9lectionner une option avant de continuer.",
    err_proxy    = "Veuillez r\u00e9pondre \u00e0 tous les items avant de continuer.",
    err_demo_req = "Veuillez remplir tous les champs d\u00e9mographiques obligatoires (*).",
    err_dsp_user = "Veuillez indiquer si vous utilisez un service de streaming musical.",
    err_dsp_svc  = "Veuillez indiquer le service de streaming que vous utilisez principalement.",
    err_dsp_tier = "Veuillez indiquer votre type d\u2019abonnement.",

    intro_title    = "Pr\u00e9f\u00e9rences des consommateurs pour la gouvernance de l\u2019IA",
    intro_title2   = "dans les services de streaming musical",
    intro_subtitle = "Sondage pour m\u00e9moire de master \u2022 Universit\u00e9 de Trente",
    privacy_head   = "Avis de confidentialit\u00e9 et consentement \u00e9clair\u00e9",
    c_obj_lbl  = "Objet de la recherche\u00a0:",
    c_obj      = " Pr\u00e9f\u00e9rences des consommateurs pour diff\u00e9rentes configurations de gouvernance du contenu musical g\u00e9n\u00e9r\u00e9 par l\u2019IA dans les services de streaming num\u00e9rique.",
    c_who_lbl  = "Qui m\u00e8ne la recherche\u00a0:",
    c_who      = " Lorenzo Paravano, m\u00e9moire de master, Universit\u00e9 de Trente.",
    c_part_lbl = "Participation\u00a0:",
    c_part     = " Volontaire et anonyme. Aucune donn\u00e9e personnelle identifiable n\u2019est collect\u00e9e.",
    c_data_lbl = "Donn\u00e9es collect\u00e9es\u00a0:",
    c_data     = " R\u00e9ponses aux questions du sondage (pr\u00e9f\u00e9rences, attitudes, donn\u00e9es d\u00e9mographiques agr\u00e9g\u00e9es). Les donn\u00e9es seront pr\u00e9sent\u00e9es exclusivement sous forme agr\u00e9g\u00e9e.",
    c_time_lbl = "Dur\u00e9e estim\u00e9e\u00a0:",
    c_time     = " 10\u201315 minutes.",
    c_gdpr_lbl = "Traitement des donn\u00e9es\u00a0:",
    c_gdpr     = " Les donn\u00e9es sont trait\u00e9es conform\u00e9ment au RGPD (R\u00e8gl. UE 2016/679) exclusivement \u00e0 des fins de recherche acad\u00e9mique.",
    consent_chk = "J\u2019ai lu l\u2019avis de confidentialit\u00e9 et consens volontairement \u00e0 participer au sondage.",
    btn_start   = "Commencer \u2192",

    badge1     = "Section 1 sur 5",
    audio_h3   = "T\u00e2che de discrimination audio",
    audio_instr = tagList(
      "\u00c9coutez chacun des ", tags$strong("4 extraits musicaux"), " ci-dessous et indiquez, pour chacun, ",
      "dans quelle mesure vous pensez qu\u2019il a \u00e9t\u00e9 produit par l\u2019intelligence artificielle ou par un musicien humain. ",
      "Utilisez l\u2019\u00e9chelle \u00e0 4 points, de ", tags$em("S\u00fbrement humaine"),
      " \u00e0 ", tags$em("S\u00fbrement IA"), ". ",
      "Si vous n\u2019\u00eates pas s\u00fbr(e), s\u00e9lectionnez ", tags$em("\u201cJe ne sais pas\u201d"), "."
    ),
    btn_next = "Suivant \u2192",

    badge2      = "Section 2 sur 5",
    gaais_h3    = "Attitudes envers l\u2019Intelligence Artificielle",
    gaais_instr = "Pour chaque affirmation, indiquez votre niveau d\u2019accord.",

    badge3      = "Section 3 sur 5",
    framing_h3  = "Politiques IA dans les services de streaming musical",
    framing_ctx = "Contexte actuel",
    framing_p1  = "Les services de streaming musical (Spotify, Apple Music, Amazon Music, etc.) h\u00e9bergent un nombre croissant de titres g\u00e9n\u00e9r\u00e9s enti\u00e8rement ou partiellement par l\u2019intelligence artificielle. Sur la plupart des plateformes aujourd\u2019hui\u00a0:",
    framing_li1 = tagList(tags$strong("Aucun label visible par le consommateur"), " n\u2019existe pour identifier les titres IA."),
    framing_li2 = tagList("Les titres IA sont ", tags$strong("inclus dans les playlists recommand\u00e9es"), " aux c\u00f4t\u00e9s de la musique humaine."),
    framing_li3 = tagList(tags$strong("Aucun filtre n\u2019est disponible"), " pour exclure les titres IA."),
    sq_title    = "Configuration actuelle (statu quo \u2014 point de r\u00e9f\u00e9rence)",
    sq_li1      = tagList("Politique de label IA\u00a0: ", tags$em("Aucun label visible par le consommateur")),
    sq_li2      = tagList("Structure promotionnelle\u00a0: ", tags$em("Musique IA dans les playlists recommand\u00e9es")),
    sq_li3      = tagList("Contr\u00f4le utilisateur\u00a0: ", tags$em("Aucun filtre disponible")),
    sq_li4      = tagList("Prix de l\u2019abonnement\u00a0: ", tags$em("11,99\u00a0\u20ac/mois")),
    task_h5     = "Comment lire les choix",
    task_p1     = tagList(
      "Dans les pages suivantes, vous verrez ", tags$strong("12 situations hypoth\u00e9tiques"), ". ",
      "Chacune pr\u00e9sente ", tags$strong("3 alternatives d\u2019abonnement"), " qui diff\u00e8rent par\u00a0:"
    ),
    attr_a_lbl  = "Politique de label IA\u00a0:",
    attr_a_desc = " comment la plateforme communique quelle musique est g\u00e9n\u00e9r\u00e9e par l\u2019IA.",
    attr_b_lbl  = "Structure promotionnelle\u00a0:",
    attr_b_desc = " si et comment la musique IA est incluse dans les playlists recommand\u00e9es.",
    attr_c_lbl  = "Contr\u00f4le utilisateur\u00a0:",
    attr_c_desc = " quels outils vous avez pour filtrer ou bloquer la musique IA.",
    attr_d_lbl  = "Prix mensuel\u00a0:",
    attr_d_desc = " le co\u00fbt de l\u2019abonnement.",
    task_p2     = tagList(
      "Pour chaque situation, ", tags$strong("choisissez l\u2019alternative que vous pr\u00e9f\u00e9reriez"),
      " comme plan d\u2019abonnement. ",
      "Il n\u2019y a pas de bonnes ou de mauvaises r\u00e9ponses\u00a0: seule votre pr\u00e9f\u00e9rence personnelle compte."
    ),
    btn_start_cbc = "Commencer les choix \u2192",

    cbc_badge = "Section 3 sur 5",
    cbc_q     = "Laquelle de ces configurations d\u2019abonnement pr\u00e9f\u00e9reriez-vous\u00a0?",
    cbc_instr = tagList(
      "Les 3 alternatives diff\u00e8rent par la politique IA et le prix. ",
      "Cliquez sur la configuration que vous adopteriez r\u00e9ellement."
    ),
    cbc_opt   = "Option",
    cbc_a1lbl = "Politique de label IA",
    cbc_a2lbl = "Structure promotionnelle",
    cbc_a3lbl = "Contr\u00f4le utilisateur",

    badge4      = "Section 4 sur 5",
    proxy_h3    = "Exp\u00e9riences musicales et perception de l\u2019IA",
    proxy_instr = "Indiquez votre niveau d\u2019accord avec chaque affirmation.",
    behav_h5    = "Habitudes d\u2019\u00e9coute et familiarit\u00e9 avec l\u2019IA",
    freq_q      = "\u00c0 quelle fr\u00e9quence \u00e9coutez-vous de la musique en streaming\u00a0?",
    bg_q        = "Comment d\u00e9cririez-vous votre rapport \u00e0 la musique\u00a0?",
    fam_q       = "Avez-vous d\u00e9j\u00e0 utilis\u00e9 des outils d\u2019IA g\u00e9n\u00e9rative (p.\u00a0ex. ChatGPT, Suno, Midjourney)\u00a0?",
    aware_q     = "Avant ce sondage, saviez-vous que votre service de streaming inclut des titres g\u00e9n\u00e9r\u00e9s par l\u2019IA\u00a0?",
    churn_h5    = "Intention de r\u00e9siliation",
    churn_q     = tagList(
      "En supposant que votre service de streaming actuel n\u2019apporte ",
      tags$strong("aucune modification"),
      " \u00e0 ses politiques sur la musique IA au cours des 12 prochains mois, dans quelle mesure seriez-vous enclin(e) \u00e0 ",
      "r\u00e9silier ou changer votre abonnement\u00a0?"
    ),

    badge5       = "Section 5 sur 5",
    demo_h3      = "Donn\u00e9es d\u00e9mographiques et utilisation des services",
    demo_instr   = "Derni\u00e8re section. Toutes les informations sont anonymes et utilis\u00e9es exclusivement \u00e0 des fins statistiques.",
    age_lbl      = "Tranche d\u2019\u00e2ge *",
    gender_lbl   = "Genre *",
    country_lbl  = "Pays de r\u00e9sidence *",
    edu_lbl      = "Dipl\u00f4me le plus \u00e9lev\u00e9 obtenu *",
    dsp_h5       = "Utilisation des services de streaming musical",
    dsp_user_q   = "\u00cates-vous actuellement abonn\u00e9(e) \u00e0 ou utilisez-vous r\u00e9guli\u00e8rement un service de streaming musical\u00a0? *",
    dsp_svc_lbl  = "Quel service utilisez-vous principalement\u00a0? *",
    dsp_tier_lbl = "Type d\u2019abonnement *",
    submit_warn  = "(\u26a0) V\u00e9rifiez vos r\u00e9ponses\u00a0: une fois soumises, elles ne pourront plus \u00eatre modifi\u00e9es.",
    btn_submit   = "Soumettre les r\u00e9ponses",

    ty_h2      = "Merci de votre participation\u00a0!",
    ty_lead    = "Vos r\u00e9ponses ont \u00e9t\u00e9 enregistr\u00e9es avec succ\u00e8s.",
    ty_close   = "Vous pouvez maintenant fermer cette fen\u00eatre.",
    ty_contact = "Pour des informations sur la recherche\u00a0: "
  )
)
