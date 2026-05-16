# AI Music Governance CBC Survey

Multilingual Shiny app for a Choice-Based Conjoint (CBC) survey on AI governance in music streaming platforms — master's thesis project, University of Trento. Published on shinyapps.io - [AI_music_governance_cbc_survey](https://parlor.shinyapps.io/AI_music_governance_cbc_survey/)

## Research Question

> In a context where AI-generated content in music DSP catalogues is structurally irreversible, which AI governance regimes are strategically sustainable for industry operators without eroding consumer willingness to pay?

The data from the survey is used to answer the second research sub-question of the thesis: 
> SQ2: Given differentially configured AI content governance regimes — in terms of labelling policy, promotional structure, and user control level — which alternative configurations produce non-negative WTP relative to the reference policies of major streaming operators, and which consumer segments represent addressable markets for differentiated platform strategies?

## Survey Structure

The survey is administered in **Italian, English, and French** and consists of 7 sections:

| Section | Content |
|---|---|
| 1 | Informed consent |
| 2 | GAAIS-10 Short — general attitudes toward AI (Schepman & Rodway, 2025; Italian validation: Cicero et al., 2025) |
| 3 | CBC framing — scenario description and status quo definition |
| 4 | CBC — 12 choice tasks, 3 alternatives, 4 attributes |
| 5 | Audio discrimination task — 4 clips (2 AI-generated, 2 human; randomised order); D-index computed server-side. Placed *after* the CBC to avoid analytic listening priming WTP for restrictive governance |
| 6 | Proxy items (6 Likert items: 3 sonic-discrimination proxy, 3 AI-resistance proxy) + DSP usage (platform, tier, switching history, AI awareness, churn intent) |
| 7 | Demographics (age, gender, country, role) |

## CBC Design

4 attributes × 3 levels each; **72 valid profiles** out of 81 (1 prohibited pair: A1=L1 + A2=L3; additional constraint: no task may present two alternatives identical on A1, A2, A3 differing only in price). Randomised design generated per-respondent: 3 profiles sampled without replacement from the valid set for each of the 12 tasks.

| Attribute | Level 1 | Level 2 | Level 3 |
|---|---|---|---|
| A1 — AI Labelling | No consumer-facing label | Voluntary label (self-disclosure) | Mandatory label (platform-verified) |
| A2 — AI Promotion | Not included in any playlist | Recommended & general playlists | Playlists + dedicated AI space |
| A3 — User Control | None | Partial filter: opt-out from personalised playlists | Full block: AI tracks removed platform-wide |
| A4 — Monthly Price | €9.99 | €11.99 | €13.99 |

Status quo benchmark: A1=L1, A2=L2, A3=L1, €11.99/month.

## Segmentation: Sonic-Semantic Acceptance Matrix (SSAM)

Respondents are segmented on two axes via median split:

- **X axis — D-index**: sonic discrimination ability — `mean(AI clip ratings) − mean(human clip ratings)`, D ∈ [−3, 3]. D > 0 indicates discrimination ability; D = 0 no discrimination; D < 0 inverted discrimination.
- **Y axis — GAAIS_neg**: semantic resistance to AI (negative subscale of GAAIS-10, reverse-coded).

This yields 4 quadrants:

| | Low GAAIS_neg (indifferent) | High GAAIS_neg (resistant) |
|---|---|---|
| **Low D (unaware)** | I/I — Unaware Indifferent | I/R — Unaware Resistant |
| **High D (discriminating)** | D/I — Discriminating Indifferent | D/R — Discriminating Resistant |

Proxy operationalisation: 3-item sonic-discrimination proxy (→ D-index) and 3-item AI-resistance proxy (→ GAAIS_neg) allow DSP-observable behavioural segmentation without psychometric instruments.

## Analytical Pipeline
| Phase | Content |
|---|---|
| `Phase 0 — Data preparation & instrument validation` | Data preparation, exclusion of invalid responses, Chronbach test of instruments and convegence test of proxy variables. SSAM creation.|
| `Phase 1 — Aggregate Mixed MNL stepwise (H1–H4)` | Stepwise estimation via `apollo`: from fixed MNL - progressive introduction of random parameters and behavioural covariates. WTP estimation, H1-H4 Test.|
| `Phase 2 — Structured SSAM heterogeneity (H5a–H5c, H5a'–H5c')` | **Primary (H5a–H5c):** extended MMNL with continuous moderators `gaais_neg_z×A1/A2/A3` and `D_z×A1/A2/A3`, directional Wald tests. **Exploratory (H5a'–H5c'):** median split → 4 SSAM quadrants; individual posterior part-worths from M_final; extended MMNL with interactions `quadrant×A1/A2/A3` (I/I as reference), LRT vs M_final.|
| `Phase 3 — Robustness checks & supplementary analyses` | AI-trust moderation of A2: `A2×gaais_pos_z`, Wald test. Proxy validation: regression `D ~ proxy-D` and `gaais_neg ~ proxy-GAAIS_neg`; re-estimation of M_final with proxy composites.|
| `Phase 4 — Policy simulation multi-benchmark` | Configuration × benchmark matrix identifying configurations with non-negative net WTP per operator. Exploratory segment level analysis of configuration-benchmark-pair.|
| `Phase 5 — External triangulation: stated vs. revealed` | Correlation individual WTP ↔ `churn_intent` by quadrant.  WTP comparison: `ai_awareness = yes` vs. `no`.Behavioural triangulation. |

