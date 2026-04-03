---
document: trajectory-methodology
dimension: D8
version: "1.0"
---

# Trajectory Methodology — D8: Neighborhood Trajectory

**Dimension:** D8 · Neighborhood Trajectory
**Weight range:** 10% (Family/Retiree) → 25% (Investor)

---

## Design Principle

D8 is the only LOCUS dimension that is explicitly **forward-looking**. It does not score current conditions — it scores the direction and momentum of change. A neighborhood with modest current amenities but strong upward trajectory may score higher on D8 than a stable but stagnant area.

Trajectory is measured through five **economic structural indicators** — not demographic composition. Racial, ethnic, and protected-class data is never used. See `.claude/rules/fair-housing.md`.

---

## The Five Trajectory Indicators

### T1 — Population Change

**Data source:** U.S. Census ACS 5-year estimates, comparing most recent 5-year window
**Variable:** B01003_001E (total population), tract level

**Scoring:**

| 5-Year Change | Score |
|--------------|-------|
| +10% or more | 9.0–10.0 |
| +5% to +9.9% | 7.5–8.9 |
| +2% to +4.9% | 6.0–7.4 |
| -1.9% to +1.9% (stable) | 5.0–6.9 |
| -2% to -4.9% | 3.5–4.9 |
| -5% to -9.9% | 2.0–3.4 |
| -10% or more | 1.0–2.0 |

**Persona adjustment:**
- Investor: raw score (growth = positive)
- Retiree: invert slightly — very high growth may signal instability/displacement; cap Retiree T1 bonus at 7.5 for growth >10%

---

### T2 — Income Change (Real)

**Data source:** ACS B19013_001E (median household income), inflation-adjusted
**Adjustment:** Apply CPI deflator to base-year income before calculating % change

**Scoring:**

| Real Income Change (5yr) | Score |
|--------------------------|-------|
| +15% or more | 9.5–10.0 |
| +8% to +14.9% | 8.0–9.4 |
| +3% to +7.9% | 6.5–7.9 |
| -2.9% to +2.9% (flat real) | 5.0–6.4 |
| -3% to -7.9% | 3.0–4.9 |
| -8% or more | 1.0–2.9 |

**CPI deflator approach (simplified):**
- Use BLS CPI-U annual averages
- Multiply base year income by (recent year CPI / base year CPI)
- Compare to recent year ACS income

---

### T3 — Home Value Appreciation

**Data source:** Primary: ACS B25077_001E (median home value) · Supplemental: Zillow/Redfin (fresher data, not ACS-lagged)
**Reporting:** Supplement ACS with commercial data, cite separately

**Scoring:**

| 5-Year Appreciation | Score |
|--------------------|-------|
| +40% or more | 9.0–10.0 |
| +25% to +39.9% | 7.5–8.9 |
| +10% to +24.9% | 6.0–7.4 |
| +0% to +9.9% | 4.5–5.9 |
| -0.1% to -9.9% | 2.5–4.4 |
| -10% or more | 1.0–2.4 |

**Persona note:** Very high appreciation (>40%) gets a slight Retiree discount — rapid appreciation can signal affordability pressure and community disruption for fixed-income residents.

---

### T4 — Permit & Development Activity

**Data source:** Census Building Permits Survey (county level) + WebSearch for local development pipeline
**Nature:** Trend data, not precise counts

**Scoring framework:**

| Signal | Score |
|--------|-------|
| Major development pipeline (anchor projects, transit investment, institutional expansion) | 8.5–10.0 |
| Active permitting trend (increasing YoY) + multiple smaller projects | 7.0–8.4 |
| Stable permitting, some new projects | 5.5–6.9 |
| Flat permitting, no notable pipeline | 4.0–5.4 |
| Declining permits, few projects, some vacancy signals | 2.5–3.9 |
| Significant disinvestment or declining permit activity | 1.0–2.4 |

