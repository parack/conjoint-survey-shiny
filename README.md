# AI Music Governance CBC Survey

Multilingual Shiny app for a Choice-Based Conjoint (CBC) survey on AI governance in music streaming platforms — master's thesis project, University of Trento.

## Research Question

> In a context where AI-generated content in music DSP catalogues is structurally irreversible, which AI governance regimes are strategically sustainable for industry operators without eroding consumer willingness to pay?

## Survey Structure

The survey is administered in **Italian, English, and French** and consists of 7 sections:

| Section | Content |
|---|---|
| 1 | Informed consent |
| 2 | Audio discrimination task (4 clips: 2 AI-generated, 2 human; D-index computed server-side) |
| 3 | GAAIS-10 Short — general attitudes toward AI (Schepman & Rodway, 2025; Italian validation: Cicero et al., 2025) |
| 4 | CBC framing — scenario description and status quo definition |
| 5 | CBC — 12 choice tasks, 3 alternatives, 4 attributes |
| 6 | Proxy items (6 items, 3 subscales) + DSP usage + churn intent |
| 7 | Demographics |

## CBC Design

4 attributes × 3 levels each; 1 prohibited pair (A1=L1 + A2=L3); **72 valid profiles** out of 81; D-optimal design generated with `idefix` (R).

| Attribute | Level 1 | Level 2 | Level 3 |
|---|---|---|---|
| A1 — AI Labelling | No consumer-facing label | Voluntary label (self-disclosure) | Mandatory label (proprietary detection) |
| A2 — AI Promotion | Not in playlists | Recommended & general playlists | Playlists + dedicated AI space |
| A3 — User Control | None | Opt-out from personalised playlists | Full AI track block |
| A4 — Monthly Price | €9.99 | €11.99 | €13.99 |

Status quo: A1=L1, A2=L2, A3=L1, €11.99/month.

## Segmentation: Sonic-Semantic Acceptance Matrix (SSAM)

Respondents are segmented on two axes via median split:

- **X axis — D-index**: sonic discrimination ability (`mean(AI clip ratings) − mean(human clip ratings)`)
- **Y axis — GAAIS_neg**: semantic resistance to AI (negative GAAIS-10 subscale)

This yields 4 quadrants: *Unaware Resistant* (I/R), *Unaware Indifferent* (I/I), *Discriminating Resistant* (D/R), *Discriminating Indifferent* (D/I).

## Analytical Pipeline

1. **Aggregate Mixed MNL** (H1–H4) — random parameters: A1, A2, A3; fixed: A4. WTP estimates with Krinsky-Robb confidence intervals.
2. **Structured heterogeneity** (H5a–H5c) — individual-level posterior part-worths regressed on SSAM quadrant.
3. **Supplementary analyses** — continuous moderators (gaais_neg_z, D), gaais_pos as moderator of A2, proxy-based SSAM replication (multinomial logit).
4. **Scenario analysis** — net WTP for pre-specified governance configurations vs. status quo; lift by SSAM segment; convergent validity via churn_intent.

## Data Collection

Responses are stored in a private Google Sheet (4 tabs):

| Tab | Content |
|---|---|
| `Respondents` | respondent_id, language, timestamps, completion flag |
| `Demography` | audio ratings, D-index, GAAIS items + subscales, proxy items, churn intent, DSP usage, demographics |
| `Survey_Answers` | choice_1 … choice_12 |
| `Choices` | long format — one row per alternative per task (a1, a2, a3, a4) |

## Audio Pretest

Before the main survey, a separate Shiny app (`pretest/pretest_app.R`) was used to select the 4 final audio clips. 20 candidates (10 AI-generated via Suno, 10 human-made via Jamendo) were rated by a convenience sample. Clips were selected to maximise discrimination variance while controlling for genre and production quality.

| File | Content |
|---|---|
| `pretest/pretest_app.R` | Shiny app used to collect pretest ratings |
| `pretest/clips_metadata.csv` | Full list of 20 candidate clips with source and metadata |
| `pretest/clip_stats_results.csv` | Detection rates and discrimination scores per clip |
| `pretest/detection_rate_plot.png` | Visual summary of pretest results |
| `pretest/sample_tracks.R` | Reproducible sampling script (set.seed(57)) |
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
├── pretest/            # Clip selection: pretest app, scripts, results
│   └── data/           # Candidate and selected track CSVs
└── analysis/           # Analysis scripts (Mixed MNL, SSAM, scenario analysis)
```

## Setup

**Credentials (not in repo):**
- `service_account.json` — Google service account key
- `.secrets/` — OAuth token for local development

**First run:**
```r
source("setup_sheets.R")   # creates the 4 Google Sheets tabs
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
- Krinsky, I., & Robb, A. L. (1986). *On approximating the statistical properties of elasticities.*

---

*Master's thesis in Management – Digital Transformation | University of Trento*
