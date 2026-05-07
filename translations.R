# ── translations.R ────────────────────────────────────────────────────────────
# Single source of truth for all survey text (IT / EN / FR).
# Sourced from global.R after library(shiny) so tags$* functions are available.
# ─────────────────────────────────────────────────────────────────────────────

TR <- list(

  # ══════════════════════════════════════════════════════════════════════════
  # ITALIANO
  # ══════════════════════════════════════════════════════════════════════════
  it = list(

    decimal_sep = ",",
    per_month   = "/mese",

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

    lik5  = c("Fortemente in disaccordo","In disaccordo","Neutrale",
              "D'accordo","Fortemente d'accordo"),
    lik5p = c("Per nulla probabile","Poco probabile","Neutrale",
              "Probabile","Molto probabile"),
    freq_opts  = c("Mai"="never","Qualche volta al mese"="monthly",
                   "Qualche volta a settimana"="weekly","Ogni giorno"="daily"),
    aware_opts = c("Sì"="yes","No"="no","Non ero sicuro/a"="unsure"),
    dsp_yn     = c("Sì"="yes","No"="no"),

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

    gaais = c(
      "Sono interessato/a a utilizzare sistemi di intelligenza artificiale nella mia vita quotidiana.",
      "Trovo l'intelligenza artificiale inquietante.",
      "L'intelligenza artificiale potrebbe prendere il controllo delle persone.",
      "Penso che l'intelligenza artificiale sia pericolosa.",
      "L'intelligenza artificiale può avere un impatto positivo sul benessere delle persone.",
      "L'intelligenza artificiale è entusiasmante.",
      "Gran parte della società beneficerà di un futuro ricco di intelligenza artificiale.",
      "Vorrei utilizzare l'intelligenza artificiale nel mio lavoro.",
      "Rabbrividisco di disagio quando penso ai futuri utilizzi dell'intelligenza artificiale.",
      "Persone come me soffriranno se l'intelligenza artificiale verrà utilizzata sempre di più."
    ),

    proxy = c(
      "Quando ascolto musica in streaming, seleziono la qualità audio più alta disponibile.",
      "Riascolto frequentemente gli stessi brani per cogliere dettagli sonori che non avevo notato al primo ascolto.",
      "Di solito ascolto un brano fino alla fine prima di decidere se mi piace, anche quando non mi convince subito.",
      "Uso spesso la funzione di ricerca per trovare artisti o brani specifici, piuttosto che affidarmi alle raccomandazioni della piattaforma.",
      "Preferisco che la musica che ascolto sia stata selezionata da una persona piuttosto che da un algoritmo (es. playlist editoriali rispetto a Discover Weekly o Daily Mix).",
      "Se fossi certo/a che un artista produce musica generata interamente dall'AI, lo bloccherei sulla mia piattaforma di streaming."
    ),

    sel_placeholder = "-- Seleziona --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Uomo"="man","Donna"="woman",
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

    err_consent  = "È necessario acconsentire alla partecipazione per continuare.",
    err_audio    = "Valuti tutte e 4 le clip prima di procedere.",
    err_gaais    = "Risponda a tutti gli item prima di procedere.",
    err_cbc      = "Selezioni un'opzione prima di procedere.",
    err_proxy    = "Risponda a tutti gli item prima di procedere.",
    err_demo_req = "Compili tutti i campi demografici obbligatori (*).",
    err_dsp_user = "Indichi se utilizza un servizio di streaming musicale.",
    err_dsp_svc  = "Indichi il servizio di streaming che utilizza principalmente.",
    err_dsp_tier = "Indichi il tipo di abbonamento.",

    intro_title    = "Musica generata dall'AI nei servizi di streaming",
    intro_title2   = "Sondaggio sulle preferenze dei consumatori",
    privacy_head   = "Informativa sulla privacy e consenso informato",

    intro_salute = "Gentile partecipante,",
    intro_body   = "sono uno studente del Corso di Laurea Magistrale in Management dell'Università degli Studi di Trento. La invito a partecipare a questo sondaggio, sviluppato nell'ambito della mia tesi magistrale, che ha l'obiettivo di analizzare le preferenze dei consumatori riguardo alle politiche adottate dalle piattaforme di streaming musicale in materia di musica generata dall'intelligenza artificiale.",

    survey_warn  = "Attenzione: se possibile, non aggiorni la pagina e non utilizzi il tasto 'Indietro' del browser durante la compilazione. Una volta premuto il tasto Avanti in ogni sezione, le risposte non potranno essere modificate.",

    what_asked_h = "Cosa Le verrà chiesto?",
    what_asked   = tags$ol(
      tags$li("Svolgere un breve task di ascolto per valutare clip musicali"),
      tags$li("Indicare le Sue opinioni generali sull'intelligenza artificiale"),
      tags$li("Effettuare scelte tra diverse configurazioni di abbonamento a un servizio di streaming"),
      tags$li("Rispondere a domande sulle Sue abitudini di ascolto e sulla percezione della musica AI"),
      tags$li("Fornire alcune informazioni demografiche")
    ),

    c_part_lbl = "Partecipazione:",
    c_part     = " Volontaria. È libero/a di ritirarsi in qualsiasi momento senza conseguenze.",
    c_data_lbl = "Dati raccolti:",
    c_data     = " Le risposte sono anonime e non riconducibili alla Sua persona. I dati saranno utilizzati esclusivamente per finalita di ricerca accademica e presentati in forma aggregata.",
    c_time_lbl = "Durata stimata:",
    c_time     = " 10-15 minuti.",

    contact_h    = "Per informazioni:",
    contact_info = tagList(
      tags$p("Lorenzo Paravano - lorenzo.paravano@gmail.com"),
      tags$p("Prof. Diego Giuliani - [email da aggiungere]")
    ),

    consent_chk = "Ho letto l'informativa e acconsento volontariamente a partecipare al sondaggio.",
    btn_start   = "Inizia",

    badge1        = "Sezione 1 di 5",
    audio_h3      = "Task di Discriminazione Audio",
    audio_hint      = "\U0001F3A7 Consigliamo cuffiette o un ambiente silenzioso",
    audio_context_q = "Cos'è la musica generata dall'AI?",
    audio_instr   = tagList(
      "Le presentiamo ", tags$strong("4 brevi clip musicali"),
      ". Per ciascuna traccia, La preghiamo di indicare in che misura ritiene che essa sia stata prodotta tramite l'utilizzo di intelligenza artificiale generativa o da un musicista umano, utilizzando la scala a 4 punti da ",
      tags$em("Sicuramente umana"), " a ", tags$em("Sicuramente AI"),
      ". Qualora non riesca a esprimere un giudizio, selezioni l'opzione ", tags$em("'Non so'"), "."
    ),
    audio_context = "Ai fini di questo studio, per 'musica generata dall'AI' si intende musica composta e prodotta interamente da sistemi di intelligenza artificiale generativa, senza alcun contributo umano nella composizione, nella scrittura o nella registrazione. Questi sistemi analizzano grandi quantità di musica esistente per apprenderne i pattern (ritmo, armonia, timbro, stile) e generano nuove composizioni originali a partire da prompt testuali o indicazioni dell'utente.",
    btn_next = "Avanti",

    badge2          = "Sezione 2 di 5",
    gaais_h3        = "Atteggiamenti verso l'Intelligenza Artificiale",
    gaais_context_intro = "In questa sezione Le chiediamo le Sue opinioni sull'intelligenza artificiale in senso ampio, non solo quella applicata alla musica.",
    gaais_context_q     = "Cosa si intende per Intelligenza Artificiale?",
    gaais_ai_def        = "Con \"intelligenza artificiale\" intendiamo qualsiasi sistema capace di svolgere compiti che normalmente richiederebbero l'intelligenza umana: dai sistemi di raccomandazione agli assistenti vocali, dai robot industriali ai software di analisi dei dati.",
    gaais_context_scale = "Per ogni affermazione, indichi in che misura si trova d'accordo. Non esistono risposte giuste o sbagliate.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Sezione 3 di 5",
    framing_h3  = "Politiche AI nei servizi di streaming musicale",
    framing_p1  = "I principali servizi di streaming musicale ospitano un numero crescente di brani generati interamente o in parte dall'intelligenza artificiale. Le piattaforme hanno recentemente avviato le prime iniziative di policy, con approcci molto diversi tra loro.",

    framing_p2  = "Il fenomeno è già su scala industriale: il 44% degli upload giornalieri su Deezer è AI-generated (75.000 nuovi brani al giorno), eppure meno del 3% degli stream totali proviene da musica AI — massiccia sul lato dell'offerta, ancora marginale su quello della domanda (Deezer Newsroom, apr. 2026).",

    dsp_policy_h    = "Come si stanno muovendo le piattaforme",
    dsp_spotify     = "Label AI volontaria nei credenziali + badge 'Verified by Spotify' sui profili umani verificati; artisti prevalentemente AI esclusi (apr. 2026)",
    dsp_apple       = "Tag di trasparenza volontari per 4 categorie: traccia, artwork, composizione, video (mar. 2026)",
    dsp_deezer      = "Algoritmo brevettato di rilevazione dei contenuti AI; esclusione dalle playlist algoritmiche ed editoriali (da gen. 2025)",
    dsp_amazon      = "Nessuna policy specifica; brani AI accettati senza obbligo di disclosure",
    dsp_policy_note  = "Apple Music si basa su autodichiarazione senza verifica; Spotify ha introdotto una revisione umana con il badge Verified; Deezer è l'unica piattaforma con rilevamento tecnico automatico.",
    dsp_badge_deezer = "Rilevazione algoritmica",
    dsp_badge_spotify= "Autodichiarazione",
    dsp_badge_apple  = "Autodichiarazione",
    dsp_badge_amazon = "Nessuna iniziativa",

    sq_note     = tagList("Come riferimento: oggi la maggior parte dei servizi di streaming non applica alcuna policy AI specifica e offre abbonamenti a circa ", tags$strong("11,99 €/mese"), "."),

    task_h5     = "Come leggere le schede di scelta",
    task_p1     = tagList(
      "Nelle pagine seguenti Le verranno presentate ", tags$strong("12 situazioni ipotetiche"),
      ". In ciascuna sono proposte ", tags$strong("3 configurazioni alternative di abbonamento"),
      ", che si differenziano per le seguenti caratteristiche:"
    ),
    attr_a_lbl    = "Policy di labeling AI",
    attr_a_desc   = " - Come la piattaforma identifica e comunica agli ascoltatori la presenza di musica generata dall'AI.",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Nessuna label:"), " le tracce AI non sono distinguibili da quelle umane.")),
      tags$li(tagList(tags$strong("Label volontaria:"), " l'etichetta compare solo se dichiarata dall'artista o dal distributore al momento del caricamento.")),
      tags$li(tagList(tags$strong("Label obbligatoria:"), " la piattaforma verifica i contenuti tramite un algoritmo proprietario e applica l'etichetta AI, indipendentemente da quanto dichiarato dall'artista o dal distributore."))
    ),
    attr_b_lbl    = "Struttura promozionale",
    attr_b_desc   = " - In che misura la musica AI è presente nelle playlist raccomandate dall'algoritmo.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non inclusa:"), " la musica AI non compare in alcuna playlist raccomandata.")),
      tags$li(tagList(tags$strong("Inclusa:"), " la musica AI compare nelle playlist raccomandate all'utente (es. Daily Mix) e in quelle generaliste (es. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Inclusa + sezione dedicata:"), " come sopra, più una sezione AI-only nella app che l'utente può scegliere di esplorare.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "es. \U0001F446")))
    ),
    attr_c_lbl    = "Controllo utente",
    attr_c_desc   = " - Gli strumenti a disposizione per gestire la presenza di musica AI nella propria esperienza.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Nessun controllo:"), " non sono disponibili strumenti per filtrare i contenuti AI.")),
      tags$li(tagList(tags$strong("Filtro parziale:"), " la musica AI rimane disponibile sulla piattaforma, ma può essere esclusa dalle playlist personalizzate.")),
      tags$li(tagList(tags$strong("Filtro completo:"), " blocco totale della musica AI sull'intera piattaforma.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "es. \U0001F446")))
    ),
    attr_d_lbl    = "Prezzo mensile",
    attr_d_desc   = " - Il costo mensile dell'abbonamento.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Tre livelli possibili: ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euro al mese.")
    ),
    task_p2       = "Ogni scheda rappresenta una situazione di scelta a se stante. Le configurazioni mostrate sono le sole alternative disponibili in quel momento: non le confronti con quelle di schede diverse. Scelga la configurazione che preferirebbe adottare come piano di abbonamento.",
    btn_start_cbc = "Inizia le scelte",

    cbc_badge = "Sezione 3 di 5",
    cbc_q     = "Quale di queste configurazioni di abbonamento preferirebbe?",
    cbc_instr = tagList(
      "Le 3 alternative differiscono per policy AI e prezzo. ",
      "Selezioni la configurazione che preferirebbe realmente adottare."
    ),
    cbc_opt        = "Opzione",
    cbc_a1lbl      = "Policy labeling AI",
    cbc_a2lbl      = "Struttura promozionale",
    cbc_a3lbl      = "Controllo utente",
    cbc_instr_cont = "Valuti questa scheda indipendentemente dalle scelte effettuate in precedenza.",

    badge4      = "Sezione 4 di 5",
    proxy_h3    = "Esperienze musicali e percezione dell'AI",
    proxy_instr = "Di seguito sono elencate alcune affermazioni. Le chiediamo di leggerle attentamente e di indicare quanto è d'accordo o in disaccordo con ciascuna di esse.",
    freq_q      = "Con quale frequenza ascolta musica in streaming?",
    aware_q     = "Prima di questo sondaggio, era a conoscenza del fatto che il Suo servizio di streaming include tracce generate dall'AI?",
    churn_q     = tagList(
      "Se il servizio di streaming che utilizza non introducesse alcuna ",
      tags$strong("politica di trasparenza"),
      " sulla musica generata dall'AI nei prossimi 12 mesi, quanto sarebbe propenso/a a cancellare o cambiare abbonamento?"
    ),

    badge5       = "Sezione 5 di 5",
    demo_h3      = "Dati demografici e utilizzo dei servizi",
    demo_instr   = "Le ricordiamo che l'indagine è anonima. Le informazioni richieste in questa sezione saranno utilizzate esclusivamente per finalità statistiche e presentate in forma aggregata.",
    age_lbl      = "Fascia d'età *",
    gender_lbl   = "Genere *",
    country_lbl  = "Paese di residenza *",
    edu_lbl      = "Titolo di studio più elevato conseguito *",
    dsp_h5       = "Utilizzo dei servizi di streaming musicale",
    dsp_user_q   = "È attualmente abbonato/a o utilizza regolarmente un servizio di streaming musicale? *",
    dsp_svc_lbl  = "Quale servizio utilizza principalmente? *",
    dsp_tier_lbl = "Tipo di abbonamento *",
    btn_submit   = "Invia le risposte",

    ty_h2      = "Grazie per la Sua partecipazione!",
    ty_lead    = "Le Sue risposte sono state registrate con successo.",
    ty_close   = "Può ora chiudere questa finestra.",
    ty_contact = "Per informazioni sulla ricerca:"
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

    intro_title    = "AI-Generated Music in Streaming Services",
    intro_title2   = "A Survey on Consumer Preferences",
    privacy_head   = "Privacy notice and informed consent",

    intro_salute = "Dear participant,",
    intro_body   = "I am a Master's student in Management at the University of Trento. I am inviting you to take part in this survey, developed as part of my Master's thesis, which aims to understand consumer preferences regarding the policies adopted by music streaming platforms in relation to AI-generated music.",

    survey_warn  = "Please note: if possible, avoid refreshing the page or using the browser's Back button during the survey. Once you press Next in each section, your answers cannot be changed.",

    what_asked_h = "What will be asked of you?",
    what_asked   = tags$ol(
      tags$li("A short listening task to evaluate music clips"),
      tags$li("Your general opinions on artificial intelligence"),
      tags$li("Choices between different streaming subscription configurations"),
      tags$li("Questions about your listening habits and perception of AI music"),
      tags$li("Some demographic information")
    ),

    c_part_lbl = "Participation:",
    c_part     = " Voluntary. You are free to withdraw at any time without consequences.",
    c_data_lbl = "Data collected:",
    c_data     = " Responses are anonymous and cannot be traced back to you. Data will be used exclusively for academic research purposes and presented in aggregated form.",
    c_time_lbl = "Estimated duration:",
    c_time     = " 10-15 minutes.",

    contact_h    = "For information:",
    contact_info = tagList(
      tags$p("Lorenzo Paravano - lorenzo.paravano@gmail.com"),
      tags$p("Prof. Diego Giuliani - [email to be added]")
    ),

    consent_chk = "I have read the privacy notice and voluntarily consent to participate in the survey.",
    btn_start   = "Start",

    badge1        = "Section 1 of 5",
    audio_h3      = "Audio Discrimination Task",
    audio_hint      = "\U0001F3A7 Headphones or a quiet setting recommended",
    audio_context_q = "What is AI-generated music?",
    audio_instr   = tagList(
      "We present you with ", tags$strong("4 short music clips"),
      ". For each track, please indicate to what extent you believe it was produced using generative artificial intelligence or by a human musician, using the 4-point scale from ",
      tags$em("Definitely human"), " to ", tags$em("Definitely AI"),
      ". If you are unable to form a judgement, please select the option ", tags$em("'Don't know'"), "."
    ),
    audio_context = "For the purposes of this study, 'AI-generated music' refers to music composed and produced entirely by generative AI systems, without any human input in composition, writing or recording. These systems analyse vast datasets of existing music to learn patterns (rhythm, harmony, timbre and style) and use them to generate new, original compositions from text prompts or user input.",
    btn_next = "Next",

    badge2          = "Section 2 of 5",
    gaais_h3        = "Attitudes towards Artificial Intelligence",
    gaais_context_intro = "In this section we ask for your views on artificial intelligence broadly, not just AI in music.",
    gaais_context_q     = "What do we mean by Artificial Intelligence?",
    gaais_ai_def        = "By \"artificial intelligence\" we mean any system capable of performing tasks that would normally require human intelligence: from recommendation engines and voice assistants to industrial robots and data analysis tools.",
    gaais_context_scale = "For each statement, indicate to what extent you agree. There are no right or wrong answers.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Section 3 of 5",
    framing_h3  = "AI Policies in Music Streaming Services",
    framing_p1  = "The major music streaming services host a growing number of tracks generated entirely or in part by artificial intelligence. Platforms have recently launched their first policy initiatives, with very different approaches.",

    framing_p2  = "The phenomenon is already at industrial scale: 44% of daily uploads on Deezer are AI-generated (75,000 new tracks per day), yet less than 3% of total streams come from AI music — massively present on the supply side, but still marginal in terms of actual listening (Deezer Newsroom, Apr. 2026).",

    dsp_policy_h    = "How platforms are responding",
    dsp_spotify     = "Voluntary AI label in song credits + 'Verified by Spotify' badge for human-verified profiles; AI-primary artists excluded (Apr. 2026)",
    dsp_apple       = "Voluntary transparency tags for 4 categories: track, artwork, composition, video (Mar. 2026)",
    dsp_deezer      = "Patented AI-detection algorithm; exclusion from algorithmic and editorial playlists (since Jan. 2025)",
    dsp_amazon      = "No specific policy; AI tracks accepted without disclosure requirement",
    dsp_policy_note  = "Apple Music relies on self-declaration with no verification; Spotify has introduced human review via the Verified badge; Deezer is the only platform with automatic technical detection.",
    dsp_badge_deezer = "Algorithmic detection",
    dsp_badge_spotify= "Self-declaration",
    dsp_badge_apple  = "Self-declaration",
    dsp_badge_amazon = "No initiative",

    sq_note     = tagList("For reference: most streaming services today apply no specific AI policy and offer subscriptions at around ", tags$strong("€11.99/month"), "."),

    task_h5     = "How to read the choice cards",
    task_p1     = tagList(
      "On the following pages you will see ", tags$strong("12 hypothetical situations"),
      ". Each presents ", tags$strong("3 alternative subscription configurations"),
      " differing in the following characteristics:"
    ),
    attr_a_lbl    = "AI labelling policy",
    attr_a_desc   = " - How the platform identifies and communicates the presence of AI-generated music to listeners.",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("No label:"), " AI tracks are indistinguishable from human tracks.")),
      tags$li(tagList(tags$strong("Voluntary label:"), " the label appears only if declared by the artist or distributor at upload.")),
      tags$li(tagList(tags$strong("Mandatory label:"), " the platform verifies content via a proprietary algorithm and applies the AI label, regardless of what the artist or distributor declares."))
    ),
    attr_b_lbl    = "Promotional structure",
    attr_b_desc   = " - The extent to which AI music is present in algorithmically recommended playlists.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Not included:"), " AI music does not appear in any recommended playlist.")),
      tags$li(tagList(tags$strong("Included:"), " AI music appears in personalised playlists (e.g. Daily Mix) and general ones (e.g. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Included + dedicated section:"), " as above, plus an AI-only section in the app that users can choose to explore.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "es. \U0001F446")))
    ),
    attr_c_lbl    = "User control",
    attr_c_desc   = " - The tools available to manage the presence of AI music in your experience.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("No control:"), " no tools are available to filter AI content.")),
      tags$li(tagList(tags$strong("Partial filter:"), " AI music remains available on the platform but can be excluded from personalised playlists.")),
      tags$li(tagList(tags$strong("Full filter:"), " total block of AI music across the entire platform.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "es. \U0001F446")))
    ),
    attr_d_lbl    = "Monthly price",
    attr_d_desc   = " - The monthly cost of the subscription.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Three possible levels: ", tags$strong("9.99"), " / ", tags$strong("11.99"), " / ", tags$strong("13.99"), " euros per month.")
    ),
    task_p2       = "Each card represents a standalone choice situation. The configurations shown are the only alternatives available at that moment: do not compare them with those on other cards. Choose the configuration you would prefer to adopt as your subscription plan.",
    btn_start_cbc = "Start choices",

    cbc_badge = "Section 3 of 5",
    cbc_q     = "Which of these subscription configurations would you prefer?",
    cbc_instr = tagList(
      "The 3 alternatives differ in AI policy and price. ",
      "Select the configuration you would really adopt."
    ),
    cbc_opt        = "Option",
    cbc_a1lbl      = "AI labelling policy",
    cbc_a2lbl      = "Promotional structure",
    cbc_a3lbl      = "User control",
    cbc_instr_cont = "Evaluate this card independently of your previous choices.",

    badge4      = "Section 4 of 5",
    proxy_h3    = "Music experiences and AI perception",
    proxy_instr = "Below are a number of statements. Please read each one carefully and indicate how much you agree or disagree with each of them.",
    freq_q      = "How often do you listen to streaming music?",
    aware_q     = "Before this survey, were you aware that your streaming service includes AI-generated tracks?",
    churn_q     = tagList(
      "If the streaming service you use were to introduce ",
      tags$strong("no transparency policy"),
      " on AI-generated music over the next 12 months, how likely would you be to cancel or switch your subscription?"
    ),

    badge5       = "Section 5 of 5",
    demo_h3      = "Demographics and service usage",
    demo_instr   = "Please note that this survey is anonymous. The information requested in this section will be used exclusively for statistical purposes and presented in aggregated form.",
    age_lbl      = "Age group *",
    gender_lbl   = "Gender *",
    country_lbl  = "Country of residence *",
    edu_lbl      = "Highest educational qualification *",
    dsp_h5       = "Music streaming service usage",
    dsp_user_q   = "Are you currently subscribed to or regularly using a music streaming service? *",
    dsp_svc_lbl  = "Which service do you use most? *",
    dsp_tier_lbl = "Subscription type *",
    btn_submit   = "Submit answers",

    ty_h2      = "Thank you for your participation!",
    ty_lead    = "Your answers have been successfully recorded.",
    ty_close   = "You can now close this window.",
    ty_contact = "For information about the research:"
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # FRANCAIS
  # ══════════════════════════════════════════════════════════════════════════
  fr = list(

    decimal_sep = ",",
    per_month   = "/mois",

    audio_ch = c(
      "Surement IA"          = "4",
      "Probablement IA"      = "3",
      "Probablement humaine" = "2",
      "Surement humaine"     = "1",
      "Je ne sais pas"       = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Evaluee",
    audio_msg  = "Votre navigateur ne prend pas en charge la lecture audio.",

    lik5  = c("Tout a fait en desaccord","En desaccord","Neutre",
              "D'accord","Tout a fait d'accord"),
    lik5p = c("Pas du tout probable","Peu probable","Neutre","Probable","Tres probable"),
    freq_opts  = c("Jamais"="never","Quelques fois par mois"="monthly",
                   "Quelques fois par semaine"="weekly","Chaque jour"="daily"),
    aware_opts = c("Oui"="yes","Non"="no","Je n'etais pas sur(e)"="unsure"),
    dsp_yn     = c("Oui"="yes","Non"="no"),

    A1 = c(
      "Aucun label IA visible (metadonnees internes uniquement, inaccessibles aux utilisateurs)",
      "Label IA volontaire (visible uniquement si declare par le distributeur lors du telechargement)",
      "Label IA obligatoire (garanti par la plateforme, independamment de l'artiste)"
    ),
    A2 = c(
      "Musique IA non incluse dans les playlists recommandees",
      "Musique IA dans les playlists recommandees et generalistes",
      "Musique IA dans les playlists recommandees + espace IA dedie supplementaire"
    ),
    A3 = c(
      "Aucun controle utilisateur sur la musique IA",
      "Filtre partiel : exclusion de la musique IA des playlists personnalisees",
      "Filtre complet : blocage total de la musique IA sur la plateforme"
    ),

    gaais = c(
      "Je suis interesse(e) a utiliser des systemes d'intelligence artificielle dans ma vie quotidienne.",
      "Je trouve l'intelligence artificielle inquietante.",
      "L'intelligence artificielle pourrait prendre le controle des personnes.",
      "Je pense que l'intelligence artificielle est dangereuse.",
      "L'intelligence artificielle peut avoir un impact positif sur le bien-etre des personnes.",
      "L'intelligence artificielle est passionnante.",
      "Une grande partie de la societe beneficiera d'un avenir riche en intelligence artificielle.",
      "Je voudrais utiliser l'intelligence artificielle dans mon travail.",
      "Je frissonne d'inconfort en pensant aux utilisations futures de l'intelligence artificielle.",
      "Des personnes comme moi souffriront si l'intelligence artificielle est utilisee de plus en plus."
    ),

    proxy = c(
      "Quand j'ecoute de la musique en streaming, je selectionne la qualite audio la plus elevee disponible.",
      "Je reecoute frequemment les memes titres pour saisir des details sonores que je n'avais pas remarques a la premiere ecoute.",
      "J'ecoute generalement un titre jusqu'a la fin avant de decider si je l'aime, meme quand il ne me convainc pas immediatement.",
      "J'utilise souvent la fonction de recherche pour trouver des artistes ou des titres specifiques, plutot que de me fier aux recommandations de la plateforme.",
      "Je prefere que la musique que j'ecoute ait ete selectionnee par une personne plutot que par un algorithme (p. ex. playlists editoriales plutot que Discover Weekly ou Daily Mix).",
      "Si j'etais certain(e) qu'un artiste produit de la musique generee entierement par l'IA, je le bloquerais sur ma plateforme de streaming."
    ),

    sel_placeholder = "-- Selectionner --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Homme"="man","Femme"="woman",
                    "Non-binaire / Troisieme genre"="nonbinary",
                    "Prefere ne pas preciser"="no_answer"),
    edu_opts    = c(
      "Brevet des colleges"               = "middle",
      "Baccalaureat / Diplome de lycee"   = "highschool",
      "Licence (Bac+3)"                   = "bachelor",
      "Master / Diplome d'ingenieur"      = "master",
      "Doctorat / Post-diplome"           = "phd"
    ),
    country_opts = c(
      "Italie"="IT","France"="FR","Allemagne"="DE","Espagne"="ES","Portugal"="PT",
      "Royaume-Uni"="GB","Pays-Bas"="NL","Belgique"="BE","Suisse"="CH","Autriche"="AT",
      "Pologne"="PL","Roumanie"="RO","Republique tcheque"="CZ","Suede"="SE","Norvege"="NO",
      "Danemark"="DK","Finlande"="FI","Grece"="GR","Hongrie"="HU","Croatie"="HR",
      "Etats-Unis"="US","Canada"="CA","Australie"="AU","Bresil"="BR","Argentine"="AR",
      "Autre"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Autre"="other"),
    tier_opts = c("Gratuit (avec publicite)"="free","Premium individuel"="premium_ind",
                  "Premium famille / Duo"="premium_fam","Etudiant(e)"="student","Autre"="other"),

    err_consent  = "Vous devez consentir a participer pour continuer.",
    err_audio    = "Veuillez evaluer les 4 clips avant de continuer.",
    err_gaais    = "Veuillez repondre a tous les items avant de continuer.",
    err_cbc      = "Veuillez selectionner une option avant de continuer.",
    err_proxy    = "Veuillez repondre a tous les items avant de continuer.",
    err_demo_req = "Veuillez remplir tous les champs demographiques obligatoires (*).",
    err_dsp_user = "Veuillez indiquer si vous utilisez un service de streaming musical.",
    err_dsp_svc  = "Veuillez indiquer le service de streaming que vous utilisez principalement.",
    err_dsp_tier = "Veuillez indiquer votre type d'abonnement.",

    intro_title    = "La musique generee par l'IA dans les services de streaming",
    intro_title2   = "Sondage sur les preferences des consommateurs",
    privacy_head   = "Avis de confidentialite et consentement eclaire",

    intro_salute = "Chere participante, cher participant,",
    intro_body   = "je suis etudiant en Master Management a l'Universite de Trente. Je vous invite a participer a ce sondage, elabore dans le cadre de mon memoire de master, dont l'objectif est de comprendre les preferences des consommateurs concernant les politiques adoptees par les plateformes de streaming musical en matiere de musique generee par l'IA.",

    survey_warn  = "Attention : si possible, évitez de rafraîchir la page ou d'utiliser le bouton Précédent du navigateur pendant le sondage. Une fois le bouton Suivant pressé dans chaque section, vos réponses ne pourront plus être modifiées.",

    what_asked_h = "Ce qu'on vous demandera ?",
    what_asked   = tags$ol(
      tags$li("Realiser une courte tache d'ecoute pour evaluer des extraits musicaux"),
      tags$li("Indiquer vos opinions generales sur l'intelligence artificielle"),
      tags$li("Effectuer des choix entre differentes configurations d'abonnement a un service de streaming"),
      tags$li("Repondre a des questions sur vos habitudes d'ecoute et votre perception de la musique IA"),
      tags$li("Fournir quelques informations demographiques")
    ),

    c_part_lbl = "Participation :",
    c_part     = " Volontaire. Vous etes libre de vous retirer a tout moment sans consequences.",
    c_data_lbl = "Donnees collectees :",
    c_data     = " Les reponses sont anonymes et ne peuvent pas etre reliees a votre personne. Les donnees seront utilisees exclusivement a des fins de recherche academique et presentees sous forme agregee.",
    c_time_lbl = "Duree estimee :",
    c_time     = " 10-15 minutes.",

    contact_h    = "Pour des informations :",
    contact_info = tagList(
      tags$p("Lorenzo Paravano - lorenzo.paravano@gmail.com"),
      tags$p("Prof. Diego Giuliani - [email a ajouter]")
    ),

    consent_chk = "J'ai lu l'avis de confidentialite et consens volontairement a participer au sondage.",
    btn_start   = "Commencer",

    badge1        = "Section 1 sur 5",
    audio_h3      = "Tache de discrimination audio",
    audio_hint      = "\U0001F3A7 Casque ou environnement calme recommande",
    audio_context_q = "Qu'est-ce que la musique generee par l'IA ?",
    audio_instr   = tagList(
      "Nous vous presentons ", tags$strong("4 courts extraits musicaux"),
      ". Pour chaque piste, veuillez indiquer dans quelle mesure vous pensez qu'elle a ete produite par l'intelligence artificielle generative ou par un musicien humain, en utilisant l'echelle a 4 points de ",
      tags$em("Surement humaine"), " a ", tags$em("Surement IA"),
      ". Si vous n'etes pas en mesure de formuler un jugement, selectionnez l'option ", tags$em("'Je ne sais pas'"), "."
    ),
    audio_context = "Dans le cadre de cette etude, la 'musique generee par l'IA' designe la musique composee et produite entierement par des systemes d'IA generative, sans aucune contribution humaine dans la composition, l'ecriture ou l'enregistrement. Ces systemes analysent de vastes ensembles de musique existante pour en apprendre les patterns (rythme, harmonie, timbre, style) et generent de nouvelles compositions originales a partir d'invites textuelles ou d'indications de l'utilisateur.",
    btn_next = "Suivant",

    badge2          = "Section 2 sur 5",
    gaais_h3        = "Attitudes envers l'Intelligence Artificielle",
    gaais_context_intro = "Dans cette section, nous vous demandons vos opinions sur l'intelligence artificielle au sens large, pas uniquement dans le domaine musical.",
    gaais_context_q     = "Qu'entend-on par Intelligence Artificielle ?",
    gaais_ai_def        = "Par \"intelligence artificielle\", nous entendons tout système capable d'effectuer des tâches qui nécessiteraient normalement l'intelligence humaine : systèmes de recommandation, assistants vocaux, robots industriels, logiciels d'analyse de données, et bien d'autres.",
    gaais_context_scale = "Pour chaque affirmation, indiquez dans quelle mesure vous êtes d'accord. Il n'y a pas de bonnes ou de mauvaises réponses.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Section 3 sur 5",
    framing_h3  = "Politiques IA dans les services de streaming musical",
    framing_p1  = "Les principaux services de streaming musical hebergent un nombre croissant de titres generes entierement ou en partie par l'intelligence artificielle. Les plateformes ont recemment lance leurs premieres initiatives de politique, avec des approches tres differentes.",

    framing_p2  = "Le phénomène est déjà à l'échelle industrielle : 44 % des uploads quotidiens sur Deezer sont générés par l'IA (75 000 nouveaux titres par jour), pourtant moins de 3 % des streams totaux proviennent de musique IA — massivement présente du côté de l'offre, mais encore marginale du côté de l'écoute (Deezer Newsroom, avr. 2026).",

    dsp_policy_h    = "Comment les plateformes reagissent",
    dsp_spotify     = "Label IA volontaire dans les crédits + badge « Verified by Spotify » sur les profils humains vérifiés ; artistes principalement IA exclus (avr. 2026)",
    dsp_apple       = "Tags de transparence volontaires pour 4 categories : titre, artwork, composition, video (mar. 2026)",
    dsp_deezer      = "Algorithme brevete de detection des contenus IA ; exclusion des playlists algorithmiques et editoriales (depuis janv. 2025)",
    dsp_amazon      = "Aucune politique specifique ; titres IA acceptes sans obligation de declaration",
    dsp_policy_note  = "Apple Music repose sur l'autodéclaration sans vérification ; Spotify a introduit une révision humaine via le badge Verified ; Deezer est la seule plateforme avec détection technique automatique.",
    dsp_badge_deezer = "Détection algorithmique",
    dsp_badge_spotify= "Autodéclaration",
    dsp_badge_apple  = "Autodéclaration",
    dsp_badge_amazon = "Aucune initiative",

    sq_note     = tagList("Pour référence : la plupart des services de streaming n'appliquent aujourd'hui aucune politique IA spécifique et proposent des abonnements à environ ", tags$strong("11,99 €/mois"), "."),

    task_h5     = "Comment lire les fiches de choix",
    task_p1     = tagList(
      "Dans les pages suivantes, vous verrez ", tags$strong("12 situations hypothetiques"),
      ". Chacune presente ", tags$strong("3 configurations alternatives d'abonnement"),
      " differant selon les caracteristiques suivantes :"
    ),
    attr_a_lbl    = "Politique de label IA",
    attr_a_desc   = " - Comment la plateforme identifie et communique aux auditeurs la presence de musique generee par l'IA.",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Aucun label :"), " les titres IA ne sont pas distinguables des titres humains.")),
      tags$li(tagList(tags$strong("Label volontaire :"), " l'étiquette n'apparaît que si elle est déclarée par l'artiste ou le distributeur lors du téléchargement.")),
      tags$li(tagList(tags$strong("Label obligatoire :"), " la plateforme vérifie les contenus via un algorithme propriétaire et applique le label IA, indépendamment de ce que déclare l'artiste ou le distributeur."))
    ),
    attr_b_lbl    = "Structure promotionnelle",
    attr_b_desc   = " - Dans quelle mesure la musique IA est presente dans les playlists recommandees par l'algorithme.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non incluse :"), " la musique IA n'apparaît dans aucune playlist recommandée.")),
      tags$li(tagList(tags$strong("Incluse :"), " la musique IA apparaît dans les playlists personnalisées (ex. Daily Mix) et généralistes (ex. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Incluse + section dédiée :"), " comme ci-dessus, plus une section IA uniquement dans l'application que l'utilisateur peut choisir d'explorer.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "es. \U0001F446")))
    ),
    attr_c_lbl    = "Controle utilisateur",
    attr_c_desc   = " - Les outils disponibles pour gerer la presence de musique IA dans votre experience.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Aucun controle :"), " aucun outil n'est disponible pour filtrer les contenus IA.")),
      tags$li(tagList(tags$strong("Filtre partiel :"), " la musique IA reste disponible sur la plateforme, mais peut etre exclue des playlists personnalisees.")),
      tags$li(tagList(tags$strong("Filtre complet :"), " blocage total de la musique IA sur l'ensemble de la plateforme.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "es. \U0001F446")))
    ),
    attr_d_lbl    = "Prix mensuel",
    attr_d_desc   = " - Le cout mensuel de l'abonnement.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Trois niveaux possibles : ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euros par mois.")
    ),
    task_p2       = "Chaque fiche represente une situation de choix a part entiere. Les configurations presentees sont les seules alternatives disponibles a ce moment : ne les comparez pas avec celles des autres fiches. Choisissez la configuration que vous prefereriez adopter comme plan d'abonnement.",
    btn_start_cbc = "Commencer les choix",

    cbc_badge = "Section 3 sur 5",
    cbc_q     = "Laquelle de ces configurations d'abonnement prefereriez-vous ?",
    cbc_instr = tagList(
      "Les 3 alternatives different par la politique IA et le prix. ",
      "Selectionnez la configuration que vous adopteriez reellement."
    ),
    cbc_opt        = "Option",
    cbc_a1lbl      = "Politique de label IA",
    cbc_a2lbl      = "Structure promotionnelle",
    cbc_a3lbl      = "Controle utilisateur",
    cbc_instr_cont = "Evaluez cette fiche independamment de vos choix precedents.",

    badge4      = "Section 4 sur 5",
    proxy_h3    = "Experiences musicales et perception de l'IA",
    proxy_instr = "Vous trouverez ci-dessous plusieurs affirmations. Nous vous demandons de les lire attentivement et d'indiquer dans quelle mesure vous etes d'accord ou en desaccord avec chacune d'elles.",
    freq_q      = "A quelle frequence ecoutez-vous de la musique en streaming ?",
    aware_q     = "Avant ce sondage, saviez-vous que votre service de streaming inclut des titres generes par l'IA ?",
    churn_q     = tagList(
      "Si le service de streaming que vous utilisez n'introduisait aucune ",
      tags$strong("politique de transparence"),
      " sur la musique generee par l'IA au cours des 12 prochains mois, dans quelle mesure seriez-vous enclin(e) a resilier ou changer votre abonnement ?"
    ),

    badge5       = "Section 5 sur 5",
    demo_h3      = "Donnees demographiques et utilisation des services",
    demo_instr   = "Nous vous rappelons que l'enquete est anonyme. Les informations demandees dans cette section seront utilisees exclusivement a des fins statistiques et presentees sous forme agregee.",
    age_lbl      = "Tranche d'age *",
    gender_lbl   = "Genre *",
    country_lbl  = "Pays de residence *",
    edu_lbl      = "Diplome le plus eleve obtenu *",
    dsp_h5       = "Utilisation des services de streaming musical",
    dsp_user_q   = "Etes-vous actuellement abonne(e) a ou utilisez-vous regulierement un service de streaming musical ? *",
    dsp_svc_lbl  = "Quel service utilisez-vous principalement ? *",
    dsp_tier_lbl = "Type d'abonnement *",
    btn_submit   = "Soumettre les reponses",

    ty_h2      = "Merci de votre participation !",
    ty_lead    = "Vos reponses ont ete enregistrees avec succes.",
    ty_close   = "Vous pouvez maintenant fermer cette fenetre.",
    ty_contact = "Pour des informations sur la recherche :"
  )
)
