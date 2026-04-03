---
document: data-currency
version: "1.0"
---

# Data Currency & Validity Windows

**Purpose:** Define how fresh data must be before it can be used in a LOCUS engagement without a staleness flag. Used by `check-citations.sh` and the scoring-agent's confidence assessment.

---

## Why Data Currency Matters

Location intelligence degrades over time. A restaurant rated 4.2 stars may have closed. A school that scored 8/10 three years ago may have changed leadership. A neighborhood that was appreciating in 2021 may have plateaued. The LOCUS Framework enforces data currency to protect the integrity of client deliverables.

---

## Validity Windows by Data Type

### Government / Regulatory Data

| Source | Data Type | Validity Window | Staleness Flag | Notes |
|--------|-----------|----------------|----------------|-------|
| U.S. Census ACS (5-yr) | Population, income, home values | 3 years from survey end year | ⚠️ if >3 years old | ACS 5-yr releases annually; use most recent |
| U.S. Census ACS (1-yr) | Same variables, less precise | 18 months | ⚠️ if >18 months | Only for areas ≥65k pop |
| Census Building Permits | Permit activity | 18 months | ⚠️ if >18 months | Monthly release; use most recent 12-month total |
| FBI UCR / Crime Data Explorer | Crime rates | 2 years | ⚠️ if >2 years | FBI CDE updates annually; 2021 methodology change |
| FEMA NFHL | Flood zone | 5 years | ⚠️ if >5 years | FEMA updates maps on rolling basis; check LOMC |
| EPA AirNow | Current AQI | 24 hours (real-time) | ⚠️ immediately | For annual average: 2 years |
| EPA Air Data | Annual AQI average | 2 years | ⚠️ if >2 years | Download annual summary files |
| NCES Common Core | School enrollment | 3 years | ⚠️ if >3 years | School year data, released ~18 mo. after year end |

---

### Commercial / Freemium Data

| Source | Data Type | Validity Window | Staleness Flag | Notes |
|--------|-----------|----------------|----------------|-------|
| Walk Score® | Walk/Transit/Bike Score | 1 year | ⚠️ if >1 year | Scores update as OSM updates |
| GreatSchools | School ratings | 18 months | ⚠️ if >18 months | Annual ratings; check for rating year |
| Zillow / Redfin | Home prices, appreciation | 6 months | ⚠️ if >6 months | Market moves fast; use for D8 supplement only |
| Yelp | Restaurant ratings, status | 6 months | ⚠️ if >6 months | Closures, ownership changes frequent |
| Google Maps / Places | Business hours, status | 3 months | ⚠️ if >3 months | Verify key POIs at time of engagement |
| AllTrails | Trail information | 1 year | ⚠️ if >1 year | Trail conditions seasonal |
| Trust for Public Land (ParkServe) | Park scores | 2 years | ⚠️ if >2 years | Annual updates |

---

### Open Data Sources

| Source | Data Type | Validity Window | Staleness Flag | Notes |
|--------|-----------|----------------|----------------|-------|
| OpenStreetMap (via Overpass) | POIs, roads, parks | 6 months | ⚠️ if >6 months | OSM is continuously edited |
| GTFS feeds | Transit routes/stops | 3 months | ⚠️ if >3 months | Agencies publish seasonal schedules |
| Local 311 open data | Service requests | 6 months | ⚠️ if >6 months | Cities update quarterly to annually |
| Census Business Dynamics | Business formation | 2 years | ⚠️ if >2 years | BDS is a lagged annual dataset |

---

## Staleness Handling Rules

### Severity Levels

| Level | Condition | Action |
|-------|-----------|--------|
| 🔴 Critical | Core data (ACS income, Walk Score) >50% over validity window | Block delivery; refresh required |
| 🟡 Warning | Data within 25% of validity window limit | Flag in scorecard; note in dossier |
| 🟢 Current | Data within validity window | No action required |

**Examples:**
- ACS data from 2019 for a 2024 engagement: 5 years old, validity 3 years → 🔴 Critical
- Walk Score from 8 months ago: validity 12 months → 🟢 Current
- Yelp ratings from 5 months ago: validity 6 months → 🟡 Warning (approaching limit)

---

### Missing Data Protocol

When data is unavailable (source down, paywall, no coverage):

1. **Document as "unavailable"** in prompt output file
2. **Apply missing-data defaults** per `scoring/scoring-methodology.md` Section 5
3. **Note in scorecard** confidence level: drop affected dimension to "Low" confidence
4. **Do not impute** from neighboring census tracts without explicit documentation
5. **Do not suppress** the missing data — always disclose to client

---

## Data Collection Date Recording

Every citation row in `citations.md` must include:
- `access_date`: The date you retrieved the data (ISO: YYYY-MM-DD)
- `data_date`: The as-of date of the data itself (e.g., "ACS 2022 5-year estimates")

These two dates are different. A 2023 engagement pulling ACS 2022 data accessed in October 2023:
- access_date: 2023-10-15
- data_date: 2022 (ACS 5-year, 2018–2022)

---

## Refresh Triggers

A LOCUS engagement data refresh is recommended when:
- 12 months have elapsed since the original engagement (any tier)
- A major local event has occurred (natural disaster, major employer departure/arrival, rezoning)
- Client is making a transaction decision >6 months after original delivery
- Walk Score® for the address changes by more than 5 points

For refresh engagements: create a new Engagement ID, link to parent in metadata, re-run all prompts.

---

## check-citations.sh Output Format

The `tools/scripts/check-citations.sh` script reads `citations.md` and produces:

```
LOCUS Citation Currency Report — [ENGAGEMENT_ID]
Run date: [DATE]

🟢 Current:     [N] citations
🟡 Warning:     [N] citations (approaching validity limit)
🔴 Stale:       [N] citations (beyond validity window)
⬜ Unknown date: [N] citations (access_date missing)

Stale citations requiring attention:
  CIT-007: Walk Score (accessed 2022-03-01) — 25 months old, window 12 months 🔴
  CIT-012: Yelp (accessed 2023-04-15) — 8 months old, window 6 months 🔴

Warnings:
  CIT-003: ACS 2020 income — 4 years old, window 3 years 🟡 (approaching critical)
```

---

*Data Currency · LOCUS Framework · BHIL*
*Enforcement: `tools/scripts/check-citations.sh` · Storage: `citations.md` per engagement*
