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
    audio_ch = c(
      "Sicuramente AI"      = "4",
      "Probabilmente AI"    = "3",
      "Probabilmente umana" = "2",
      "Sicuramente umana"   = "1",
      "Non so"              = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Valutata",
    audio_msg  = "Il tuo browser non supporta la riproduzione audio.",

    # ── Likert scales ──────────────────────────────────────────────────────
    lik5  = c("Fortemente in disaccordo", "In disaccordo", "Neutrale",
              "D'accordo", "Fortemente d'accordo"),
    lik5p = c("Per nulla probabile", "Poco probabile", "Neutrale",
              "Probabile", "Molto probabile"),
    lik5b = c("Per nulla", "Poco", "Abbastanza", "Molto", "Moltissimo"),

    # ── Behavioural question options ───────────────────────────────────────
    freq_opts  = c("Mai"="never", "Qualche volta al mese"="monthly",
                   "Qualche volta a settimana"="weekly", "Ogni giorno"="daily"),
    aware_opts = c("Si"="yes", "No"="no", "Non ero sicuro/a"="unsure"),
    dsp_yn     = c("Si"="yes", "No"="no"),

    # ── CBC attribute levels ───────────────────────────────────────────────
    A1 = c(
      "Nessuna label AI visibile (solo metadata interni, non accessibili agli utenti)",
      "Label AI volontaria (visibile solo se dichiarata dal distributore all'upload)",
      "Label AI obbligatoria (garantita dalla piattaforma, indipendente dall'artista)"
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
      "Trovo l'intelligenza artificiale inquietante.",
      "L'intelligenza artificiale potrebbe prendere il controllo delle persone.",
      "Penso che l'intelligenza artificiale sia pericolosa.",
      "L'intelligenza artificiale puo avere un impatto positivo sul benessere delle persone.",
      "L'intelligenza artificiale e entusiasmante.",
      "Gran parte della societa beneficiera di un futuro ricco di intelligenza artificiale.",
      "Vorrei utilizzare l'intelligenza artificiale nel mio lavoro.",
      "Rabbrividisco di disagio quando penso ai futuri utilizzi dell'intelligenza artificiale.",
      "Persone come me soffriranno se l'intelligenza artificiale verra utilizzata sempre di piu."
    ),

    # ── Proxy item texts (P1–P6) ───────────────────────────────────────────
    proxy = c(
      "Quando ascolto musica in streaming, seleziono la qualita audio piu alta disponibile.",
      "Riascolto frequentemente gli stessi brani per cogliere dettagli sonori che non avevo notato al primo ascolto.",
      "Di solito ascolto un brano fino alla fine prima di decidere se mi piace, anche quando non mi convince subito.",
      "Uso spesso la funzione di ricerca per trovare artisti o brani specifici, piuttosto che affidarmi alle raccomandazioni della piattaforma.",
      "Preferisco che la musica che ascolto sia stata selezionata da una persona piuttosto che da un algoritmo (es. playlist editoriali rispetto a Discover Weekly o Daily Mix).",
      "Se fossi certo/a che un artista produce musica generata interamente dall'AI, lo bloccherei sulla mia piattaforma di streaming."
    ),

    # ── Demographic option vectors ─────────────────────────────────────────
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
    tier_opts = c("Gratuito (con pubblicita)"="free",
                  "Premium individuale"="premium_ind",
                  "Premium famiglia / Duo"="premium_fam",
                  "Studente"="student","Altro"="other"),

    # ── Error messages ─────────────────────────────────────────────────────
    err_consent  = "Devi acconsentire alla partecipazione per continuare.",
    err_audio    = "Valuta tutte e 4 le clip prima di procedere.",
    err_gaais    = "Rispondi a tutti gli item prima di procedere.",
    err_cbc      = "Seleziona un'opzione prima di procedere.",
    err_proxy    = "Rispondi a tutti gli item prima di procedere.",
    err_demo_req = "Compila tutti i campi demografici obbligatori (*).",
    err_dsp_user = "Indica se utilizzi un servizio di streaming musicale.",
    err_dsp_svc  = "Indica il servizio di streaming che utilizzi principalmente.",
    err_dsp_tier = "Indica il tipo di abbonamento.",

    # ── Page strings ───────────────────────────────────────────────────────

    # Intro
    intro_title    = "Preferenze dei consumatori per la governance dell'AI",
    intro_title2   = "nei servizi musicali in streaming",
    intro_subtitle = "Sondaggio per tesi magistrale - Universita degli Studi di Trento",
    privacy_head   = "Informativa sulla privacy e consenso informato",
    c_obj_lbl  = "Oggetto della ricerca:",
    c_obj      = " Preferenze dei consumatori rispetto a diverse configurazioni di governance del contenuto musicale generato dall'intelligenza artificiale nei servizi di streaming digitale.",
    c_who_lbl  = "Chi conduce la ricerca:",
    c_who      = " Lorenzo Paravano, tesi magistrale, Universita degli Studi di Trento.",
    c_part_lbl = "Partecipazione:",
    c_part     = " Volontaria e anonima. Nessun dato identificativo personale e raccolto.",
    c_data_lbl = "Dati raccolti:",
    c_data     = " Risposte alle domande del sondaggio (preferenze, atteggiamenti, dati demografici aggregati). I dati saranno presentati esclusivamente in forma aggregata.",
    c_time_lbl = "Durata stimata:",
    c_time     = " 10-15 minuti.",
    c_gdpr_lbl = "Trattamento dei dati:",
    c_gdpr     = " I dati sono trattati in conformita al GDPR (Reg. UE 2016/679) esclusivamente per finalita di ricerca accademica.",
    consent_chk = "Ho letto l'informativa e acconsento volontariamente a partecipare al sondaggio.",
    btn_start   = "Inizia →",

    # Audio
    badge1      = "Sezione 1 di 5",
    audio_h3    = "Task di Discriminazione Audio",
    audio_instr = tagList(
      "Ascolta ciascuna delle ", tags$strong("4 clip musicali"), " qui sotto e indica, per ognuna, ",
      "quanto pensi che sia stata prodotta dall'intelligenza artificiale o da un musicista umano. ",
      "Usa la scala a 4 punti, da ", tags$em("Sicuramente umana"), " a ", tags$em("Sicuramente AI"), ". ",
      "Se non sei sicuro/a, seleziona ", tags$em("“Non so”"), "."
    ),
    btn_next = "Avanti →",

    # GAAIS
    badge2      = "Sezione 2 di 5",
    gaais_h3    = "Atteggiamenti verso l'Intelligenza Artificiale",
    gaais_instr = "Per ciascuna affermazione, indica il tuo grado di accordo.",

    # Framing
    badge3      = "Sezione 3 di 5",
    framing_h3  = "Politiche AI nei servizi di streaming musicale",
    framing_ctx = "Contesto attuale",
    framing_p1  = "I servizi di streaming musicale (Spotify, Apple Music, Amazon Music, ecc.) ospitano una quantita crescente di tracce generate interamente o parzialmente dall'intelligenza artificiale. Nella maggior parte delle piattaforme oggi:",
    framing_li1 = tagList(tags$strong("Non esiste alcuna label"), " consumer-facing che identifichi le tracce AI."),
    framing_li2 = tagList("Le tracce AI vengono ", tags$strong("incluse nelle playlist raccomandate"), " accanto alla musica umana."),
    framing_li3 = tagList(tags$strong("Non e disponibile alcun filtro"), " per escludere le tracce AI."),
    sq_title    = "Configurazione attuale (status quo — punto di riferimento)",
    sq_li1      = tagList("Policy labeling AI: ", tags$em("Nessuna label consumer-facing")),
    sq_li2      = tagList("Struttura promozionale: ", tags$em("Musica AI nelle playlist raccomandate")),
    sq_li3      = tagList("Controllo utente: ", tags$em("Nessun filtro disponibile")),
    sq_li4      = tagList("Prezzo abbonamento: ", tags$em("€11,99/mese")),
    task_h5     = "Come leggere le scelte",
    task_p1     = tagList(
      "Nelle pagine successive vedrai ", tags$strong("12 situazioni ipotetiche"), ". ",
      "In ciascuna sono presentate ", tags$strong("3 alternative di abbonamento"), " che differiscono per:"
    ),
    attr_a_lbl  = "Policy di labeling AI:",
    attr_a_desc = " come la piattaforma comunica quale musica e generata dall'AI.",
    attr_b_lbl  = "Struttura promozionale:",
    attr_b_desc = " se e come la musica AI e inclusa nelle playlist raccomandate.",
    attr_c_lbl  = "Controllo utente:",
    attr_c_desc = " quali strumenti hai per filtrare o bloccare la musica AI.",
    attr_d_lbl  = "Prezzo mensile:",
    attr_d_desc = " il costo dell'abbonamento.",
    task_p2     = tagList(
      "Per ciascuna situazione, ", tags$strong("scegli l'alternativa che preferiresti"),
      " come tuo piano di abbonamento. ",
      "Non esistono risposte giuste o sbagliate: conta esclusivamente la tua preferenza personale."
    ),
    btn_start_cbc = "Inizia le scelte →",

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

    # Proxy / Section 4
    badge4      = "Sezione 4 di 5",
    proxy_h3    = "Esperienze musicali e percezione dell'AI",
    proxy_instr = "Indica il tuo grado di accordo con ciascuna affermazione.",
    behav_h5    = "Abitudini di ascolto",
    freq_q      = "Con quale frequenza ascolti musica in streaming?",
    aware_q     = "Prima di questo sondaggio, sapevi che il tuo servizio di streaming include tracce generate dall'AI?",
    churn_h5    = "Intenzione di abbandono",
    churn_q     = tagList(
      "Se il servizio di streaming che utilizzi non introducesse alcuna ",
      tags$strong("politica di trasparenza"),
      " sulla musica generata dall'AI nei prossimi 12 mesi, quanto saresti propenso/a a cancellare o cambiare abbonamento?"
    ),

    # Demographics
    badge5       = "Sezione 5 di 5",
    demo_h3      = "Dati demografici e utilizzo dei servizi",
    demo_instr   = "Ultima sezione. Tutte le informazioni sono anonime e usate esclusivamente a fini statistici.",
    age_lbl      = "Fascia d'eta *",
    gender_lbl   = "Genere *",
    country_lbl  = "Paese di residenza *",
    edu_lbl      = "Titolo di studio piu elevato conseguito *",
    dsp_h5       = "Utilizzo dei servizi di streaming musicale",
    dsp_user_q   = "Sei attualmente abbonato/a o utilizzi regolarmente un servizio di streaming musicale? *",
    dsp_svc_lbl  = "Quale servizio utilizzi principalmente? *",
    dsp_tier_lbl = "Tipo di abbonamento *",
    submit_warn  = "(⚠) Controlla le tue risposte: dopo l'invio non sara possibile modificarle.",
    btn_submit   = "Invia le risposte",

    # Thank you
    ty_h2      = "Grazie per la tua partecipazione!",
    ty_lead    = "Le tue risposte sono state registrate con successo.",
    ty_close   = "Puoi ora chiudere questa finestra.",
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
      "Don't know"       = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Rated",
    audio_msg  = "Your browser does not support audio playback.",

    lik5  = c("Strongly disagree","Disagree","Neutral","Agree","Strongly agree"),
    lik5p = c("Not at all likely","Unlikely","Neutral","Likely","Very likely"),
    lik5b = c("Not at all","A little","Somewhat","Very","Extremely"),

    freq_opts  = c("Never"="never","A few times a month"="monthly",
                   "A few times a week"="weekly","Every day"="daily"),
    aware_opts = c("Yes"="yes","No"="no","I wasn't sure"="unsure"),
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

    gaais = c(
      "I am interested in using artificial intelligence systems in my everyday life.",
      "I find artificial intelligence unsettling.",
      "Artificial intelligence can take control of people.",
      "I think artificial intelligence is dangerous.",
      "Artificial intelligence can have a positive impact on people's wellbeing.",
      "Artificial intelligence is exciting.",
      "Much of society will benefit from a future full of artificial intelligence.",
      "I would like to use artificial intelligence in my work.",
      "I shudder with discomfort when I think about future uses of artificial intelligence.",
      "People like me will suffer if artificial intelligence is used more and more."
    ),

    # Proxy items P1–P6
    proxy = c(
      "When I listen to streaming music, I select the highest available audio quality.",
      "I frequently re-listen to the same tracks to catch sonic details I hadn't noticed before.",
      "I usually listen to a track all the way through before deciding if I like it, even when it doesn't immediately appeal to me.",
      "I often use the search function to find specific artists or tracks, rather than relying on platform recommendations.",
      "I prefer that the music I listen to has been selected by a person rather than an algorithm (e.g. editorial playlists over Discover Weekly or Daily Mix).",
      "If I were certain that an artist produces music generated entirely by AI, I would block them on my streaming platform."
    ),

    sel_placeholder = "-- Select --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Man"="man","Woman"="woman",
                    "Non-binary / Third gender"="nonbinary",
                    "Prefer not to say"="no_answer"),
    edu_opts    = c(
      "Middle school diploma" = "middle",
      "High school diploma"   = "highschool",
      "Bachelor's degree"     = "bachelor",
      "Master's degree"       = "master",
      "PhD / Post-graduate"   = "phd"
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
    intro_subtitle = "Master's thesis survey • University of Trento",
    privacy_head   = "Privacy notice and informed consent",
    c_obj_lbl  = "Research subject:",
    c_obj      = " Consumer preferences for different AI-generated music content governance configurations in digital streaming services.",
    c_who_lbl  = "Research conducted by:",
    c_who      = " Lorenzo Paravano, Master's thesis, University of Trento.",
    c_part_lbl = "Participation:",
    c_part     = " Voluntary and anonymous. No personal identifying data is collected.",
    c_data_lbl = "Data collected:",
    c_data     = " Survey responses (preferences, attitudes, aggregated demographic data). Data will be presented exclusively in aggregated form.",
    c_time_lbl = "Estimated duration:",
    c_time     = " 10–15 minutes.",
    c_gdpr_lbl = "Data processing:",
    c_gdpr     = " Data are processed in compliance with the GDPR (EU Reg. 2016/679) exclusively for academic research purposes.",
    consent_chk = "I have read the privacy notice and voluntarily consent to participate in the survey.",
    btn_start   = "Start →",

    badge1      = "Section 1 of 5",
    audio_h3    = "Audio Discrimination Task",
    audio_instr = tagList(
      "Listen to each of the ", tags$strong("4 music clips"), " below and indicate, for each one, ",
      "how much you think it was produced by artificial intelligence or by a human musician. ",
      "Use the 4-point scale, from ", tags$em("Definitely human"), " to ", tags$em("Definitely AI"), ". ",
      "If you are unsure, select ", tags$em("“Don’t know”"), "."
    ),
    btn_next = "Next →",

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
    sq_title    = "Current configuration (status quo — reference point)",
    sq_li1      = tagList("AI labelling policy: ", tags$em("No consumer-facing label")),
    sq_li2      = tagList("Promotional structure: ", tags$em("AI music in recommended playlists")),
    sq_li3      = tagList("User control: ", tags$em("No filter available")),
    sq_li4      = tagList("Subscription price: ", tags$em("€11.99/month")),
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
    btn_start_cbc = "Start choices →",

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
    behav_h5    = "Listening habits",
    freq_q      = "How often do you listen to streaming music?",
    aware_q     = "Before this survey, did you know that your streaming service includes AI-generated tracks?",
    churn_h5    = "Switching intention",
    churn_q     = tagList(
      "If the streaming service you use were to introduce ",
      tags$strong("no transparency policy"),
      " on AI-generated music over the next 12 months, how likely would you be to cancel or switch your subscription?"
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
    submit_warn  = "(⚠) Check your answers: once submitted they cannot be changed.",
    btn_submit   = "Submit answers",

    ty_h2      = "Thank you for participating!",
    ty_lead    = "Your answers have been successfully recorded.",
    ty_close   = "You can now close this window.",
    ty_contact = "For information about the research: "
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # FRANCAIS
  # ══════════════════════════════════════════════════════════════════════════
  fr = list(

    decimal_sep = ",",
    per_month   = "/mois",

    audio_ch = c(
      "Sûrement IA"        = "4",
      "Probablement IA"         = "3",
      "Probablement humaine"    = "2",
      "Sûrement humaine"   = "1",
      "Je ne sais pas"          = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Évaluée",
    audio_msg  = "Votre navigateur ne prend pas en charge la lecture audio.",

    lik5  = c("Tout à fait en désaccord","En désaccord","Neutre",
              "D’accord","Tout à fait d’accord"),
    lik5p = c("Pas du tout probable","Peu probable","Neutre","Probable","Très probable"),
    lik5b = c("Pas du tout","Un peu","Assez","Beaucoup","Extrêmement"),

    freq_opts  = c("Jamais"="never","Quelques fois par mois"="monthly",
                   "Quelques fois par semaine"="weekly","Chaque jour"="daily"),
    aware_opts = c("Oui"="yes","Non"="no","Je n’étais pas sûr(e)"="unsure"),
    dsp_yn     = c("Oui"="yes","Non"="no"),

    A1 = c(
      "Aucun label IA visible (métadonnées internes uniquement, inaccessibles aux utilisateurs)",
      "Label IA volontaire (visible uniquement si déclaré par le distributeur lors du téléchargement)",
      "Label IA obligatoire (garanti par la plateforme, indépendamment de l’artiste)"
    ),
    A2 = c(
      "Musique IA non incluse dans les playlists recommandées",
      "Musique IA dans les playlists recommandées et généralistes",
      "Musique IA dans les playlists recommandées + espace IA dédié supplémentaire"
    ),
    A3 = c(
      "Aucun contrôle utilisateur sur la musique IA",
      "Filtre partiel : exclusion de la musique IA des playlists personnalisées",
      "Filtre complet : blocage total de la musique IA sur la plateforme"
    ),

    gaais = c(
      "Je suis intéressé(e) à utiliser des systèmes d’intelligence artificielle dans ma vie quotidienne.",
      "Je trouve l’intelligence artificielle inquétante.",
      "L’intelligence artificielle pourrait prendre le contrôle des personnes.",
      "Je pense que l’intelligence artificielle est dangereuse.",
      "L’intelligence artificielle peut avoir un impact positif sur le bien-être des personnes.",
      "L’intelligence artificielle est passionnante.",
      "Une grande partie de la société bénéficiera d’un avenir riche en intelligence artificielle.",
      "Je voudrais utiliser l’intelligence artificielle dans mon travail.",
      "Je frissonne d’inconfort en pensant aux utilisations futures de l’intelligence artificielle.",
      "Des personnes comme moi souffriront si l’intelligence artificielle est utilisée de plus en plus."
    ),

    # Proxy items P1-P6
    proxy = c(
      "Quand j’écoute de la musique en streaming, je sélectionne la qualité audio la plus élevée disponible.",
      "Je réécoute fréquemment les mêmes titres pour saisir des détails sonores que je n’avais pas remarqués à la première écoute.",
      "J’écoute généralement un titre jusqu’à la fin avant de décider si je l’aime, même quand il ne me convainc pas immédiatement.",
      "J’utilise souvent la fonction de recherche pour trouver des artistes ou des titres spécifiques, plutôt que de me fier aux recommandations de la plateforme.",
      "Je préfère que la musique que j’écoute ait été sélectionnée par une personne plutôt que par un algorithme (p. ex. playlists éditoriales plutôt que Discover Weekly ou Daily Mix).",
      "Si j’étais certain(e) qu’un artiste produit de la musique générée entièrement par l’IA, je le bloquerais sur ma plateforme de streaming."
    ),

    sel_placeholder = "-- Sélectionner --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Homme"="man","Femme"="woman",
                    "Non-binaire / Troisième genre"="nonbinary",
                    "Préfère ne pas préciser"="no_answer"),
    edu_opts    = c(
      "Brevet des collèges"                         = "middle",
      "Baccalauréat / Diplôme de lycée"   = "highschool",
      "Licence (Bac+3)"                                  = "bachelor",
      "Master / Diplôme d’ingénieur (Bac+5)" = "master",
      "Doctorat / Post-diplôme"                     = "phd"
    ),
    country_opts = c(
      "Italie"="IT","France"="FR","Allemagne"="DE","Espagne"="ES","Portugal"="PT",
      "Royaume-Uni"="GB","Pays-Bas"="NL","Belgique"="BE","Suisse"="CH","Autriche"="AT",
      "Pologne"="PL","Roumanie"="RO","République tchèque"="CZ","Suède"="SE","Norvège"="NO",
      "Danemark"="DK","Finlande"="FI","Grèce"="GR","Hongrie"="HU","Croatie"="HR",
      "États-Unis"="US","Canada"="CA","Australie"="AU","Brésil"="BR","Argentine"="AR",
      "Autre"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Autre"="other"),
    tier_opts = c("Gratuit (avec publicité)"="free","Premium individuel"="premium_ind",
                  "Premium famille / Duo"="premium_fam","Étudiant(e)"="student","Autre"="other"),

    err_consent  = "Vous devez consentir à participer pour continuer.",
    err_audio    = "Veuillez évaluer les 4 clips avant de continuer.",
    err_gaais    = "Veuillez répondre à tous les items avant de continuer.",
    err_cbc      = "Veuillez sélectionner une option avant de continuer.",
    err_proxy    = "Veuillez répondre à tous les items avant de continuer.",
    err_demo_req = "Veuillez remplir tous les champs démographiques obligatoires (*).",
    err_dsp_user = "Veuillez indiquer si vous utilisez un service de streaming musical.",
    err_dsp_svc  = "Veuillez indiquer le service de streaming que vous utilisez principalement.",
    err_dsp_tier = "Veuillez indiquer votre type d’abonnement.",

    intro_title    = "Préférences des consommateurs pour la gouvernance de l’IA",
    intro_title2   = "dans les services de streaming musical",
    intro_subtitle = "Sondage pour mémoire de master • Université de Trente",
    privacy_head   = "Avis de confidentialité et consentement éclairé",
    c_obj_lbl  = "Objet de la recherche :",
    c_obj      = " Préférences des consommateurs pour différentes configurations de gouvernance du contenu musical généré par l’IA dans les services de streaming numérique.",
    c_who_lbl  = "Qui mène la recherche :",
    c_who      = " Lorenzo Paravano, mémoire de master, Université de Trente.",
    c_part_lbl = "Participation :",
    c_part     = " Volontaire et anonyme. Aucune donnée personnelle identifiable n’est collectée.",
    c_data_lbl = "Données collectées :",
    c_data     = " Réponses aux questions du sondage (préférences, attitudes, données démographiques agrégées). Les données seront présentées exclusivement sous forme agrégée.",
    c_time_lbl = "Durée estimée :",
    c_time     = " 10–15 minutes.",
    c_gdpr_lbl = "Traitement des données :",
    c_gdpr     = " Les données sont traitées conformément au RGPD (Règl. UE 2016/679) exclusivement à des fins de recherche académique.",
    consent_chk = "J’ai lu l’avis de confidentialité et consens volontairement à participer au sondage.",
    btn_start   = "Commencer →",

    badge1      = "Section 1 sur 5",
    audio_h3    = "Tâche de discrimination audio",
    audio_instr = tagList(
      "Écoutez chacun des ", tags$strong("4 extraits musicaux"), " ci-dessous et indiquez, pour chacun, ",
      "dans quelle mesure vous pensez qu’il a été produit par l’intelligence artificielle ou par un musicien humain. ",
      "Utilisez l’échelle à 4 points, de ", tags$em("Sûrement humaine"),
      " à ", tags$em("Sûrement IA"), ". ",
      "Si vous n’êtes pas sûr(e), sélectionnez ", tags$em("“Je ne sais pas”"), "."
    ),
    btn_next = "Suivant →",

    badge2      = "Section 2 sur 5",
    gaais_h3    = "Attitudes envers l’Intelligence Artificielle",
    gaais_instr = "Pour chaque affirmation, indiquez votre niveau d’accord.",

    badge3      = "Section 3 sur 5",
    framing_h3  = "Politiques IA dans les services de streaming musical",
    framing_ctx = "Contexte actuel",
    framing_p1  = "Les services de streaming musical (Spotify, Apple Music, Amazon Music, etc.) hébergent un nombre croissant de titres générés entièrement ou partiellement par l’intelligence artificielle. Sur la plupart des plateformes aujourd’hui :",
    framing_li1 = tagList(tags$strong("Aucun label visible par le consommateur"), " n’existe pour identifier les titres IA."),
    framing_li2 = tagList("Les titres IA sont ", tags$strong("inclus dans les playlists recommandées"), " aux côtés de la musique humaine."),
    framing_li3 = tagList(tags$strong("Aucun filtre n’est disponible"), " pour exclure les titres IA."),
    sq_title    = "Configuration actuelle (statu quo — point de référence)",
    sq_li1      = tagList("Politique de label IA : ", tags$em("Aucun label visible par le consommateur")),
    sq_li2      = tagList("Structure promotionnelle : ", tags$em("Musique IA dans les playlists recommandées")),
    sq_li3      = tagList("Contrôle utilisateur : ", tags$em("Aucun filtre disponible")),
    sq_li4      = tagList("Prix de l’abonnement : ", tags$em("11,99 €/mois")),
    task_h5     = "Comment lire les choix",
    task_p1     = tagList(
      "Dans les pages suivantes, vous verrez ", tags$strong("12 situations hypothétiques"), ". ",
      "Chacune présente ", tags$strong("3 alternatives d’abonnement"), " qui diffèrent par :"
    ),
    attr_a_lbl  = "Politique de label IA :",
    attr_a_desc = " comment la plateforme communique quelle musique est générée par l’IA.",
    attr_b_lbl  = "Structure promotionnelle :",
    attr_b_desc = " si et comment la musique IA est incluse dans les playlists recommandées.",
    attr_c_lbl  = "Contrôle utilisateur :",
    attr_c_desc = " quels outils vous avez pour filtrer ou bloquer la musique IA.",
    attr_d_lbl  = "Prix mensuel :",
    attr_d_desc = " le coût de l’abonnement.",
    task_p2     = tagList(
      "Pour chaque situation, ", tags$strong("choisissez l’alternative que vous préféreriez"),
      " comme plan d’abonnement. ",
      "Il n’y a pas de bonnes ou de mauvaises réponses : seule votre préférence personnelle compte."
    ),
    btn_start_cbc = "Commencer les choix →",

    cbc_badge = "Section 3 sur 5",
    cbc_q     = "Laquelle de ces configurations d’abonnement préféreriez-vous ?",
    cbc_instr = tagList(
      "Les 3 alternatives diffèrent par la politique IA et le prix. ",
      "Cliquez sur la configuration que vous adopteriez réellement."
    ),
    cbc_opt   = "Option",
    cbc_a1lbl = "Politique de label IA",
    cbc_a2lbl = "Structure promotionnelle",
    cbc_a3lbl = "Contrôle utilisateur",

    badge4      = "Section 4 sur 5",
    proxy_h3    = "Expériences musicales et perception de l’IA",
    proxy_instr = "Indiquez votre niveau d’accord avec chaque affirmation.",
    behav_h5    = "Habitudes d’écoute",
    freq_q      = "À quelle fréquence écoutez-vous de la musique en streaming ?",
    aware_q     = "Avant ce sondage, saviez-vous que votre service de streaming inclut des titres générés par l’IA ?",
    churn_h5    = "Intention de résiliation",
    churn_q     = tagList(
      "Si le service de streaming que vous utilisez n’introduisait aucune ",
      tags$strong("politique de transparence"),
      " sur la musique générée par l’IA au cours des 12 prochains mois, dans quelle mesure seriez-vous enclin(e) à résilier ou changer votre abonnement ?"
    ),

    badge5       = "Section 5 sur 5",
    demo_h3      = "Données démographiques et utilisation des services",
    demo_instr   = "Dernière section. Toutes les informations sont anonymes et utilisées exclusivement à des fins statistiques.",
    age_lbl      = "Tranche d’âge *",
    gender_lbl   = "Genre *",
    country_lbl  = "Pays de résidence *",
    edu_lbl      = "Diplôme le plus élevé obtenu *",
    dsp_h5       = "Utilisation des services de streaming musical",
    dsp_user_q   = "Êtes-vous actuellement abonné(e) à ou utilisez-vous régulièrement un service de streaming musical ? *",
    dsp_svc_lbl  = "Quel service utilisez-vous principalement ? *",
    dsp_tier_lbl = "Type d’abonnement *",
    submit_warn  = "(⚠) Vérifiez vos réponses : une fois soumises, elles ne pourront plus être modifiées.",
    btn_submit   = "Soumettre les réponses",

    ty_h2      = "Merci de votre participation !",
    ty_lead    = "Vos réponses ont été enregistrées avec succès.",
    ty_close   = "Vous pouvez maintenant fermer cette fenêtre.",
    ty_contact = "Pour des informations sur la recherche : "
  )
)
