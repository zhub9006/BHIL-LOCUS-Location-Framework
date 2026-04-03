---
template: prompt
id: P08
title: Demographics & Neighborhood Trajectory
dimension: D8
version: "1.0"
depends_on: [P01]
outputs: [p08-demographics-trajectory-output.md, citations.md]
estimated_time: "10–14 minutes"
web_search_queries: 4–6
fair_housing_sensitivity: CRITICAL
---

# P08 — Demographics & Neighborhood Trajectory

**Dimension:** D8 · Neighborhood Trajectory
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

> 🚫 **FAIR HOUSING — CRITICAL**
> This prompt uses Census demographic data. **Racial and ethnic composition data MUST NOT be recorded, surfaced, or used in scoring.** See `.claude/rules/fair-housing.md` — absolute prohibition. Use only economic trajectory indicators (income, home values, permits, business formation).

---

## Objective

Measure neighborhood trajectory through 5-year trend lines on economically relevant indicators: population change, income change, home value appreciation, building permit activity, and business formation. These are leading/lagging indicators of market trajectory.

---

## Pre-Flight

1. Confirm FIPS codes (state, county, tract) from P01
2. FIPS state code, county code, and census tract code are required for ACS API calls
3. Persona context: Investor weights D8 at 25%; Family/Retiree prioritize stability over growth

---

## Data Collection Steps

### Step 1 — Census ACS — Economic Indicators (Bash)

```bash
FIPS_STATE="[2-digit state FIPS]"
FIPS_COUNTY="[3-digit county FIPS]"
FIPS_TRACT="[6-digit tract FIPS, no decimal]"

# ACS 5-year estimates — most recent year vs 5 years prior
# Variables:
# B19013_001E = Median household income
# B25077_001E = Median home value
# B01003_001E = Total population

ACS_YEAR_RECENT="2022"
ACS_YEAR_BASE="2017"

echo "=== Recent ACS (${ACS_YEAR_RECENT}) ==="
curl -s "https://api.census.gov/data/${ACS_YEAR_RECENT}/acs/acs5?get=NAME,B19013_001E,B25077_001E,B01003_001E&for=tract:${FIPS_TRACT}&in=state:${FIPS_STATE}+county:${FIPS_COUNTY}" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
headers = data[0]
values = data[1]
for h,v in zip(headers, values):
    print(f'{h}: {v}')
"

echo "=== Base ACS (${ACS_YEAR_BASE}) ==="
curl -s "https://api.census.gov/data/${ACS_YEAR_BASE}/acs/acs5?get=NAME,B19013_001E,B25077_001E,B01003_001E&for=tract:${FIPS_TRACT}&in=state:${FIPS_STATE}+county:${FIPS_COUNTY}" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
headers = data[0]
values = data[1]
for h,v in zip(headers, values):
    print(f'{h}: {v}')
"
```

**Variables to record:**
- Population (2022 vs. 2017) → % change
- Median household income (both years) → % change, inflation-adjusted
- Median home value (both years) → % appreciation

**CRITICAL: Do NOT query or record B02001 (race), B03002 (Hispanic origin), or any demographic composition variables. If these appear in API responses, discard them.**

---

### Step 2 — Building Permits (Bash + WebSearch)

```bash
# Census Building Permits Survey — county level
FIPS_STATE="[STATE]"
FIPS_COUNTY="[COUNTY]"

curl -s "https://api.census.gov/data/timeseries/eits/cbps?get=cell_value,data_type_code,category_code,seasonally_adj&for=county:${FIPS_COUNTY}&in=state:${FIPS_STATE}&time=from+2018+to+2023" \
  -o /tmp/permits.json 2>&1 && cat /tmp/permits.json | head -50 || echo "Permits API unavailable"
```

**WebSearch fallback:**
```
Query A: [CITY STATE] building permits issued 2019 2020 2021 2022 2023 new construction
Query B: [CITY COUNTY] development pipeline new projects construction starts
```

Record: permit trend direction (increasing/stable/decreasing) and notable development projects.

---

### Step 3 — Business Formation Trend (WebSearch)

