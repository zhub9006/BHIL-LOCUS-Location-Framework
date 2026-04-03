---
id: LOCUS-PERSONAS
title: "LOCUS Persona Profiles"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Persona Profiles

## Overview

Persona profiles transform the raw 9-dimension scores into a composite that reflects what actually matters to a specific type of location decision-maker. The same address can receive dramatically different composite scores across personas — this is intentional and correct. It reflects that "best location" is inherently subjective.

**Six standard personas are defined below.** A seventh (Custom) accepts practitioner-defined weights. All weights within a persona must sum exactly to 100%.

The scoring-agent loads the persona weights from this file. Never hardcode weights in prompt files.

---

## Persona 1: Family

**Profile:** Household with children under 18 (or planning to have children). Primary decisions driven by school quality, safety, and space for families. Transit less critical if driving is the household norm. Stability matters — trajectory toward stability or improvement preferred.

**Decision drivers:** #1 Education (28%), #2 Safety (25%), #3 Retail Access (12%)

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Walkability & Accessibility | 8% | Lower — families typically drive; walking convenience secondary |
| Food, Drink & Social | 5% | Lowest — fine dining and nightlife not a priority |
| Recreation & Green Space | 8% | Parks important but not top priority |
| Daily Errands & Retail | 12% | Grocery access, pharmacy, household needs — important |
| Education Quality | **28%** | #1 driver — NAR consistently finds this the top search criterion for families |
| Transit & Commute | 5% | Lower — typically car commuters; proximity to work matters more than transit |
| Civic Infrastructure & Safety | **25%** | #2 driver — safety for children is paramount |
| Demographic Trajectory | 4% | Stability over trajectory; long-term commitment persona |
| Business Environment | 5% | Low relevance for residential family decision |
| **Total** | **100%** | |

**Composite threshold guidance:**
- Score ≥ 7.5: Strong family location — Education ≥ 7.0 and Safety ≥ 7.0 required
- Score 6.0–7.4: Acceptable family location — review Education and Safety scores specifically
- Score < 6.0: Significant concerns for family use case

**Balance alert triggers:**
- Education score < 4.0 → ⚠️ CRITICAL for Family persona
- Safety score < 4.0 → ⚠️ CRITICAL for Family persona

---

## Persona 2: Young Professional

**Profile:** Single or couple, age 25–35, working in a primary employment center, prioritizing lifestyle access, walkability, and transit. May or may not own a car. Social scene and transit access are the primary location criteria.

**Decision drivers:** #1 Walkability (22%), #2 Transit (18%), #3 Food/Social (15%)

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Walkability & Accessibility | **22%** | #1 driver — "15-minute city" lifestyle preference |
| Food, Drink & Social | **15%** | #3 driver — dining, bars, social venues matter significantly |
| Recreation & Green Space | 10% | Running trails, parks for outdoor activity |
| Daily Errands & Retail | 8% | Convenience stores, walkable grocery — important but lower than walkability |
| Education Quality | 3% | Not relevant for most in this cohort |
| Transit & Commute | **18%** | #2 driver — car-free or car-light lifestyle |
| Civic Infrastructure & Safety | 12% | Matters, but lower priority than lifestyle |
| Demographic Trajectory | 5% | Shorter time horizon; less investment-minded |
| Business Environment | 7% | Employment access and commercial vitality matter |
| **Total** | **100%** | |

**Composite threshold guidance:**
- Score ≥ 7.5: Strong YP location — Walkability ≥ 7.0 and Transit ≥ 7.0 required
- Score 6.0–7.4: Acceptable — may require car ownership to supplement
- Score < 6.0: Likely car-dependent; misalign with car-free/car-light lifestyle goal

**Balance alert triggers:**
- Walkability score < 5.0 → ⚠️ NOTABLE for Young Professional
- Transit score < 4.0 → ⚠️ NOTABLE for Young Professional

---

## Persona 3: Retiree

**Profile:** Retired individual or couple, age 60+, prioritizing healthcare access, safety, walkability for daily needs, and quality of life. May be downsizing from larger home. Long-term community stability important. Transit matters as driving capability declines.

**Decision drivers:** #1 Safety (20%), #2 Recreation/Green (18%), #3 Walkability (15%)

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Walkability & Accessibility | 15% | Important — aging in place requires walkable errands |
| Food, Drink & Social | 10% | Social dining matters for quality of life |
| Recreation & Green Space | **18%** | #2 driver — parks, walking trails for daily health activity |
| Daily Errands & Retail | 12% | Pharmacy and grocery access critical for aging-in-place |
| Education Quality | 2% | Not relevant |
| Transit & Commute | 12% | Important — future driving limitations anticipated |
| Civic Infrastructure & Safety | **20%** | #1 driver — AARP surveys consistently rank safety first |
| Demographic Trajectory | 6% | Stability over appreciation; long tenure expected |
| Business Environment | 5% | Less relevant for non-working household |
| **Total** | **100%** | |

**Special data points for Retiree persona:**
- Healthcare access: nearest hospital and primary care clinic (note distances even though not a scored dimension — include in narrative)
- Senior center proximity (note in narrative if present in POI data)
- Public transit accessibility score (important for future driving reduction)

