---
template: scorecard
engagement_id: "{{ENGAGEMENT_ID}}"
address: "{{RAW_ADDRESS}}"
persona: "{{PERSONA}}"
scored_by: scoring-agent
score_date: "{{ISO_DATE}}"
score_version: "1.0"
---

# LOCUS Scorecard — {{ENGAGEMENT_ID}}

**Subject Address:** {{RAW_ADDRESS}}
**Persona:** {{PERSONA}}
**Scored:** {{ISO_DATE}}

---

## Composite LOCUS Score

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   COMPOSITE LOCUS SCORE          [X.X] / 10.0      │
│   Persona-Weighted                                  │
│                                                     │
│   Percentile vs. MSA             [XX]th             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Interpretation:**
- 8.5–10.0 · **Exceptional** — top-tier location, rare competitive advantage
- 7.0–8.4 · **Strong** — above-average across most dimensions
- 5.5–6.9 · **Solid** — competitive, with identifiable gaps
- 4.0–5.4 · **Mixed** — notable strengths offset by meaningful weaknesses
- Below 4.0 · **Challenged** — multiple dimensions underperform for this persona

---

## Dimension Scores

| # | Dimension | Raw Score | Persona Weight | Weighted Score | Confidence |
|---|-----------|-----------|---------------|---------------|-----------|
| D1 | Walkability & Geospatial | /10 | % | | |
| D2 | Food, Drink & Social | /10 | % | | |
| D3 | Recreation & Green Space | /10 | % | | |
| D4 | Daily Errands & Retail | /10 | % | | |
| D5 | Education | /10 | % | | |
| D6 | Transportation & Commute | /10 | % | | |
| D7 | Civic Infrastructure & Safety | /10 | % | | |
| D8 | Neighborhood Trajectory | /10 | % | | |
| D9 | Business Environment | /10 | % | | |
| | **COMPOSITE** | | **100%** | **/10** | |

---

## Dimension Detail

### D1 — Walkability & Geospatial
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Walk Score® | | /10 | 35% |
| Transit Score® | | /10 | 20% |
| Bike Score® | | /10 | 15% |
| Intersection density | | /10 | 20% |
| Sidewalk continuity | | /10 | 10% |
| **D1 Composite** | | **/10** | |

*Key inputs:* Walk Score: ___ · Transit Score: ___ · Bike Score: ___

### D2 — Food, Drink & Social
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Restaurant density (400m) | | /10 | 25% |
| Cuisine diversity | | /10 | 20% |
| Coffee access (400m) | | /10 | 15% |
| Cultural venue access | | /10 | 15% |
| Nightlife & social options | | /10 | 15% |
| Quality signal (avg rating) | | /10 | 10% |
| **D2 Composite** | | **/10** | |

*Key inputs:* Restaurants within 400m: ___ · Cuisine categories: ___ · Avg rating: ___

### D3 — Recreation & Green Space
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Park proximity | | /10 | 30% |
| Green space acreage (800m) | | /10 | 25% |
| Trail/path access | | /10 | 20% |
| Fitness facility access | | /10 | 15% |
| Recreation programming | | /10 | 10% |
| **D3 Composite** | | **/10** | |

*Key inputs:* Parks within 800m: ___ · Green space acres: ___ · Trail access: ___

### D4 — Daily Errands & Retail
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Grocery access | | /10 | 35% |
| Pharmacy access | | /10 | 20% |
| Healthcare access | | /10 | 20% |
| General retail density | | /10 | 15% |
| Banking / financial services | | /10 | 10% |
| **D4 Composite** | | **/10** | |

*Key inputs:* Full-service grocery within 800m: ☐Y ☐N · Pharmacy within 800m: ☐Y ☐N

### D5 — Education
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Elementary school quality | | /10 | 30% |
| Middle school quality | | /10 | 25% |
| High school quality | | /10 | 25% |
| Private/charter access | | /10 | 10% |
| Higher ed proximity | | /10 | 10% |
| **D5 Composite** | | **/10** | |

*Key inputs:* Assigned elementary: ___ (GS: ___/10) · Middle: ___ (GS: ___/10) · High: ___ (GS: ___/10)

> ⚠️ **Fair Housing Note:** School quality scores reflect publicly available ratings. They are not used to characterize neighborhoods or recommend/discourage residence.

### D6 — Transportation & Commute
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Transit access (routes/stops) | | /10 | 30% |
| Commute time to CBD | | /10 | 20% |
| Highway access | | /10 | 15% |
| Parking availability | | /10 | 15% |
| Airport access | | /10 | 10% |
| Bike infrastructure | | /10 | 10% |
| **D6 Composite** | | **/10** | |

### D7 — Civic Infrastructure & Safety
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Crime rate (property) | | /10 | 25% |
| Crime rate (violent) | | /10 | 20% |
| Flood zone risk | | /10 | 20% |
| Air quality (AQI) | | /10 | 15% |
| Noise exposure | | /10 | 10% |
| 311 service responsiveness | | /10 | 10% |
| **D7 Composite** | | **/10** | |

> ⚠️ **Fair Housing Note:** Crime data is presented as objective statistics. No inferences about residents or groups are made or implied.

### D8 — Neighborhood Trajectory
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Population change (5-yr) | | /10 | 20% |
| Income change (5-yr) | | /10 | 20% |
| Home value appreciation | | /10 | 20% |
| Permit/development activity | | /10 | 20% |
| Business formation trend | | /10 | 20% |
| **D8 Composite** | | **/10** | |

### D9 — Business Environment
| Sub-metric | Value | Score | Weight |
|------------|-------|-------|--------|
| Business density (1500m) | | /10 | 30% |
| Anchor tenant presence | | /10 | 20% |
| Retail vacancy signal | | /10 | 20% |
| Employment center proximity | | /10 | 15% |
| Startup / coworking access | | /10 | 15% |
| **D9 Composite** | | **/10** | |

---

## Balance Indicator

```
Dimensions above 7.0:  [list]
Dimensions below 4.0:  [list]
Balance alert:         ☐ Yes  ☐ No
```

*A location with strong composite score but 2+ dimensions below 4.0 warrants explicit client disclosure of dimension-level risk.*

---

## Data Quality Summary

| Dimension | Data Completeness | Confidence | Staleness Flags |
|-----------|------------------|-----------|----------------|
| D1 | | | |
| D2 | | | |
| D3 | | | |
| D4 | | | |
| D5 | | | |
| D6 | | | |
| D7 | | | |
| D8 | | | |
| D9 | | | |

---

## Scoring Notes

*Document any methodology adjustments, missing-data substitutions, or analyst overrides.*

```
[Enter notes here]
```

---

> **AI Disclosure:** This scorecard was generated using AI-assisted analysis of publicly available data. All scores reflect the AI system's interpretation of collected data and should be reviewed by a qualified analyst before use in any commercial or advisory context. LOCUS scores are not appraisals, valuations, or investment recommendations.

---

*LOCUS Framework · BHIL · Scoring methodology: `scoring/scoring-methodology.md` · Rubric: `scoring/scoring-rubric.md`*