## Data Collection

Responses are stored in a private Google Sheet (6 tabs):

| Tab | Content |
|---|---|
| `Respondents` | respondent_id, language, timestamps, completion flag |
| `Demography` | audio ratings, D-index, GAAIS items + subscales (pos/neg), proxy items (P1–P6), churn intent, switching_past, switching_reason, ai_awareness, DSP platform, tier (derived from dsp_user), demographics |
| `Survey_Answers` | choice_1 … choice_12 |
| `Choices` | long format — one row per alternative per task (a1_labeling, a2_promotion, a3_control, a4_price) |
| `Funnel` | one row per navigation event — step-by-step dropout tracking (event, detail, timestamp) |
| `Partial` | three intermediate snapshots for abandonment recovery: **post-CBC** (GAAIS + CBC choices; audio not yet collected), **post-audio** (+ audio ratings + D-index; proxy empty), **post-proxy** (all except demographics). Analysis rule: `slice_max(ts)` per `respondent_id` |

**DSP usage variables**: `dsp_user` distinguishes paid subscribers (`yes`), free-tier users (`yes_free`), and non-users (`no`). `dsp_tier` (`paid`/`free`) is derived server-side from `dsp_user` — not collected as a separate question. `switching_past` and `switching_reason` are collected conditionally on `dsp_user ∈ {yes, yes_free}`.

## Audio Pretest

Before the main survey, a separate Shiny app (`pretest/pretest_app.R`) was used to select the 4 final audio clips, 2 AI-generated and 2 human-made. 20 candidates (10 AI-generated from Suno "Best of" Rock and Pop playlists, 10 human-made from the [mtg-jamendo-dataset](https://github.com/MTG/mtg-jamendo-dataset), made in 2019, were rated by a convenience sample. Clips were selected to maximise discrimination variance while controlling for genre.

| File | Content |
|---|---|
| `pretest/pretest_app.R` | Shiny app used to collect pretest ratings |
| `pretest/analysis_pretest.R` | Analysis script for pretest results |
| `pretest/clips_metadata.csv` | Full list of 20 candidate clips with source and metadata |
| `pretest/clip_stats_results.csv` | Detection rates and discrimination scores per clip |
| `pretest/detection_rate_plot.png` | Visual summary of pretest results |
| `pretest/sample_tracks.R` | Reproducible sampling script (set.seed(57)) |
| `pretest/crop_audio.R` | Audio clip trimming script |
| `pretest/jamendo.py` | Script to query and download candidates from Jamendo API |
| `pretest/style.css` | CSS for the pretest Shiny app |
| `pretest/data/` | Candidate and selected track lists for Jamendo and Suno |

## Repository Structure

```
├── app.R               # Shiny entry point
├── global.R            # Config, CBC design, scoring functions (D-index, GAAIS)
├── server.R            # Server logic
├── ui.R                # UI layout
├── translations.R      # IT / EN / FR text
├── setup_sheets.R      # One-time Google Sheets initialisation
├── www/                # Static assets (CSS, JS, images, audio clips)
└── pretest/            # Clip selection: pretest app, scripts, results
    └── data/           # Candidate and selected track CSVs
```

## Setup

**Credentials (not in repo):**
- `service_account.json` — Google service account key
- `.secrets/` — OAuth token for local development

**First run:**
```r
source("setup_sheets.R")   # creates/verifies the 6 Google Sheets tabs
shiny::runApp()
```

**Deploy to Shinyapps.io:**
```r
rsconnect::deployApp()
```

Audio clips (`www/audio/`) must be provided manually — see `pretest/sample_tracks.R` and `pretest/clips_metadata.csv` for the selection procedure and clip details.

## References

- Schepman, A., & Rodway, P. (2025). *Validation of the Short GAAIS-10.*
- Cicero, L. et al. (2025). *GAAIS: validation in the Italian context.*
- Hensher, D. A., Rose, J. M., & Greene, W. H. (2015). *Applied choice analysis.*
- Bierlaire, M. (2023). *A short introduction to PandasBiogeme.* (apollo R package reference)

---