**Evidence weighting:**
- Government-announced projects (transit expansion, hospital, school): highest weight
- Large private development (confirmed, permitted): high weight
- News mentions of "planned" development: medium weight (not confirmed)
- Absence of evidence: not evidence of absence — mark as "data unavailable"

---

### T5 — Business Formation Trend

**Data source:** Census Business Dynamics Statistics (BDS) county level + WebSearch for local signals
**Measure:** Net business formation rate (births minus deaths)

**Scoring:**

| Signal | Score |
|--------|-------|
| Strong net positive formation, accelerating | 8.5–10.0 |
| Positive formation trend | 7.0–8.4 |
| Roughly stable, slight positive | 5.0–6.9 |
| Flat or unclear | 4.0–5.4 |
| Net negative trend | 2.0–3.9 |
| Significant business closure/disinvestment signals | 1.0–2.0 |

---

## D8 Composite Calculation

All five indicators carry equal weight (20% each):

```
D8 = (T1_score × 0.20) + (T2_score × 0.20) + (T3_score × 0.20) 
   + (T4_score × 0.20) + (T5_score × 0.20)
```

**Missing data handling:**
- If 1 indicator missing: redistribute weight equally among remaining 4
- If 2 indicators missing: redistribute among remaining 3; flag as "medium confidence"
- If 3+ indicators missing: flag as "low confidence"; use regional proxy data if available

---

## Trajectory Direction Signals

After calculating D8, classify overall trajectory direction:

| D8 Score | Trajectory Classification |
|----------|--------------------------|
| 8.0–10.0 | **Strong Upward Momentum** — multiple indicators rising |
| 6.5–7.9 | **Positive Trajectory** — generally improving |
| 5.0–6.4 | **Stable** — holding steady, limited momentum |
| 3.5–4.9 | **Mixed/Uncertain** — some indicators diverging |
| 2.0–3.4 | **Declining Trajectory** — multiple indicators weakening |
| Below 2.0 | **Significant Decline** — structural disinvestment signals |

---

## Persona-Specific Trajectory Interpretation

### Investor
Weight: 25%. Full raw D8 score applied. Growth maximization. Upward momentum = opportunity.

### Family
Weight: 10%. Trajectory matters for long-term asset value and school district health. Both growth and stability score well. Extreme rapid growth may indicate affordability risk.

### Young Professional
Weight: 12%. Moderate weight — values upward-trending neighborhoods for appreciation upside and evolving amenity mix.

### Retiree
Weight: 10%. Stability preferred. Moderate growth acceptable. Very rapid growth may signal displacement risk → cap Retiree D8 bonus for T1/T3 extremes.

### Remote Worker
Weight: 13%. Prefers improving neighborhoods with growing business ecosystem. Strong T5 (business formation) is particularly relevant.

---

## Fair Housing Compliance Note

D8 uses exclusively economic and structural indicators:
- Population (total count, not composition)
- Household income (economic measure)
- Home values (market measure)
- Building permits (structural investment)
- Business formation (economic vitality)

**Absolutely prohibited in D8:**
- Racial or ethnic composition trends
- "Gentrification" as a scoring input
- Displacement framing by protected class
- Any protected-class demographic as a trajectory signal

See `.claude/rules/fair-housing.md` for absolute prohibitions.

---

## Data Staleness for D8

| Indicator | Validity Window | Flag if Older |
|-----------|----------------|--------------|
| ACS population | 3 years | ⚠️ if 2019 or earlier |
| ACS income | 3 years | ⚠️ if 2019 or earlier |
| ACS home value | 2 years (market moves fast) | ⚠️ if 2020 or earlier |
| Building permits | 18 months | ⚠️ if 2022 or earlier |
| Business formation | 2 years | ⚠️ if 2021 or earlier |

---

*Trajectory Methodology · D8 · LOCUS Framework · BHIL*
*Fair Housing compliance: `.claude/rules/fair-housing.md` · Scoring rubric integration: `scoring/scoring-rubric.md`*