**Balance alert triggers:**
- Safety score < 5.0 → ⚠️ CRITICAL for Retiree
- Walkability score < 4.0 → ⚠️ NOTABLE for Retiree

---

## Persona 4: Investor

**Profile:** Real estate investor evaluating a location for asset acquisition, development, or portfolio inclusion. Primarily concerned with value trajectory, market dynamics, and commercial vitality. Least concerned with day-to-day lifestyle dimensions.

**Decision drivers:** #1 Demographic Trajectory (25%), #2 Business Environment (17%), #3 Education (10% as proxy)

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Walkability & Accessibility | 12% | Walkability correlates with property value appreciation |
| Food, Drink & Social | 8% | Commercial vitality signal |
| Recreation & Green Space | 7% | Neighborhood desirability signal |
| Daily Errands & Retail | 5% | Lowest — minimal direct investment relevance |
| Education Quality | 10% | School quality correlates with housing demand and values |
| Transit & Commute | 8% | Employment access drives rental demand |
| Civic Infrastructure & Safety | 8% | Safety impacts cap rates and tenant quality |
| Demographic Trajectory | **25%** | #1 driver — trajectory determines long-term return |
| Business Environment | **17%** | #2 driver — commercial vitality signals economic health |
| **Total** | **100%** | |

**Special scoring notes for Investor persona:**
- The trajectory score (P08) is the most influential single input — ensure it has High confidence
- Low confidence on trajectory → flag prominently in scorecard
- Include appreciation rate comparison to metro average in narrative
- Include cap rate range if commercial real estate context

**Balance alert triggers:**
- Trajectory score < 4.0 → ⚠️ CRITICAL for Investor (declining trajectory)
- Business Environment < 3.0 → ⚠️ CRITICAL for Investor

---

## Persona 5: Remote Worker

**Profile:** Professional working primarily from home. Location optimized for quality of life, workspace amenability, and outdoor access — not commute time. May work occasional days at a co-working space. Lifestyle breadth important.

**Decision drivers:** #1 Walkability (18%), #2 Recreation/Green (15%), #3 Food/Social (12%)

| Dimension | Weight | Rationale |
|-----------|--------|-----------|
| Walkability & Accessibility | **18%** | #1 driver — daily walkable lifestyle replaces commute |
| Food, Drink & Social | 12% | Third places (cafes, restaurants) matter for remote work lifestyle |
| Recreation & Green Space | **15%** | #2 driver — outdoor activity replaces commute decompress time |
| Daily Errands & Retail | 10% | Walkable errands important given no commute |
| Education Quality | 5% | May or may not be relevant |
| Transit & Commute | 5% | Low — commuting is rare by definition |
| Civic Infrastructure & Safety | 15% | Safety and quality-of-life matter more with more time at home |
| Demographic Trajectory | 10% | Investment in home as long-term base |
| Business Environment | 10% | Co-working access, broadband reliability, employment options |
| **Total** | **100%** | |

**Special data points for Remote Worker persona:**
- Note: broadband infrastructure is not a scored LOCUS dimension. If P07 data includes infrastructure quality notes, include in narrative.
- Co-working space proximity (note in P02 or P09 if found)
- Third place density (cafes, libraries) from P02 data

---

## Persona 6: Custom

**Profile:** Any use case requiring weight customization beyond the five standard personas. Commercial site selection, niche residential criteria, or specific investment strategy.

To activate Custom persona:

```yaml
persona: Custom
custom_persona_weights:
  walkability: [%]
  food_social: [%]
  recreation: [%]
  errands_retail: [%]
  education: [%]
  transit_commute: [%]
  civic_safety: [%]
  dem_trajectory: [%]
  business_env: [%]
  # Must sum to exactly 100
```

**Validation:** The scoring-agent will refuse to compute a composite if custom weights do not sum to exactly 100%. If practitioner-provided weights sum to 99 or 101 due to rounding, redistribute 1% to the highest-weighted dimension and note the adjustment.

**Documentation requirement:** Custom persona engagements must include a note in `engagement-metadata.md` explaining the rationale for weight customization. This is required for defensibility if the analysis is used in a decision context.

---

## Persona weight comparison table

| Dimension | Family | Young Prof | Retiree | Investor | Remote | Default |
|-----------|--------|------------|---------|----------|--------|---------|
| Walkability | 8% | **22%** | 15% | 12% | **18%** | 12% |
| Food/Social | 5% | **15%** | 10% | 8% | 12% | 10% |
| Recreation | 8% | 10% | **18%** | 7% | **15%** | 10% |
| Retail/Errands | 12% | 8% | 12% | 5% | 10% | 10% |
| Education | **28%** | 3% | 2% | 10% | 5% | 15% |
| Transit | 5% | **18%** | 12% | 8% | 5% | 10% |
| Safety/Civic | **25%** | 12% | **20%** | 8% | 15% | 15% |
| Dem. Trajectory | 4% | 5% | 6% | **25%** | 10% | 10% |
| Business Env. | 5% | 7% | 5% | **17%** | 10% | 8% |
| **Total** | 100% | 100% | 100% | 100% | 100% | 100% |

---

*LOCUS Persona Profiles — BHIL LOCUS Framework v1.0*
