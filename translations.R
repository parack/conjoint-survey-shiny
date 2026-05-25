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
    switching_past_opts = c(
      "Sì, ho cambiato servizio"                = "yes_switched",
      "No, sono sempre sullo stesso servizio"   = "no_same",
      "No, ho iniziato ad abbonarmi di recente" = "no_new"
    ),
    switching_reason_opts = c(
      "Prezzo / offerta più conveniente"                                              = "price",
      "Catalogo musicale (artisti, brani disponibili)"                               = "catalog",
      "Funzionalità della piattaforma (interfaccia, qualità audio, ecc.)"            = "features",
      "Pubblicità invasive"                                                           = "no_ads",
      "Etica della piattaforma (policy, compensi artisti, musica AI)"                = "policy_dissatisfaction",
      "Altro"                                                                        = "other"
    ),
    dsp_yn     = c("No"="no", "Sì, gratuito"="yes_free", "Sì, a pagamento"="yes"),

    ai_tools_q       = "Quali tra queste funzionalità di AI generativa riterrebbe accettabili sulla sua piattaforma ideale di streaming musicale? (Selezioni tutte quelle che ritiene appropriate)",
    ai_tools_opts_html = list(
      HTML("<strong>AI DJ</strong> &mdash; voce AI che commenta e adatta la selezione musicale alle sue indicazioni in tempo reale"),
      HTML("<strong>Playlist da prompt</strong> &mdash; generate descrivendole a parole (es. &laquo;playlist per una sera con amici&raquo;)"),
      HTML("<strong>Remix o cover AI</strong> &mdash; creare versioni alternative di brani esistenti del catalogo"),
      HTML("<strong>Brani originali AI in app</strong> &mdash; creare e condividere musica AI direttamente nella piattaforma"),
      HTML("<span class='ai-tools-none'>Nessuna delle precedenti</span>")
    ),
    ai_tools_opts_val = c("ai_dj", "prompted_playlists", "ai_remix", "ai_generator", "none"),

    A1 = c(
      "<strong>Nessuna</strong>: le tracce AI non sono distinguibili",
      "<strong>Volontaria</strong>: autodichiarazione dell'artista o distributore",
      "<strong>Obbligatoria</strong>: verificata dalla piattaforma tramite algoritmo proprietario"
    ),
    A2 = c(
      "<strong>Non inclusa</strong>: solo tramite ricerca dell'utente",
      "<strong>Inclusa</strong> in playlist e raccomandazioni",
      "<strong>Inclusa + sezione AI dedicata</strong>"
    ),
    A3 = c(
      "<strong>Nessuno</strong>",
      "<strong>Filtro brani AI</strong>",
      "<strong>Filtro brani + funzionalità AI</strong>"
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
      "Preferisco che la musica che ascolto sia stata selezionata da una persona piuttosto che da un algoritmo (es. playlist editoriali rispetto a Discover Weekly o Daily Mix).",
      "Se fossi certo/a che un artista produce musica generata interamente dall'AI, lo bloccherei sulla mia piattaforma di streaming."
    ),

    sel_placeholder = "-- Seleziona --",
    gender_opts = c("Uomo"="man","Donna"="woman",
                    "Non binario / Terzo genere"="nonbinary",
                    "Preferisco non specificare"="no_answer"),
    role_opts   = c(
      "Studente"                                    = "student",
      "Lavoratore dipendente"                       = "employee",
      "Lavoratore autonomo / Libero professionista" = "self_employed",
      "In cerca di occupazione"                     = "unemployed",
      "Pensionato/a"                                = "retired",
      "Altro"                                       = "other"
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
    err_dsp_tier         = "Indichi il tipo di abbonamento.",
    err_switching_past   = "Indichi il suo comportamento di switching negli ultimi 24 mesi.",
    err_switching_reason = "Indichi il motivo principale del cambio.",

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
      "I principali servizi di streaming musicale ospitano un numero crescente di brani generati dall'intelligenza artificiale: ",
      tags$strong("oltre un terzo"), " degli upload mensili su Apple Music e circa il ",
      tags$strong("44%"), " su Deezer sono AI. Il consumo degli stessi rimane tuttavia marginale: ",
      tags$strong("meno dello 0,5%"), " degli stream su Apple Music e ",
      tags$strong("meno del 3%"), " su Deezer ",
      tags$span(class = "info-pill", "Billboard, 2026"),
      tags$span(class = "info-pill", "Deezer Newsroom, apr. 2026"),
      "."
    ),

    dsp_policy_h    = tagList("Come si stanno muovendo le piattaforme ", tags$span(class = "info-pill", "giugno 2026")),
    dsp_spotify     = "Label AI volontaria dichiarata dall'artista; badge 'Verified by Spotify' sui profili umani verificati; creazione di cover e remix AI a partire da brani del catalogo",
    dsp_apple       = "Tag di trasparenza volontari per 4 categorie: traccia, artwork, composizione, video",
    dsp_deezer      = "Rilevazione algoritmica; tag espliciti su tracce/album; esclusione da playlist algoritmiche ed editoriali; tutela attiva dei diritti d'autore e delle royalties degli artisti",
    dsp_amazon      = "Nessuna policy specifica; brani AI accettati senza obbligo di disclosure",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Rilevazione algoritmica",
    dsp_badge_spotify= "Autodichiarazione",
    dsp_badge_apple  = "Autodichiarazione",
    dsp_badge_amazon = "Nessuna iniziativa",

    framing_bridge = "A partire da questo contesto, Le chiediamo di esprimere le Sue preferenze attraverso una serie di scelte tra configurazioni di abbonamento differenziate.",
    task_h5     = "Come leggere le schede di scelta",
    task_p1     = HTML("Nelle pagine seguenti Le verranno presentate <strong>12 situazioni ipotetiche</strong>. In ciascuna sono proposte <strong>3 configurazioni alternative di abbonamento</strong>, che si differenziano per le seguenti caratteristiche:"),
    attr_a_lbl    = "Policy di labeling AI",
    attr_a_desc   = " - Come la piattaforma comunica la presenza di musica AI all'utente.",
    attr_a_pill   = "es. etichetta AI \U0001F446",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Nessuna:"), " le tracce AI non sono distinguibili.")),
      tags$li(tagList(tags$strong("Volontaria:"), " autodichiarazione dell'artista o distributore.")),
      tags$li(tagList(tags$strong("Obbligatoria:"), " verificata dalla piattaforma tramite algoritmo proprietario."))
    ),
    attr_b_lbl    = "Struttura promozionale",
    attr_b_desc   = " - In che misura la musica AI compare nell'esperienza utente.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non inclusa:"), " solo tramite ricerca dell'utente.")),
      tags$li(tagList(tags$strong("Inclusa nelle raccomandazioni:"), " playlist, radio, brani simili, code automatiche.")),
      tags$li(tagList(tags$strong("Inclusa + sezione AI dedicata."),
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "es. sezione AI \U0001F446")))
    ),
    attr_c_lbl    = "Controllo utente",
    attr_c_desc   = " - Strumenti per gestire la presenza di musica AI e l'uso delle funzionalità AI generative.",
    attr_c_pill   = "es. filtri AI \U0001F446",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tags$strong("Nessuno.")),
      tags$li(tagList(tags$strong("Filtro brani AI:"), " l'utente può escludere la musica AI dall'esperienza di ascolto.")),
      tags$li(tagList(tags$strong("Filtro completo:"), " include il filtro brani + disattivazione delle funzionalità AI generative (es. AI DJ, playlist da prompt, remix AI)."))
    ),
    attr_d_lbl    = "Prezzo mensile",
    attr_d_desc   = HTML(" - Il costo mensile dell'abbonamento. <em>Per riferimento, oggi la maggior parte dei servizi offre abbonamenti individuali a circa <strong>11,99 &euro;/mese</strong>.</em>"),
    attr_d_levels = tags$ul(class = "levels-list",
      tags$li(tagList("Tre livelli possibili: ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euro al mese."))
    ),
    task_p2       = "",
    btn_start_cbc = "Inizia le scelte",

    cbc_badge = "Sezione 2 di 5",
    cbc_q     = "Quale di queste configurazioni di abbonamento preferirebbe?",
    cbc_instr = HTML("Le 3 alternative presentate di seguito differiscono per policy AI e prezzo. <strong>Selezioni la configurazione che preferirebbe realmente adottare</strong> cliccando sulla scheda corrispondente, poi prema «Avanti»."),
    cbc_opt        = "Opzione",
    cbc_a1lbl      = "Policy labeling AI",
    cbc_a2lbl      = "Struttura promozionale",
    cbc_a3lbl      = "Controllo utente",
    cbc_instr_cont = "Valuti questa scheda indipendentemente dalle scelte effettuate in precedenza.",

    badge4      = "Sezione 4 di 5",   # proxy: rimane sezione 4
    proxy_h3    = "Esperienze musicali e percezione dell'AI",
    proxy_instr = "Di seguito sono elencate alcune affermazioni. Le chiediamo di leggerle attentamente e di indicare quanto è d'accordo o in disaccordo con ciascuna di esse.",
    switching_past_q   = "Negli ultimi 24 mesi ha cambiato piattaforma o modificato il piano di abbonamento?",
    switching_reason_q = "Per quale motivo principale?",
    churn_q     = tagList(
      "Se il servizio di streaming che utilizza non introducesse ",
      tags$strong("ulteriori politiche di trasparenza"),
      " sulla musica generata dall'AI nei prossimi 12 mesi, quanto sarebbe propenso/a a cancellare o cambiare abbonamento?"
    ),

    badge5       = "Sezione 5 di 5",
    demo_h3      = "Dati demografici e utilizzo dei servizi",
    demo_instr   = "Le ricordiamo che l'indagine è anonima. Le informazioni richieste in questa sezione saranno utilizzate esclusivamente per finalità statistiche e presentate in forma aggregata.",
    year_birth_lbl         = "Anno di nascita *",
    year_birth_placeholder = "es. 1995",
    year_birth_hint        = "Anno valido: 1940–2010",
    err_year_birth         = "Indichi un anno di nascita valido (tra 1940 e 2010).",
    gender_lbl   = "Genere *",
    country_lbl  = "Paese di residenza *",
    role_lbl     = "Ruolo attuale *",
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
    ty_share_wa    = "Condividi su WhatsApp",
    feedback_h           = "Problemi riscontrati o feedback? (opzionale)",
    feedback_placeholder = "Bug, difficoltà di compilazione, suggerimenti...",
    feedback_btn         = "Invia",
    feedback_sent        = "Grazie per il Suo feedback!"
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
    switching_past_opts = c(
      "Yes, I switched service"                  = "yes_switched",
      "No, I've always been on the same service" = "no_same",
      "No, I've recently started subscribing"    = "no_new"
    ),
    switching_reason_opts = c(
      "Price / better offer"                                          = "price",
      "Music catalog (available artists, tracks)"                     = "catalog",
      "Platform features (interface, audio quality, etc.)"            = "features",
      "Intrusive advertising"                                         = "no_ads",
      "Platform ethics (policies, artist payouts, AI music)"          = "policy_dissatisfaction",
      "Other"                                                         = "other"
    ),
    dsp_yn     = c("No"="no", "Yes, free"="yes_free", "Yes, paid"="yes"),

    ai_tools_q       = "Which of these generative AI features would you consider acceptable on your ideal music streaming platform? (Select all that apply)",
    ai_tools_opts_html = list(
      HTML("<strong>AI DJ</strong> &mdash; AI voice that comments on and adapts the music selection to your real-time directions"),
      HTML("<strong>Prompted playlists</strong> &mdash; generated by describing them in words (e.g. &laquo;a playlist for an evening with friends&raquo;)"),
      HTML("<strong>AI remix or cover</strong> &mdash; create alternative versions of existing tracks in the catalogue"),
      HTML("<strong>Original AI tracks in-app</strong> &mdash; create and share personal AI music directly on the platform"),
      HTML("<span class='ai-tools-none'>None of the above</span>")
    ),
    ai_tools_opts_val = c("ai_dj", "prompted_playlists", "ai_remix", "ai_generator", "none"),

    A1 = c(
      "<strong>None</strong>: AI tracks are indistinguishable",
      "<strong>Voluntary</strong>: self-declaration by the artist or distributor",
      "<strong>Mandatory</strong>: verified by the platform via a proprietary algorithm"
    ),
    A2 = c(
      "<strong>Not included</strong>: only via user search",
      "<strong>Included</strong> in playlists and recommendations",
      "<strong>Included + dedicated AI section</strong>"
    ),
    A3 = c(
      "<strong>None</strong>",
      "<strong>AI tracks filter</strong>",
      "<strong>AI tracks + features filter</strong>"
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
      "I prefer that the music I listen to has been selected by a person rather than an algorithm (e.g. editorial playlists over Discover Weekly or Daily Mix).",
      "If I were certain that an artist produces music generated entirely by AI, I would block them on my streaming platform."
    ),

    sel_placeholder = "-- Select --",
    gender_opts = c("Man"="man","Woman"="woman",
                    "Non-binary / Third gender"="nonbinary",
                    "Prefer not to say"="no_answer"),
    role_opts   = c(
      "Student"                    = "student",
      "Employee"                   = "employee",
      "Self-employed / Freelancer" = "self_employed",
      "Looking for work"           = "unemployed",
      "Retired"                    = "retired",
      "Other"                      = "other"
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
    err_dsp_tier         = "Please indicate your subscription type.",
    err_switching_past   = "Please indicate your switching behaviour in the last 24 months.",
    err_switching_reason = "Please indicate the main reason for switching.",

    intro_title    = "AI-Generated Music in Streaming Services",
    intro_title2   = "A Survey on Consumer Preferences",
    privacy_head   = "Privacy notice and informed consent",

    intro_salute = "Dear participant,",
    intro_body   = "I am a Master's student in Management at the University of Trento. I am inviting you to take part in this survey, developed as part of my Master's thesis, which aims to understand consumer preferences regarding the policies adopted by music streaming platforms in relation to AI-generated music.",

    survey_warn  = "Please note: if possible, avoid refreshing the page or using the browser's Back button during the survey. Once you press Next in each section, your answers cannot be changed.",

    what_asked_h = "What will be asked of you:",
    what_asked   = tagList(
      tags$p("The survey is organised into 5 sections in which you will be asked to:"),
      tags$ol(
        tags$li("Share your general views on artificial intelligence;"),
        tags$li("Make choices among different music streaming subscription offers;"),
        tags$li("Complete a brief listening task to evaluate music clips;"),
        tags$li("Answer questions concerning your listening habits and perception of AI-generated music;"),
        tags$li("Provide some demographic information.")
      )
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
      "Major music streaming services host a growing number of tracks generated by artificial intelligence: ",
      tags$strong("more than a third"), " of monthly uploads on Apple Music and around ",
      tags$strong("44%"), " on Deezer are AI. Consumption nonetheless remains marginal: ",
      tags$strong("less than 0.5%"), " of streams on Apple Music and ",
      tags$strong("less than 3%"), " on Deezer ",
      tags$span(class = "info-pill", "Billboard, 2026"),
      tags$span(class = "info-pill", "Deezer Newsroom, Apr. 2026"),
      "."
    ),

    dsp_policy_h    = tagList("How platforms are responding ", tags$span(class = "info-pill", "June 2026")),
    dsp_spotify     = "Voluntary AI label declared by the artist; 'Verified by Spotify' badge on human-verified profiles; AI cover and remix creation from existing catalogue tracks",
    dsp_apple       = "Voluntary transparency tags for 4 categories: track, artwork, composition, video",
    dsp_deezer      = "Algorithmic detection; explicit tags on tracks/albums; exclusion from algorithmic and editorial playlists; active protection of artists' copyright and royalties",
    dsp_amazon      = "No specific policy; AI tracks accepted without disclosure requirement",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Algorithmic detection",
    dsp_badge_spotify= "Self-declaration",
    dsp_badge_apple  = "Self-declaration",
    dsp_badge_amazon = "No initiative",

    framing_bridge = "Based on this context, we ask you to express your preferences through a series of choices between differentiated subscription configurations.",
    task_h5     = "How to read the choice cards",
    task_p1     = HTML("On the following pages you will see <strong>12 hypothetical situations</strong>. Each presents <strong>3 alternative subscription configurations</strong> differing in the following characteristics:"),
    attr_a_lbl    = "AI labelling policy",
    attr_a_desc   = " - How the platform communicates the presence of AI music to users.",
    attr_a_pill   = "e.g. AI label \U0001F446",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("None:"), " AI tracks are indistinguishable.")),
      tags$li(tagList(tags$strong("Voluntary:"), " self-declaration by the artist or distributor.")),
      tags$li(tagList(tags$strong("Mandatory:"), " verified by the platform via a proprietary algorithm."))
    ),
    attr_b_lbl    = "Promotional structure",
    attr_b_desc   = " - The extent to which AI music appears in the user experience.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Not included:"), " only via user search.")),
      tags$li(tagList(tags$strong("Included in recommendations:"), " playlists, radio, similar tracks, automated queues.")),
      tags$li(tagList(tags$strong("Included + dedicated AI section."),
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "e.g. AI section \U0001F446")))
    ),
    attr_c_lbl    = "User control",
    attr_c_desc   = " - Tools to manage the presence of AI music and the use of generative AI features.",
    attr_c_pill   = "e.g. AI filters \U0001F446",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tags$strong("None.")),
      tags$li(tagList(tags$strong("AI tracks filter:"), " users can exclude AI music from their listening experience.")),
      tags$li(tagList(tags$strong("Full filter:"), " includes the tracks filter + disabling of generative AI features (e.g. AI DJ, prompted playlists, AI remixes)."))
    ),
    attr_d_lbl    = "Monthly price",
    attr_d_desc   = HTML(" - The monthly cost of the subscription. <em>For reference, most services today offer individual subscriptions at around <strong>&euro;11.99/month</strong>.</em>"),
    attr_d_levels = tags$ul(class = "levels-list",
      tags$li(tagList("Three possible levels: ", tags$strong("9.99"), " / ", tags$strong("11.99"), " / ", tags$strong("13.99"), " euros per month."))
    ),
    task_p2       = "",
    btn_start_cbc = "Start choices",

    cbc_badge = "Section 2 of 5",
    cbc_q     = "Which of these subscription configurations would you prefer?",
    cbc_instr = HTML("The 3 alternatives presented below differ in AI policy and price. <strong>Select the configuration you would genuinely prefer to adopt</strong> by clicking the corresponding card, then press «Next»."),
    cbc_opt        = "Option",
    cbc_a1lbl      = "AI labelling policy",
    cbc_a2lbl      = "Promotional structure",
    cbc_a3lbl      = "User control",
    cbc_instr_cont = "Evaluate this card independently of your previous choices.",

    badge4      = "Section 4 of 5",
    proxy_h3    = "Music experiences and AI perception",
    proxy_instr = "Below are a number of statements. Please read each one carefully and indicate how much you agree or disagree with each of them.",
    switching_past_q   = "In the last 24 months, have you switched platform or changed your subscription plan?",
    switching_reason_q = "What was the main reason?",
    churn_q     = tagList(
      "If the streaming service you use were to introduce ",
      tags$strong("no additional transparency policy"),
      " on AI-generated music over the next 12 months, how likely would you be to cancel or switch your subscription?"
    ),

    badge5       = "Section 5 of 5",
    demo_h3      = "Demographics and service usage",
    demo_instr   = "Please note that this survey is anonymous. The information requested in this section will be used exclusively for statistical purposes and presented in aggregated form.",
    year_birth_lbl         = "Year of birth *",
    year_birth_placeholder = "e.g. 1995",
    year_birth_hint        = "Valid year: 1940–2010",
    err_year_birth         = "Please indicate a valid year of birth (between 1940 and 2010).",
    gender_lbl   = "Gender *",
    country_lbl  = "Country of residence *",
    role_lbl     = "Current role *",
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
    ty_share_wa     = "Share on WhatsApp",
    feedback_h           = "Issues or feedback? (optional)",
    feedback_placeholder = "Bugs, completion difficulties, suggestions...",
    feedback_btn         = "Send",
    feedback_sent        = "Thanks for your feedback!"
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
    switching_past_opts = c(
      "Oui, j'ai changé de service"                    = "yes_switched",
      "Non, je suis toujours sur le même service"      = "no_same",
      "Non, je viens de commencer à m'abonner"         = "no_new"
    ),
    switching_reason_opts = c(
      "Prix / meilleure offre"                                                          = "price",
      "Catalogue musical (artistes, titres disponibles)"                               = "catalog",
      "Fonctionnalités de la plateforme (interface, qualité audio, etc.)"              = "features",
      "Publicités invasives"                                                            = "no_ads",
      "Éthique de la plateforme (politiques, rémunération des artistes, musique IA)"  = "policy_dissatisfaction",
      "Autre"                                                                          = "other"
    ),
    dsp_yn     = c("Non"="no", "Oui, gratuit"="yes_free", "Oui, payant"="yes"),

    ai_tools_q       = "Lesquelles de ces fonctionnalités d'IA générative jugeriez-vous acceptables sur votre plateforme idéale de streaming musical ? (Sélectionnez toutes celles qui s'appliquent)",
    ai_tools_opts_html = list(
      HTML("<strong>AI DJ</strong> &mdash; voix IA qui commente et adapte la sélection musicale à vos indications en temps réel"),
      HTML("<strong>Playlists par prompt</strong> &mdash; générées en les décrivant par des mots (ex. &laquo;une playlist pour une soirée entre amis&raquo;)"),
      HTML("<strong>Remix ou cover IA</strong> &mdash; créer des versions alternatives de titres existants du catalogue"),
      HTML("<strong>Titres originaux IA dans l'app</strong> &mdash; créer et partager de la musique IA personnelle directement sur la plateforme"),
      HTML("<span class='ai-tools-none'>Aucune des précédentes</span>")
    ),
    ai_tools_opts_val = c("ai_dj", "prompted_playlists", "ai_remix", "ai_generator", "none"),

    A1 = c(
      "<strong>Aucun</strong> : les titres IA ne sont pas distinguables",
      "<strong>Volontaire</strong> : autodéclaration de l'artiste ou du distributeur",
      "<strong>Obligatoire</strong> : vérifiée par la plateforme via un algorithme propriétaire"
    ),
    A2 = c(
      "<strong>Non incluse</strong> : uniquement via la recherche",
      "<strong>Incluse</strong> dans les playlists et recommandations",
      "<strong>Incluse + section IA dédiée</strong>"
    ),
    A3 = c(
      "<strong>Aucun</strong>",
      "<strong>Filtre titres IA</strong>",
      "<strong>Filtre titres + fonctionnalités IA</strong>"
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
      "Je préfère que la musique que j'écoute ait été sélectionnée par une personne plutôt que par un algorithme (p. ex. playlists éditoriales plutôt que Discover Weekly ou Daily Mix).",
      "Si j'étais certain(e) qu'un artiste produit de la musique générée entièrement par l'IA, je le bloquerais sur ma plateforme de streaming."
    ),

    sel_placeholder = "-- Sélectionner --",
    gender_opts = c("Homme"="man","Femme"="woman",
                    "Non-binaire / Troisième genre"="nonbinary",
                    "Préfère ne pas préciser"="no_answer"),
    role_opts   = c(
      "Étudiant·e"                           = "student",
      "Salarié·e"                            = "employee",
      "Travailleur·se indépendant·e"         = "self_employed",
      "En recherche d'emploi"                = "unemployed",
      "Retraité·e"                           = "retired",
      "Autre"                                = "other"
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
    err_dsp_tier         = "Veuillez indiquer votre type d'abonnement.",
    err_switching_past   = "Veuillez indiquer votre comportement de changement au cours des 24 derniers mois.",
    err_switching_reason = "Veuillez indiquer la raison principale du changement.",

    intro_title    = "La musique générée par l'IA dans les services de streaming",
    intro_title2   = "Sondage sur les préférences des consommateurs",
    privacy_head   = "Avis de confidentialité et consentement éclairé",

    intro_salute = "Chère participante, cher participant,",
    intro_body   = "je suis étudiant en Master Management à l'Université de Trente. Je vous invite à participer à ce sondage, élaboré dans le cadre de mon mémoire de master, dont l'objectif est de comprendre les préférences des consommateurs concernant les politiques adoptées par les plateformes de streaming musical en matière de musique générée par l'IA.",

    survey_warn  = "Attention : si possible, évitez de rafraîchir la page ou d'utiliser le bouton Précédent du navigateur pendant le sondage. Une fois le bouton Suivant pressé dans chaque section, vos réponses ne pourront plus être modifiées.",

    what_asked_h = "Ce qu'il vous sera demandé :",
    what_asked   = tagList(
      tags$p("Le questionnaire est divisé en 5 sections dans lesquelles il vous sera demandé de :"),
      tags$ol(
        tags$li("Donner votre opinion générale sur l'intelligence artificielle ;"),
        tags$li("Effectuer des choix entre différentes offres d'abonnement à des services de streaming musical ;"),
        tags$li("Réaliser une courte tâche d'écoute afin d'évaluer des extraits musicaux ;"),
        tags$li("Répondre à des questions concernant vos habitudes d'écoute et votre perception de la musique générée par IA ;"),
        tags$li("Fournir quelques informations démographiques.")
      )
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
      "Les principaux services de streaming musical hébergent un nombre croissant de titres générés par l'intelligence artificielle : ",
      tags$strong("plus d'un tiers"), " des mises en ligne mensuelles sur Apple Music et environ ",
      tags$strong("44 %"), " sur Deezer sont IA. La consommation reste cependant marginale : ",
      tags$strong("moins de 0,5 %"), " des écoutes sur Apple Music et ",
      tags$strong("moins de 3 %"), " sur Deezer ",
      tags$span(class = "info-pill", "Billboard, 2026"),
      tags$span(class = "info-pill", "Deezer Newsroom, avr. 2026"),
      "."
    ),

    dsp_policy_h    = tagList("Comment les plateformes réagissent ", tags$span(class = "info-pill", "juin 2026")),
    dsp_spotify     = "Label IA volontaire déclaré par l'artiste ; badge « Verified by Spotify » sur les profils humains vérifiés ; création de covers et remix IA à partir de titres du catalogue",
    dsp_apple       = "Tags de transparence volontaires pour 4 catégories : titre, artwork, composition, vidéo",
    dsp_deezer      = "Détection algorithmique ; étiquettes explicites sur titres/albums ; exclusion des playlists algorithmiques et éditoriales ; protection active des droits d'auteur et des revenus des artistes",
    dsp_amazon      = "Aucune politique spécifique ; titres IA acceptés sans obligation de déclaration",
    dsp_policy_note  = "",
    dsp_badge_deezer = "Détection algorithmique",
    dsp_badge_spotify= "Autodéclaration",
    dsp_badge_apple  = "Autodéclaration",
    dsp_badge_amazon = "Aucune initiative",

    framing_bridge = "Sur la base de ce contexte, nous vous demandons d'exprimer vos préférences à travers une série de choix entre des configurations d'abonnement différenciées.",
    task_h5     = "Comment lire les fiches de choix",
    task_p1     = HTML("Dans les pages suivantes, vous verrez <strong>12 situations hypothétiques</strong>. Chacune présente <strong>3 configurations alternatives d'abonnement</strong> différant selon les caractéristiques suivantes :"),
    attr_a_lbl    = "Politique de label IA",
    attr_a_desc   = " - Comment la plateforme communique la présence de musique IA à l'utilisateur.",
    attr_a_pill   = "ex. label IA \U0001F446",
    attr_a_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Aucun :"), " les titres IA ne sont pas distinguables.")),
      tags$li(tagList(tags$strong("Volontaire :"), " autodéclaration de l'artiste ou du distributeur.")),
      tags$li(tagList(tags$strong("Obligatoire :"), " vérifiée par la plateforme via un algorithme propriétaire."))
    ),
    attr_b_lbl    = "Structure promotionnelle",
    attr_b_desc   = " - Dans quelle mesure la musique IA apparaît dans l'expérience utilisateur.",
    attr_b_levels = tags$ul(class = "levels-list",
      tags$li(tagList(tags$strong("Non incluse :"), " uniquement via la recherche.")),
      tags$li(tagList(tags$strong("Incluse dans les recommandations :"), " playlists, radio, titres similaires, files d'attente automatiques.")),
      tags$li(tagList(tags$strong("Incluse + section IA dédiée."),
        tags$button(type = "button", class = "btn-popover-img", style = "font-size:0.85rem;", `data-img` = "ai_section_ui.png", "ex. section IA \U0001F446")))
    ),
    attr_c_lbl    = "Contrôle utilisateur",
    attr_c_desc   = " - Outils pour gérer la présence de musique IA et l'usage des fonctionnalités IA génératives.",
    attr_c_pill   = "ex. filtres IA \U0001F446",
    attr_c_levels = tags$ul(class = "levels-list",
      tags$li(tags$strong("Aucun.")),
      tags$li(tagList(tags$strong("Filtre titres IA :"), " l'utilisateur peut exclure la musique IA de son expérience d'écoute.")),
      tags$li(tagList(tags$strong("Filtre complet :"), " inclut le filtre titres + désactivation des fonctionnalités IA génératives (ex. AI DJ, playlists par prompt, remix IA)."))
    ),
    attr_d_lbl    = "Prix mensuel",
    attr_d_desc   = HTML(" - Le coût mensuel de l'abonnement. <em>Pour référence, la plupart des services proposent aujourd'hui des abonnements individuels à environ <strong>11,99 &euro;/mois</strong>.</em>"),
    attr_d_levels = tags$ul(class = "levels-list",
      tags$li(tagList("Trois niveaux possibles : ", tags$strong("9,99"), " / ", tags$strong("11,99"), " / ", tags$strong("13,99"), " euros par mois."))
    ),
    task_p2       = "",
    btn_start_cbc = "Commencer les choix",

    cbc_badge = "Section 2 sur 5",
    cbc_q     = "Laquelle de ces configurations d'abonnement préféreriez-vous ?",
    cbc_instr = HTML("Les 3 alternatives présentées ci-dessous diffèrent par la politique IA et le prix. <strong>Sélectionnez la configuration que vous préféreriez réellement adopter</strong> en cliquant sur la fiche correspondante, puis appuyez sur «Suivant»."),
    cbc_opt        = "Option",
    cbc_a1lbl      = "Politique de label IA",
    cbc_a2lbl      = "Structure promotionnelle",
    cbc_a3lbl      = "Contrôle utilisateur",
    cbc_instr_cont = "Évaluez cette fiche indépendamment de vos choix précédents.",

    badge4      = "Section 4 sur 5",
    proxy_h3    = "Expériences musicales et perception de l'IA",
    proxy_instr = "Vous trouverez ci-dessous plusieurs affirmations. Nous vous demandons de les lire attentivement et d'indiquer dans quelle mesure vous êtes d'accord ou en désaccord avec chacune d'elles.",
    switching_past_q   = "Au cours des 24 derniers mois, avez-vous changé de plateforme ou modifié votre abonnement ?",
    switching_reason_q = "Quelle a été la raison principale ?",
    churn_q     = tagList(
      "Si le service de streaming que vous utilisez n'introduisait pas de ",
      tags$strong("politique de transparence supplémentaire"),
      " sur la musique générée par l'IA au cours des 12 prochains mois, dans quelle mesure seriez-vous enclin(e) à résilier ou changer votre abonnement ?"
    ),

    badge5       = "Section 5 sur 5",
    demo_h3      = "Données démographiques et utilisation des services",
    demo_instr   = "Nous vous rappelons que l'enquête est anonyme. Les informations demandées dans cette section seront utilisées exclusivement à des fins statistiques et présentées sous forme agrégée.",
    year_birth_lbl         = "Année de naissance *",
    year_birth_placeholder = "ex. 1995",
    year_birth_hint        = "Année valide : 1940–2010",
    err_year_birth         = "Veuillez indiquer une année de naissance valide (entre 1940 et 2010).",
    gender_lbl   = "Genre *",
    country_lbl  = "Pays de résidence *",
    role_lbl     = "Statut professionnel actuel *",
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
    ty_share_wa     = "Partager sur WhatsApp",
    feedback_h           = "Problèmes ou retour d'expérience ? (facultatif)",
    feedback_placeholder = "Bugs, difficultés de complétion, suggestions...",
    feedback_btn         = "Envoyer",
    feedback_sent        = "Merci pour votre retour !"
  )
)
