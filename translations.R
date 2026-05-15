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
    audio_msg  = "Il browser non supporta la riproduzione audio.",

    lik5  = c("Fortemente in disaccordo","In disaccordo","Neutrale",
              "D'accordo","Fortemente d'accordo"),
    lik5p = c("Per nulla probabile","Poco probabile","Neutrale",
              "Probabile","Molto probabile"),
    freq_opts  = c("Mai"="never","Qualche volta al mese"="monthly",
                   "Qualche volta a settimana"="weekly","Ogni giorno"="daily"),
    aware_opts = c("Sì"="yes","No"="no","Non ero sicuro/a"="unsure"),
    dsp_yn     = c("Sì"="yes","No"="no"),

    A1 = c(
      "Nessuna label AI (le tracce AI non sono identificabili)",
      "Label AI volontaria (visibile solo se dichiarata dall'artista)",
      "Label AI obbligatoria (verificata dalla piattaforma)"
    ),
    A2 = c(
      "Musica AI non inclusa in alcuna playlist",
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
      "Italia"="IT",
      "Argentina"="AR","Australia"="AU","Austria"="AT","Belgio"="BE","Brasile"="BR",
      "Canada"="CA","Croazia"="HR","Danimarca"="DK","Finlandia"="FI","Francia"="FR",
      "Germania"="DE","Grecia"="GR","Norvegia"="NO","Paesi Bassi"="NL","Polonia"="PL",
      "Portogallo"="PT","Regno Unito"="GB","Repubblica Ceca"="CZ","Romania"="RO",
      "Spagna"="ES","Stati Uniti"="US","Svezia"="SE","Svizzera"="CH","Ungheria"="HU",
      "Altro"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Altro"="other"),
    tier_opts = c("Gratuito" = "free", "A pagamento" = "paid"),

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
      tags$li("Indicare le Sue opinioni generali sull'intelligenza artificiale"),
      tags$li("Effettuare scelte tra diverse configurazioni di abbonamento a un servizio di streaming"),
      tags$li("Svolgere un breve task di ascolto per valutare clip musicali"),
      tags$li("Rispondere a domande sulle Sue abitudini di ascolto e sulla percezione della musica AI"),
      tags$li("Fornire alcune informazioni demografiche")
    ),

    c_part_lbl = "Partecipazione:",
    c_part     = " Volontaria. È libero/a di ritirarsi in qualsiasi momento chiudendo la pagina, senza conseguenze.",
    c_data_lbl = "Dati raccolti:",
    c_data     = " Le risposte sono raccolte in forma anonima (nessun dato identificativo: nome, email o IP) e utilizzate esclusivamente per finalità di ricerca accademica, presentate in forma aggregata. I dati sono conservati tramite Google Sheets per un periodo massimo di 12 mesi dalla conclusione dello studio. Il trattamento avviene sulla base del Suo consenso, ai sensi dell'art. 6.1.a del Regolamento (UE) 2016/679 (GDPR).",
    c_time_lbl = "Durata stimata:",
    c_time     = " 10-15 minuti.",

    contact_h    = "Per informazioni:",
    contact_info = tagList(
      tags$p("Titolare del trattamento: Lorenzo Paravano — lorenzo.paravano@studenti.unitn.it"),
      tags$p("Relatore: Prof. Diego Giuliani — diego.giuliani@unitn.it")
    ),

    consent_chk = "Dichiaro di avere almeno 18 anni e acconsento alla partecipazione e al trattamento dei dati per le finalità indicate.",
    btn_start   = "Inizia",

    badge1        = "Sezione 3 di 5",
    audio_h3      = "Task di Discriminazione Audio",
    audio_hint      = "\U0001F3A7 Consigliamo cuffiette o un ambiente silenzioso",
    audio_context_q = "Cos'è la musica generata dall'AI?",
    audio_instr   = tagList(
      "Le presentiamo ", tags$strong("4 brevi clip musicali"),
      ". Per ciascuna traccia, La preghiamo di indicare in che misura ritiene che essa sia stata prodotta tramite l'utilizzo di intelligenza artificiale generativa o da un musicista umano, utilizzando la scala a 4 punti da ",
      tags$em("Sicuramente umana"), " a ", tags$em("Sicuramente AI"),
      ". Qualora non riesca a esprimere un giudizio, selezioni l'opzione ", tags$em("'Non so'"), "."
    ),
    audio_context = tagList(
      "Ai fini di questo studio, per 'musica generata dall'AI' si intende musica ",
      tags$strong("composta e prodotta interamente da sistemi di intelligenza artificiale generativa"),
      ", ", tags$strong("senza alcun contributo umano"),
      " nella composizione, nella scrittura o nella registrazione. Questi sistemi analizzano grandi quantità di musica esistente per apprenderne i pattern (ritmo, armonia, timbro, stile) e generano nuove composizioni originali a partire da prompt testuali o indicazioni dell'utente."
    ),
    btn_next = "Avanti",

    badge2          = "Sezione 1 di 5",
    gaais_h3        = "Atteggiamenti verso l'Intelligenza Artificiale",
    gaais_context_intro = "In questa sezione Le chiediamo le Sue opinioni sull'intelligenza artificiale in senso ampio, non solo quella applicata alla musica.",
    gaais_context_q     = "Cosa si intende per Intelligenza Artificiale?",
    gaais_ai_def        = tagList(
      "Con \"intelligenza artificiale\" intendiamo ",
      tags$strong("qualsiasi sistema capace di svolgere compiti che normalmente richiederebbero l'intelligenza umana"),
      ": dai sistemi di raccomandazione agli assistenti vocali, dai robot industriali ai software di analisi dei dati."
    ),
    gaais_context_scale = "Per ogni affermazione, indichi in che misura si trova d'accordo. Non esistono risposte giuste o sbagliate.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Sezione 2 di 5",
    framing_h3  = "Politiche AI nei servizi di streaming musicale",
    framing_p1  = "",

    framing_p2  = tagList(
      "I principali servizi di streaming musicale ospitano un numero crescente di brani generati interamente o in parte dall'intelligenza artificiale. I dati più recenti mostrano che la presenza di musica AI nei cataloghi è già su scala industriale: ",
      tags$strong("oltre un terzo"), " degli upload mensili su Apple Music e circa il ",
      tags$strong("44%"), " di quelli su Deezer è generato dall'intelligenza artificiale.",
      " Il consumo resta tuttavia marginale: ",
      tags$strong("meno dello 0,5%"), " degli stream su Apple Music e ",
      tags$strong("meno del 3%"), " su Deezer riguarda musica AI",
      " (Billboard, 2026; Deezer Newsroom, apr. 2026)."
    ),

    dsp_policy_h    = "Come si stanno muovendo le piattaforme",
    dsp_spotify     = "Label AI volontaria nei credenziali + badge 'Verified by Spotify' sui profili umani verificati; artisti prevalentemente AI esclusi (apr. 2026)",
    dsp_apple       = "Tag di trasparenza volontari per 4 categorie: traccia, artwork, composizione, video (mar. 2026)",
    dsp_deezer      = "Algoritmo brevettato di rilevazione dei contenuti AI; esclusione dalle playlist algoritmiche ed editoriali (da gen. 2025)",
    dsp_amazon      = "Nessuna policy specifica; brani AI accettati senza obbligo di disclosure",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Rilevazione algoritmica",
    dsp_badge_spotify= "Autodichiarazione",
    dsp_badge_apple  = "Autodichiarazione",
    dsp_badge_amazon = "Nessuna iniziativa",

    sq_note     = tagList("Come riferimento: oggi la maggior parte dei servizi di streaming non applica alcuna policy AI specifica e offre abbonamenti a circa ", tags$strong("11,99 €/mese"), "."),

    framing_bridge = "A partire da questo contesto, Le chiediamo di esprimere le Sue preferenze attraverso una serie di scelte tra configurazioni di abbonamento differenziate.",
    task_h5     = "Come leggere le schede di scelta",
    task_p1     = tagList(
      "Nelle pagine seguenti Le verranno presentate ", tags$strong("12 situazioni ipotetiche"),
      ". In ciascuna sono proposte ", tags$strong("3 configurazioni alternative di abbonamento"),
      ", che si differenziano per le seguenti caratteristiche:"
    ),
    attr_a_lbl    = "Policy di labeling AI",
    attr_a_desc   = " - Come la piattaforma identifica e comunica agli ascoltatori la presenza di musica AI. Dove prevista, l'etichetta appare come una pill visibile nella schermata di ascolto (es. «AI Generated Content»).",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Nessuna label:"), " le tracce AI non sono distinguibili da quelle umane.")),
      tags$li(tagList(tags$strong("Label volontaria:"), " l'etichetta compare solo se dichiarata dall'artista o dal distributore al momento del caricamento.")),
      tags$li(tagList(tags$strong("Label obbligatoria:"), " la piattaforma verifica i contenuti tramite un algoritmo proprietario e applica l'etichetta AI, indipendentemente da quanto dichiarato dall'artista o dal distributore."))
    ),
    attr_b_lbl    = "Struttura promozionale",
    attr_b_desc   = " - In che misura la musica AI è presente nelle playlist raccomandate dall'algoritmo.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non inclusa:"), " la musica AI non compare in alcuna playlist.")),
      tags$li(tagList(tags$strong("Inclusa:"), " la musica AI compare nelle playlist raccomandate all'utente (es. Daily Mix) e in quelle generaliste (es. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Inclusa + sezione dedicata:"), " come al punto 2, più una sezione AI-only nella app che l'utente può scegliere di esplorare.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "es. \U0001F446")))
    ),
    attr_c_lbl    = "Controllo utente",
    attr_c_desc   = " - Gli strumenti a disposizione dell'utente per gestire la presenza di musica AI nella propria esperienza.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Nessun controllo:"), " non sono disponibili strumenti per filtrare i contenuti AI.")),
      tags$li(tagList(tags$strong("Filtro parziale:"), " la musica AI rimane disponibile e fruibile sulla piattaforma, ma può essere esclusa dalle playlist personalizzate per l'utente.")),
      tags$li(tagList(tags$strong("Filtro completo:"), " blocco totale della musica AI sull'intera piattaforma.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "es. \U0001F446")))
    ),
    attr_d_lbl    = "Prezzo mensile",
    attr_d_desc   = " - Il costo mensile dell'abbonamento.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Tre livelli possibili: ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euro al mese.")
    ),
    task_p2       = tagList(
      "Le 3 alternative differiscono per policy AI e prezzo. ",
      tags$strong("Selezioni la configurazione che preferirebbe realmente adottare"),
      " cliccando sulla scheda corrispondente, poi prema «Avanti»."
    ),
    btn_start_cbc = "Inizia le scelte",

    cbc_badge = "Sezione 2 di 5",
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

    badge4      = "Sezione 4 di 5",   # proxy: rimane sezione 4
    proxy_h3    = "Esperienze musicali e percezione dell'AI",
    proxy_instr = "Di seguito sono elencate alcune affermazioni. Le chiediamo di leggerle attentamente e di indicare quanto è d'accordo o in disaccordo con ciascuna di esse.",
    freq_q      = "Con quale frequenza ascolta musica in streaming?",
    aware_q     = "Prima di questo sondaggio, era a conoscenza del fatto che il Suo servizio di streaming include tracce generate interamente dall'AI?",
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
    ty_contact = "Per informazioni sulla ricerca:",
    ty_share_h = "Aiuti la ricerca — condivida il sondaggio",
    ty_share_p = "La ricerca ha bisogno di almeno 100 partecipanti. Se conosce persone interessate all'argomento, può condividere il link qui sotto.",
    ty_share_copy  = "Copia link",
    ty_share_copied = "Copiato!",
    ty_share_email = "Invia per e-mail",
    ty_share_wa    = "Condividi su WhatsApp"
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
      "No AI label (AI tracks are not identifiable)",
      "Voluntary AI label (visible only if declared by the artist)",
      "Mandatory AI label (verified by the platform)"
    ),
    A2 = c(
      "AI music not included in any playlist",
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
      "Italy"="IT",
      "Argentina"="AR","Australia"="AU","Austria"="AT","Belgium"="BE","Brazil"="BR",
      "Canada"="CA","Croatia"="HR","Czech Republic"="CZ","Denmark"="DK","Finland"="FI",
      "France"="FR","Germany"="DE","Greece"="GR","Hungary"="HU","Netherlands"="NL",
      "Norway"="NO","Poland"="PL","Portugal"="PT","Romania"="RO","Spain"="ES",
      "Sweden"="SE","Switzerland"="CH","United Kingdom"="GB","United States"="US",
      "Other"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Other"="other"),
    tier_opts = c("Free" = "free", "Paid" = "paid"),

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
      tags$li("Your general opinions on artificial intelligence"),
      tags$li("Choices between different streaming subscription configurations"),
      tags$li("A short listening task to evaluate music clips"),
      tags$li("Questions about your listening habits and perception of AI music"),
      tags$li("Some demographic information")
    ),

    c_part_lbl = "Participation:",
    c_part     = " Voluntary. You are free to withdraw at any time by closing the page, without any consequences.",
    c_data_lbl = "Data collected:",
    c_data     = " Responses are collected anonymously (no identifying data: name, email or IP address) and used exclusively for academic research purposes, presented in aggregated form. Data are stored via Google Sheets for a maximum of 12 months from the conclusion of the study. Processing is based on your consent, pursuant to Art. 6.1.a of Regulation (EU) 2016/679 (GDPR).",
    c_time_lbl = "Estimated duration:",
    c_time     = " 10-15 minutes.",

    contact_h    = "For information:",
    contact_info = tagList(
      tags$p("Data controller: Lorenzo Paravano — lorenzo.paravano@studenti.unitn.it"),
      tags$p("Thesis supervisor: Prof. Diego Giuliani — diego.giuliani@unitn.it")
    ),

    consent_chk = "I declare that I am at least 18 years old and consent to participation and to the processing of my data for the purposes indicated.",
    btn_start   = "Start",

    badge1        = "Section 3 of 5",
    audio_h3      = "Audio Discrimination Task",
    audio_hint      = "\U0001F3A7 Headphones or a quiet setting recommended",
    audio_context_q = "What is AI-generated music?",
    audio_instr   = tagList(
      "We present you with ", tags$strong("4 short music clips"),
      ". For each track, please indicate to what extent you believe it was produced using generative artificial intelligence or by a human musician, using the 4-point scale from ",
      tags$em("Definitely human"), " to ", tags$em("Definitely AI"),
      ". If you are unable to form a judgement, please select the option ", tags$em("'Don't know'"), "."
    ),
    audio_context = tagList(
      "For the purposes of this study, 'AI-generated music' refers to music ",
      tags$strong("composed and produced entirely by generative AI systems"),
      ", ", tags$strong("without any human input"),
      " in composition, writing or recording. These systems analyse vast datasets of existing music to learn patterns (rhythm, harmony, timbre and style) and generate new, original compositions from text prompts or user input."
    ),
    btn_next = "Next",

    badge2          = "Section 1 of 5",
    gaais_h3        = "Attitudes towards Artificial Intelligence",
    gaais_context_intro = "In this section we ask for your views on artificial intelligence broadly, not just AI in music.",
    gaais_context_q     = "What do we mean by Artificial Intelligence?",
    gaais_ai_def        = tagList(
      "By \"artificial intelligence\" we mean ",
      tags$strong("any system capable of performing tasks that would normally require human intelligence"),
      ": from recommendation engines and voice assistants to industrial robots and data analysis tools."
    ),
    gaais_context_scale = "For each statement, indicate to what extent you agree. There are no right or wrong answers.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Section 2 of 5",
    framing_h3  = "AI Policies in Music Streaming Services",
    framing_p1  = "",

    framing_p2  = tagList(
      "The major music streaming services host a growing number of tracks generated entirely or in part by artificial intelligence. Recent data show that AI music in streaming catalogues is already at industrial scale: ",
      tags$strong("more than a third"), " of monthly uploads on Apple Music and around ",
      tags$strong("44%"), " of those on Deezer are generated by artificial intelligence.",
      " Consumption remains marginal, however: ",
      tags$strong("less than 0.5%"), " of streams on Apple Music and ",
      tags$strong("less than 3%"), " on Deezer involve AI music",
      " (Billboard, 2026; Deezer Newsroom, Apr. 2026)."
    ),

    dsp_policy_h    = "How platforms are responding",
    dsp_spotify     = "Voluntary AI label in song credits + 'Verified by Spotify' badge for human-verified profiles; AI-primary artists excluded (Apr. 2026)",
    dsp_apple       = "Voluntary transparency tags for 4 categories: track, artwork, composition, video (Mar. 2026)",
    dsp_deezer      = "Patented AI-detection algorithm; exclusion from algorithmic and editorial playlists (since Jan. 2025)",
    dsp_amazon      = "No specific policy; AI tracks accepted without disclosure requirement",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Algorithmic detection",
    dsp_badge_spotify= "Self-declaration",
    dsp_badge_apple  = "Self-declaration",
    dsp_badge_amazon = "No initiative",

    sq_note     = tagList("For reference: most streaming services today apply no specific AI policy and offer subscriptions at around ", tags$strong("€11.99/month"), "."),

    framing_bridge = "Based on this context, we ask you to express your preferences through a series of choices between differentiated subscription configurations.",
    task_h5     = "How to read the choice cards",
    task_p1     = tagList(
      "On the following pages you will see ", tags$strong("12 hypothetical situations"),
      ". Each presents ", tags$strong("3 alternative subscription configurations"),
      " differing in the following characteristics:"
    ),
    attr_a_lbl    = "AI labelling policy",
    attr_a_desc   = " - How the platform identifies and communicates the presence of AI-generated music to listeners. Where a label is applied, it appears as a visible pill in the listening screen (e.g. «AI Generated Content»).",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("No label:"), " AI tracks are indistinguishable from human tracks.")),
      tags$li(tagList(tags$strong("Voluntary label:"), " the label appears only if declared by the artist or distributor at upload.")),
      tags$li(tagList(tags$strong("Mandatory label:"), " the platform verifies content via a proprietary algorithm and applies the AI label, regardless of what the artist or distributor declares."))
    ),
    attr_b_lbl    = "Promotional structure",
    attr_b_desc   = " - The extent to which AI music is present in algorithmically recommended playlists.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Not included:"), " AI music does not appear in any playlist.")),
      tags$li(tagList(tags$strong("Included:"), " AI music appears in personalised playlists (e.g. Daily Mix) and general ones (e.g. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Included + dedicated section:"), " as per point 2, plus an AI-only section in the app that users can choose to explore.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "e.g. \U0001F446")))
    ),
    attr_c_lbl    = "User control",
    attr_c_desc   = " - The tools available to manage the presence of AI music in your experience.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("No control:"), " no tools are available to filter AI content.")),
      tags$li(tagList(tags$strong("Partial filter:"), " AI music remains available and accessible on the platform, but can be excluded from the user's personalised playlists.")),
      tags$li(tagList(tags$strong("Full filter:"), " total block of AI music across the entire platform.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "e.g. \U0001F446")))
    ),
    attr_d_lbl    = "Monthly price",
    attr_d_desc   = " - The monthly cost of the subscription.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Three possible levels: ", tags$strong("9.99"), " / ", tags$strong("11.99"), " / ", tags$strong("13.99"), " euros per month.")
    ),
    task_p2       = tagList(
      "The 3 alternatives differ in AI policy and price. ",
      tags$strong("Select the configuration you would genuinely prefer to adopt"),
      " by clicking on the corresponding card, then press «Next»."
    ),
    btn_start_cbc = "Start choices",

    cbc_badge = "Section 2 of 5",
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
    aware_q     = "Before this survey, were you aware that your streaming service includes tracks generated entirely by AI?",
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
    ty_contact = "For information about the research:",
    ty_share_h = "Support the research — share the survey",
    ty_share_p = "This research needs at least 100 participants. If you know people who might be interested, feel free to share the link below.",
    ty_share_copy   = "Copy link",
    ty_share_copied = "Copied!",
    ty_share_email  = "Share by e-mail",
    ty_share_wa     = "Share on WhatsApp"
  ),

  # ══════════════════════════════════════════════════════════════════════════
  # FRANCAIS
  # ══════════════════════════════════════════════════════════════════════════
  fr = list(

    decimal_sep = ",",
    per_month   = "/mois",

    audio_ch = c(
      "Sûrement IA"          = "4",
      "Probablement IA"      = "3",
      "Probablement humaine" = "2",
      "Sûrement humaine"     = "1",
      "Je ne sais pas"       = "5"
    ),
    clip_lbl   = "Clip",
    clip_rated = "Évaluée",
    audio_msg  = "Votre navigateur ne prend pas en charge la lecture audio.",

    lik5  = c("Tout à fait en désaccord","En désaccord","Neutre",
              "D'accord","Tout à fait d'accord"),
    lik5p = c("Pas du tout probable","Peu probable","Neutre","Probable","Très probable"),
    freq_opts  = c("Jamais"="never","Quelques fois par mois"="monthly",
                   "Quelques fois par semaine"="weekly","Chaque jour"="daily"),
    aware_opts = c("Oui"="yes","Non"="no","Je n'étais pas sûr(e)"="unsure"),
    dsp_yn     = c("Oui"="yes","Non"="no"),

    A1 = c(
      "Aucun label IA (les titres IA ne sont pas identifiables)",
      "Label IA volontaire (visible uniquement si déclaré par l'artiste)",
      "Label IA obligatoire (vérifié par la plateforme)"
    ),
    A2 = c(
      "Musique IA non incluse dans aucune playlist",
      "Musique IA dans les playlists recommandées et généralistes",
      "Musique IA dans les playlists recommandées + espace IA dédié supplémentaire"
    ),
    A3 = c(
      "Aucun contrôle utilisateur sur la musique IA",
      "Filtre partiel : exclusion de la musique IA des playlists personnalisées",
      "Filtre complet : blocage total de la musique IA sur la plateforme"
    ),

    gaais = c(
      "Je suis intéressé(e) à utiliser des systèmes d'intelligence artificielle dans ma vie quotidienne.",
      "Je trouve l'intelligence artificielle inquiétante.",
      "L'intelligence artificielle pourrait prendre le contrôle des personnes.",
      "Je pense que l'intelligence artificielle est dangereuse.",
      "L'intelligence artificielle peut avoir un impact positif sur le bien-être des personnes.",
      "L'intelligence artificielle est passionnante.",
      "Une grande partie de la société bénéficiera d'un avenir riche en intelligence artificielle.",
      "Je voudrais utiliser l'intelligence artificielle dans mon travail.",
      "Je frissonne d'inconfort en pensant aux utilisations futures de l'intelligence artificielle.",
      "Des personnes comme moi souffriront si l'intelligence artificielle est utilisée de plus en plus."
    ),

    proxy = c(
      "Quand j'écoute de la musique en streaming, je sélectionne la qualité audio la plus élevée disponible.",
      "Je réécoute fréquemment les mêmes titres pour saisir des détails sonores que je n'avais pas remarqués à la première écoute.",
      "J'écoute généralement un titre jusqu'à la fin avant de décider si je l'aime, même quand il ne me convainc pas immédiatement.",
      "J'utilise souvent la fonction de recherche pour trouver des artistes ou des titres spécifiques, plutôt que de me fier aux recommandations de la plateforme.",
      "Je préfère que la musique que j'écoute ait été sélectionnée par une personne plutôt que par un algorithme (p. ex. playlists éditoriales plutôt que Discover Weekly ou Daily Mix).",
      "Si j'étais certain(e) qu'un artiste produit de la musique générée entièrement par l'IA, je le bloquerais sur ma plateforme de streaming."
    ),

    sel_placeholder = "-- Selectionner --",
    age_opts    = c("18-24","25-34","35-44","45-54","55-64","65+"),
    gender_opts = c("Homme"="man","Femme"="woman",
                    "Non-binaire / Troisième genre"="nonbinary",
                    "Préfère ne pas préciser"="no_answer"),
    edu_opts    = c(
      "Brevet des collèges"               = "middle",
      "Baccalauréat / Diplôme de lycée"   = "highschool",
      "Licence (Bac+3)"                   = "bachelor",
      "Master / Diplôme d'ingénieur"      = "master",
      "Doctorat / Post-diplôme"           = "phd"
    ),
    country_opts = c(
      "Italie"="IT",
      "Allemagne"="DE","Argentine"="AR","Australie"="AU","Autriche"="AT","Belgique"="BE",
      "Brésil"="BR","Canada"="CA","Croatie"="HR","Danemark"="DK","Espagne"="ES",
      "États-Unis"="US","Finlande"="FI","France"="FR","Grèce"="GR","Hongrie"="HU",
      "Norvège"="NO","Pays-Bas"="NL","Pologne"="PL","Portugal"="PT","République tchèque"="CZ",
      "Roumanie"="RO","Royaume-Uni"="GB","Suède"="SE","Suisse"="CH",
      "Autre"="OT"
    ),
    dsp_opts  = c("Spotify"="spotify","Apple Music"="apple",
                  "Amazon Music Unlimited"="amazon","YouTube Music"="youtube",
                  "Tidal"="tidal","Deezer"="deezer","Autre"="other"),
    tier_opts = c("Gratuit" = "free", "Payant" = "paid"),

    err_consent  = "Vous devez consentir à participer pour continuer.",
    err_audio    = "Veuillez évaluer les 4 clips avant de continuer.",
    err_gaais    = "Veuillez répondre à tous les items avant de continuer.",
    err_cbc      = "Veuillez sélectionner une option avant de continuer.",
    err_proxy    = "Veuillez répondre à tous les items avant de continuer.",
    err_demo_req = "Veuillez remplir tous les champs démographiques obligatoires (*).",
    err_dsp_user = "Veuillez indiquer si vous utilisez un service de streaming musical.",
    err_dsp_svc  = "Veuillez indiquer le service de streaming que vous utilisez principalement.",
    err_dsp_tier = "Veuillez indiquer votre type d'abonnement.",

    intro_title    = "La musique générée par l'IA dans les services de streaming",
    intro_title2   = "Sondage sur les préférences des consommateurs",
    privacy_head   = "Avis de confidentialité et consentement éclairé",

    intro_salute = "Chère participante, cher participant,",
    intro_body   = "je suis étudiant en Master Management à l'Université de Trente. Je vous invite à participer à ce sondage, élaboré dans le cadre de mon mémoire de master, dont l'objectif est de comprendre les préférences des consommateurs concernant les politiques adoptées par les plateformes de streaming musical en matière de musique générée par l'IA.",

    survey_warn  = "Attention : si possible, évitez de rafraîchir la page ou d'utiliser le bouton Précédent du navigateur pendant le sondage. Une fois le bouton Suivant pressé dans chaque section, vos réponses ne pourront plus être modifiées.",

    what_asked_h = "Ce qu'on vous demandera ?",
    what_asked   = tags$ol(
      tags$li("Indiquer vos opinions generales sur l'intelligence artificielle"),
      tags$li("Effectuer des choix entre differentes configurations d'abonnement a un service de streaming"),
      tags$li("Realiser une courte tache d'ecoute pour evaluer des extraits musicaux"),
      tags$li("Repondre a des questions sur vos habitudes d'ecoute et votre perception de la musique IA"),
      tags$li("Fournir quelques informations demographiques")
    ),

    c_part_lbl = "Participation :",
    c_part     = " Volontaire. Vous êtes libre de vous retirer à tout moment en fermant la page, sans conséquences.",
    c_data_lbl = "Données collectées :",
    c_data     = " Les réponses sont collectées de manière anonyme (aucune donnée identificatrice : nom, e-mail ou adresse IP) et utilisées exclusivement à des fins de recherche académique, présentées sous forme agrégée. Les données sont conservées via Google Sheets pour une durée maximale de 12 mois à compter de la conclusion de l'étude. Le traitement est effectué sur la base de votre consentement, conformément à l'art. 6.1.a du Règlement (UE) 2016/679 (RGPD).",
    c_time_lbl = "Durée estimée :",
    c_time     = " 10-15 minutes.",

    contact_h    = "Pour des informations :",
    contact_info = tagList(
      tags$p("Responsable du traitement : Lorenzo Paravano — lorenzo.paravano@studenti.unitn.it"),
      tags$p("Directeur de thèse : Prof. Diego Giuliani — diego.giuliani@unitn.it")
    ),

    consent_chk = "Je déclare avoir au moins 18 ans et consens à la participation et au traitement de mes données aux fins indiquées.",
    btn_start   = "Commencer",

    badge1        = "Section 3 sur 5",
    audio_h3      = "Tâche de discrimination audio",
    audio_hint      = "\U0001F3A7 Casque ou environnement calme recommandé",
    audio_context_q = "Qu'est-ce que la musique générée par l'IA ?",
    audio_instr   = tagList(
      "Nous vous présentons ", tags$strong("4 courts extraits musicaux"),
      ". Pour chaque piste, veuillez indiquer dans quelle mesure vous pensez qu'elle a été produite par l'intelligence artificielle générative ou par un musicien humain, en utilisant l'échelle à 4 points de ",
      tags$em("Sûrement humaine"), " à ", tags$em("Sûrement IA"),
      ". Si vous n'êtes pas en mesure de formuler un jugement, sélectionnez l'option ", tags$em("'Je ne sais pas'"), "."
    ),
    audio_context = tagList(
      "Dans le cadre de cette étude, la 'musique générée par l'IA' désigne la musique ",
      tags$strong("composée et produite entièrement par des systèmes d'IA générative"),
      ", ", tags$strong("sans aucune contribution humaine"),
      " dans la composition, l'écriture ou l'enregistrement. Ces systèmes analysent de vastes ensembles de musique existante pour en apprendre les patterns (rythme, harmonie, timbre, style) et génèrent de nouvelles compositions originales à partir d'invites textuelles ou d'indications de l'utilisateur."
    ),
    btn_next = "Suivant",

    badge2          = "Section 1 sur 5",
    gaais_h3        = "Attitudes envers l'Intelligence Artificielle",
    gaais_context_intro = "Dans cette section, nous vous demandons vos opinions sur l'intelligence artificielle au sens large, pas uniquement dans le domaine musical.",
    gaais_context_q     = "Qu'entend-on par Intelligence Artificielle ?",
    gaais_ai_def        = tagList(
      "Par \"intelligence artificielle\", nous entendons ",
      tags$strong("tout système capable d'effectuer des tâches qui nécessiteraient normalement l'intelligence humaine"),
      " : systèmes de recommandation, assistants vocaux, robots industriels, logiciels d'analyse de données, et bien d'autres."
    ),
    gaais_context_scale = "Pour chaque affirmation, indiquez dans quelle mesure vous êtes d'accord. Il n'y a pas de bonnes ou de mauvaises réponses.",

    # ── Framing (Section 3) ────────────────────────────────────────────────
    badge3      = "Section 2 sur 5",
    framing_h3  = "Politiques IA dans les services de streaming musical",
    framing_p1  = "",

    framing_p2  = tagList(
      "Les principaux services de streaming musical hébergent un nombre croissant de titres générés entièrement ou en partie par l'intelligence artificielle. Les données les plus récentes montrent que la présence de musique IA dans les catalogues est déjà à l'échelle industrielle : ",
      tags$strong("plus d'un tiers"), " des mises en ligne mensuelles sur Apple Music et environ ",
      tags$strong("44 %"), " de celles sur Deezer sont générées par l'intelligence artificielle.",
      " La consommation reste cependant marginale : ",
      tags$strong("moins de 0,5 %"), " des écoutes sur Apple Music et ",
      tags$strong("moins de 3 %"), " sur Deezer concernent la musique IA",
      " (Billboard, 2026 ; Deezer Newsroom, avr. 2026)."
    ),

    dsp_policy_h    = "Comment les plateformes réagissent",
    dsp_spotify     = "Label IA volontaire dans les crédits + badge « Verified by Spotify » sur les profils humains vérifiés ; artistes principalement IA exclus (avr. 2026)",
    dsp_apple       = "Tags de transparence volontaires pour 4 catégories : titre, artwork, composition, vidéo (mar. 2026)",
    dsp_deezer      = "Algorithme breveté de détection des contenus IA ; exclusion des playlists algorithmiques et éditoriales (depuis janv. 2025)",
    dsp_amazon      = "Aucune politique spécifique ; titres IA acceptés sans obligation de déclaration",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Détection algorithmique",
    dsp_badge_spotify= "Autodéclaration",
    dsp_badge_apple  = "Autodéclaration",
    dsp_badge_amazon = "Aucune initiative",

    sq_note     = tagList("Pour référence : la plupart des services de streaming n'appliquent aujourd'hui aucune politique IA spécifique et proposent des abonnements à environ ", tags$strong("11,99 €/mois"), "."),

    framing_bridge = "Sur la base de ce contexte, nous vous demandons d'exprimer vos préférences à travers une série de choix entre des configurations d'abonnement différenciées.",
    task_h5     = "Comment lire les fiches de choix",
    task_p1     = tagList(
      "Dans les pages suivantes, vous verrez ", tags$strong("12 situations hypothétiques"),
      ". Chacune présente ", tags$strong("3 configurations alternatives d'abonnement"),
      " différant selon les caractéristiques suivantes :"
    ),
    attr_a_lbl    = "Politique de label IA",
    attr_a_desc   = " - Comment la plateforme identifie et communique aux auditeurs la présence de musique IA. Lorsqu'un label est appliqué, il apparaît comme une pill visible dans l'écran d'écoute (ex. «AI Generated Content»).",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Aucun label :"), " les titres IA ne sont pas distinguables des titres humains.")),
      tags$li(tagList(tags$strong("Label volontaire :"), " l'étiquette n'apparaît que si elle est déclarée par l'artiste ou le distributeur lors du téléchargement.")),
      tags$li(tagList(tags$strong("Label obligatoire :"), " la plateforme vérifie les contenus via un algorithme propriétaire et applique le label IA, indépendamment de ce que déclare l'artiste ou le distributeur."))
    ),
    attr_b_lbl    = "Structure promotionnelle",
    attr_b_desc   = " - Dans quelle mesure la musique IA est présente dans les playlists recommandées par l'algorithme.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non incluse :"), " la musique IA n'apparaît dans aucune playlist.")),
      tags$li(tagList(tags$strong("Incluse :"), " la musique IA apparaît dans les playlists personnalisées (ex. Daily Mix) et généralistes (ex. New Music Friday, Top Hits).")),
      tags$li(tagList(tags$strong("Incluse + section dédiée :"), " comme au point 2, plus une section IA uniquement dans l'application que l'utilisateur peut choisir d'explorer.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "ex. \U0001F446")))
    ),
    attr_c_lbl    = "Contrôle utilisateur",
    attr_c_desc   = " - Les outils disponibles pour gérer la présence de musique IA dans votre expérience.",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Aucun contrôle :"), " aucun outil n'est disponible pour filtrer les contenus IA.")),
      tags$li(tagList(tags$strong("Filtre partiel :"), " la musique IA reste disponible et accessible sur la plateforme, mais peut être exclue des playlists personnalisées de l'utilisateur.")),
      tags$li(tagList(tags$strong("Filtre complet :"), " blocage total de la musique IA sur l'ensemble de la plateforme.",
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_switch.png", "ex. \U0001F446")))
    ),
    attr_d_lbl    = "Prix mensuel",
    attr_d_desc   = " - Le coût mensuel de l'abonnement.",
    attr_d_levels = tags$p(class = "levels-list",
      tagList("Trois niveaux possibles : ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euros par mois.")
    ),
    task_p2       = tagList(
      "Les 3 alternatives diffèrent par leur politique IA et leur prix. ",
      tags$strong("Sélectionnez la configuration que vous préféreriez réellement adopter"),
      " en cliquant sur la fiche correspondante, puis appuyez sur «Suivant»."
    ),
    btn_start_cbc = "Commencer les choix",

    cbc_badge = "Section 2 sur 5",
    cbc_q     = "Laquelle de ces configurations d'abonnement préféreriez-vous ?",
    cbc_instr = tagList(
      "Les 3 alternatives diffèrent par la politique IA et le prix. ",
      "Sélectionnez la configuration que vous adopteriez réellement."
    ),
    cbc_opt        = "Option",
    cbc_a1lbl      = "Politique de label IA",
    cbc_a2lbl      = "Structure promotionnelle",
    cbc_a3lbl      = "Contrôle utilisateur",
    cbc_instr_cont = "Évaluez cette fiche indépendamment de vos choix précédents.",

    badge4      = "Section 4 sur 5",
    proxy_h3    = "Expériences musicales et perception de l'IA",
    proxy_instr = "Vous trouverez ci-dessous plusieurs affirmations. Nous vous demandons de les lire attentivement et d'indiquer dans quelle mesure vous êtes d'accord ou en désaccord avec chacune d'elles.",
    freq_q      = "À quelle fréquence écoutez-vous de la musique en streaming ?",
    aware_q     = "Avant ce sondage, saviez-vous que votre service de streaming inclut des titres générés entièrement par l'IA ?",
    churn_q     = tagList(
      "Si le service de streaming que vous utilisez n'introduisait aucune ",
      tags$strong("politique de transparence"),
      " sur la musique générée par l'IA au cours des 12 prochains mois, dans quelle mesure seriez-vous enclin(e) à résilier ou changer votre abonnement ?"
    ),

    badge5       = "Section 5 sur 5",
    demo_h3      = "Données démographiques et utilisation des services",
    demo_instr   = "Nous vous rappelons que l'enquête est anonyme. Les informations demandées dans cette section seront utilisées exclusivement à des fins statistiques et présentées sous forme agrégée.",
    age_lbl      = "Tranche d'âge *",
    gender_lbl   = "Genre *",
    country_lbl  = "Pays de résidence *",
    edu_lbl      = "Diplôme le plus élevé obtenu *",
    dsp_h5       = "Utilisation des services de streaming musical",
    dsp_user_q   = "Êtes-vous actuellement abonné(e) à ou utilisez-vous régulièrement un service de streaming musical ? *",
    dsp_svc_lbl  = "Quel service utilisez-vous principalement ? *",
    dsp_tier_lbl = "Type d'abonnement *",
    btn_submit   = "Soumettre les réponses",

    ty_h2      = "Merci de votre participation !",
    ty_lead    = "Vos réponses ont été enregistrées avec succès.",
    ty_close   = "Vous pouvez maintenant fermer cette fenêtre.",
    ty_contact = "Pour des informations sur la recherche :",
    ty_share_h = "Soutenez la recherche — partagez le sondage",
    ty_share_p = "Cette recherche a besoin d'au moins 100 participants. Si vous connaissez des personnes susceptibles d'être intéressées, n'hésitez pas à partager le lien ci-dessous.",
    ty_share_copy   = "Copier le lien",
    ty_share_copied = "Copié !",
    ty_share_email  = "Partager par e-mail",
    ty_share_wa     = "Partager sur WhatsApp"
  )
)