```
Query C: [CITY STATE] new business registrations 2019 2022 2023 economic growth
Query D: [CITY] [COUNTY] business formation Census BDS job growth
```

Record: Business formation trend, any notable commercial investment or disinvestment signals.

---

### Step 4 — Home Value Trend Supplement (WebSearch)

ACS home values lag — supplement with recent market data:
```
Query E: [ZIP CODE] [CITY] median home price 2019 2023 appreciation Zillow Redfin
```

Record: Zillow/Redfin appreciation data + year range.
Note: Commercial data is supplemental to ACS; cite separately.

Citation: Zillow Research / Redfin Data Center if used.

---

### Step 5 — Trajectory Narrative Signal (WebSearch)

```
Query F: [CITY] [NEIGHBORHOOD] development investment future plans 2023 2024
```

Look for: Major development announcements, infrastructure investment, anchor institution plans, rezoning activity.
These are qualitative signals that supplement quantitative ACS data.

Record: 2–3 notable developments or investments if found.

---

## Trajectory Direction Classification

After collecting data, classify each indicator:

| Indicator | Direction | Magnitude | Scoring Implication |
|-----------|-----------|-----------|---------------------|
| Population | ▲▼► | % change | Growth = positive trajectory |
| Household income | ▲▼► | % change (real) | Real income growth = economic health |
| Home value | ▲▼► | % change | Appreciation = market confidence |
| Permit activity | ▲▼► | trend | Active permitting = investment signal |
| Business formation | ▲▼► | trend | Net formation = economic vitality |

**Persona calibration:**
- Investor: weights strong growth highly
- Family: weights stability and measured growth; disinvestment is a concern
- Retiree: weights stability; rapid appreciation can be negative (displacement risk)

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p08-demographics-trajectory-output.md`

```markdown
---
prompt: P08
engagement_id: {{ENGAGEMENT_ID}}
dimension: D8
completed: [ISO_DATE]
fair_housing_reviewed: true
---

# P08 Output — Neighborhood Trajectory

> Fair Housing Notice: This section analyzes economic trajectory indicators only.
> No demographic composition, racial, ethnic, or protected-class data is recorded.

## Economic Indicators — 5-Year Trend

| Indicator | Base Year | Value | Recent Year | Value | Change | Direction |
|-----------|-----------|-------|-------------|-------|--------|-----------|
| Population | 2017 | [N] | 2022 | [N] | [+/-X%] | ▲▼► |
| Median HH Income | 2017 | $[N] | 2022 | $[N] | [+/-X%] | ▲▼► |
| Median Home Value | 2017 | $[N] | 2022 | $[N] | [+/-X%] | ▲▼► |
| Building Permits | 2018 | [trend] | 2023 | [trend] | [direction] | ▲▼► |
| Business Formation | 2018 | [trend] | 2023 | [trend] | [direction] | ▲▼► |

*Data source: U.S. Census Bureau ACS 5-year estimates*

## Supplemental Market Data
- Zillow/Redfin appreciation ([DATE_RANGE]): [X%]
- Permit trend characterization: [increasing / stable / decreasing]
- Notable development signals: [2–3 items or "none identified"]

## Trajectory Summary
[2–3 sentences characterizing the overall economic trajectory of this census tract/neighborhood — using only economic language, not demographic characterizations.]

## Scoring Inputs for D8
- Population change input: [% change]
- Income change input: [% change, real]
- Home value change input: [% appreciation]
- Permit activity input: [trend direction + magnitude]
- Business formation input: [trend direction]

## Data Quality Notes
[Tract-level vs. ZIP-level, ACS margin of error note, years available]

## Citations Added (P08)
[Must include: U.S. Census Bureau ACS citation]
```

---

## Fair Housing Self-Check (Required)

- [ ] NO racial or ethnic data collected or recorded
- [ ] NO B02001 or B03002 variables in any query results
- [ ] All indicators are economic/structural
- [ ] Trajectory summary uses economic language only
- [ ] ACS citation included

---

## Update engagement-metadata.md

Set `P08_demographics_trajectory: true`.

---

*P08 complete → proceed to P09 (Business Environment)*
