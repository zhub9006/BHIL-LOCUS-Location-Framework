---
id: LOCUS-SCORING-METHOD
title: "LOCUS Scoring Methodology"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Scoring Methodology

## Overview

The LOCUS composite score is a **persona-adjusted, percentile-hybrid weighted arithmetic mean** across 9 location dimensions, each scored 1–10 using validated third-party data anchored in research-backed methodologies.

This document explains the design decisions, mathematical foundations, and validation basis for every element of the scoring system. It is the authoritative reference for the scoring-agent and for practitioners who need to explain scoring choices to clients.

---

## Design principles

### 1. Defensibility above everything else

Every scoring choice must be explainable to a skeptical client, a real estate attorney, or a fair housing regulator. "That's how our algorithm works" is not an acceptable answer. Every score must trace to:
- A specific data point
- A specific source URL
- A specific mapping rule in this document

### 2. Percentile-hybrid scoring (not absolute)

A location can't be scored well or poorly in isolation — it must be scored relative to the comparison set. But pure percentile ranking has a weakness: a neighborhood in a uniformly poor city would score well on a percentile basis despite being objectively bad.

The **percentile-hybrid approach** addresses this by combining:
- **Percentile ranking** within a comparable geography (typically the metro area)
- **Absolute threshold anchors** that override percentile ranking when objective conditions are extreme

This produces scores that are both locally meaningful and nationally defensible.

### 3. Persona weighting acknowledges that "good location" is subjective

A retired couple and a 28-year-old tech worker have radically different priorities. The LOCUS composite score is only meaningful in the context of a persona. The same address can score 8.2 for a Young Professional and 5.4 for a Family. This is not a flaw — it is the point.

### 4. Transparency in every calculation

The scoring-agent shows all workings. Every score display includes the sub-metric values, the weights applied, the calculation arithmetic, and the confidence level. Clients receive a scorecard they can audit, not a black-box number.

---

## Percentile-to-score mapping

The asymmetric band design concentrates discrimination at the extremes (rare 9–10 and 1–2 scores) while providing broad coverage in the middle range where most addresses fall.

| Percentile Range | LOCUS Score | Label | Design Intent |
|-----------------|-------------|-------|---------------|
| 95–100th | 10.0 | Exceptional | Top 5% of locations — genuinely rare |
| 90–95th | 9.5 | Exceptional–Outstanding | |
| 85–90th | 9.0 | Outstanding | Top 15% |
| 80–85th | 8.5 | Outstanding–Excellent | |
| 75–80th | 8.0 | Excellent | Top quartile |
| 70–75th | 7.5 | Excellent–Very Good | |
| 65–70th | 7.0 | Very Good | |
| 60–65th | 6.5 | Very Good–Good | |
| 50–60th | 6.0 | Good | Median band |
| 40–50th | 5.5 | Good–Average | |
| 35–40th | 5.0 | Average | |
| 25–35th | 4.0 | Below Average | |
| 15–25th | 3.0 | Fair | |
| 5–15th | 2.0 | Poor | |
| 0–5th | 1.0 | Very Poor | Bottom 5% |

Half-point precision: All scores displayed to one decimal.

---

## Absolute threshold anchors

These anchors override percentile mapping. They exist because some conditions are so extreme that relative ranking fails to capture their significance:

| Trigger Condition | Source | Override |
|-------------------|--------|---------|
| Walk Score ≥ 90 | Walk Score API | Walkability sub-score: floor at 9.5 |
| Walk Score ≤ 25 | Walk Score API | Walkability sub-score: ceiling at 2.0 |
| FEMA Flood Zone AE or VE | FEMA NFHL API | Civic dimension flagged ⚠️; penalty −1.0 from sub-score |
| EPA AQI "Unhealthy" (>150) | EPA AirNow | Civic dimension: penalty −1.0 |
| USDA Food Desert designation | USDA FARA | Daily Errands: sub-score max 4.0 |
| GreatSchools all "above average" | GreatSchools | Education: floor at 7.5 |
| Superfund site within 0.5mi | EPA CERCLIS | Civic dimension flagged ⚠️ |
| 100% car-dependent transit score | Walk Score | Transit sub-score: ceiling at 1.5 |

When an anchor is triggered, it must be documented in the scorecard with the triggering condition and source.

---

## Dimension scoring: sub-metrics and weights

Each dimension combines 3–7 sub-metrics via weighted arithmetic mean. Weights are fixed for all engagements — they cannot be adjusted without a methodology ADR.

### Dimension 1: Walkability & Accessibility (9 sub-metrics → 4 groups)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Walk Score® | 40% | Walk Score API | Direct mapping: WS÷10 (anchor-adjusted) |
| POI density within 0.5 mi | 25% | Overpass API | Percentile vs metro |
| Pedestrian infrastructure quality | 15% | City reports / estimate | 4-point rubric (see scoring-rubric.md) |
| Pedestrian safety index | 20% | Ped fatality data / city open data | Percentile vs metro |

*Research basis: Walk Score has 172+ peer-reviewed publications. Redfin found Walk Score point ≈ $3,250 home value. Multifamily with WS<80 has 60% higher mortgage default rates.*

### Dimension 2: Food, Drink & Social (5 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Restaurant density per km² | 30% | Overpass + Google Places | Percentile vs metro |
| Average review rating | 20% | Google Places / Yelp | Score ÷ 5 × 10 |
| Cuisine diversity index | 20% | Overpass categories | Unique cuisines ÷ total (percentile) |
| Independent-to-chain ratio | 15% | Foursquare chain_id / OSM brand tag | Higher indie = higher score |
| Price tier distribution | 15% | Google Places priceLevel | Distribution analysis |

### Dimension 3: Recreation & Green Space (4 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Park acreage per 1,000 residents | 30% | Trust for Public Land ParkScore | Percentile vs US cities |
| 10-minute walk park access | 35% | Trust for Public Land ParkScore | % of residents with access |
| Trail density (miles per km²) | 20% | Overpass (leisure=track/path) | Percentile vs metro |
| Green space coverage | 15% | EPA EnviroAtlas | % impervious surface (inverted) |

### Dimension 4: Daily Errands & Retail (5 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Grocery access (nearest, distance) | 35% | Overpass + WebSearch | Distance decay rubric |
| Pharmacy access | 20% | Overpass | Distance to nearest |
| Retail diversity | 20% | Overpass shop categories | Category count (percentile) |
| Food desert status | 15% | USDA FARA | Binary: yes = anchor max 4.0 |
| Delivery coverage | 10% | Proxy via density | Urban density correlation |

### Dimension 5: Education Quality (4 sub-metrics — for Complete/Enterprise)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| School performance rating (bands) | 40% | GreatSchools NearbySchools API | Band-to-score mapping |
| School accessibility (distance) | 20% | GreatSchools + NCES CCD | Distance decay rubric |
| Per-pupil expenditure | 20% | NCES CCD | Percentile vs state |
| School diversity of options | 20% | NCES (public + charter + private count) | Count (percentile) |

*Fair Housing note: School ratings presented with required disclosure about correlation with socioeconomic factors.*

### Dimension 6: Transit & Commute (4 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Transit Score | 35% | Walk Score API | Direct: TS÷10 (anchor-adjusted) |
| Transit frequency (peak) | 25% | GTFS feed analysis | Headway minutes (inverted percentile) |
| Major employment center access | 25% | Google Maps Routes / OTP | Minutes to CBD (inverted percentile) |
| Bike infrastructure quality | 15% | Bike Score + OSM cycleway | Score ÷ 10 + qualitative |

### Dimension 7: Civic Infrastructure & Safety (5 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Crime rate (property + violent) | 30% | FBI UCR / city open data | Crimes/1,000 (inverted percentile) |
| Flood risk | 20% | FEMA NFHL | Zone-based rubric (see scoring-rubric.md) |
| Air quality (AQI) | 20% | EPA AirNow | AQI (inverted percentile + anchors) |
| Noise environment | 15% | BTS National Transportation Noise Map | Decibel level (inverted) |
| 311 complaint density | 15% | City open data (where available) | Complaints/1,000 (inverted percentile) |

### Dimension 8: Demographic Character & Trajectory (4 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Neighborhood trajectory score | 40% | See trajectory-methodology.md | Composite 5-indicator trajectory |
| Median home value appreciation | 25% | Zillow ZHVI time series | YoY vs metro average |
| Educational attainment trend | 20% | Census ACS vintage comparison | % bachelor's change |
| Population stability | 15% | Census ACS total population | Population change rate |

*Fair Housing note: Racial/ethnic composition excluded from residential reports. Commercial/Enterprise tier includes demographic profile with required framing.*

### Dimension 9: Business Environment (4 sub-metrics)

| Sub-metric | Weight | Source | Scoring basis |
|-----------|--------|--------|--------------|
| Business density (establishments/km²) | 30% | Census CBP | Percentile vs county |
| Employment accessibility | 25% | Census LEHD/LODES | Jobs within 30-min commute |
| Business health (survival rate proxy) | 25% | Census CBP year-over-year | Establishment change rate |
| Commercial corridor vitality | 20% | Google Popular Times / WebSearch | Qualitative + quantitative |

---

## Composite score calculation

The composite LOCUS Score is a weighted arithmetic mean of the 9 dimension scores:

```
LOCUS Score = Σ(dimension_score_i × persona_weight_i)
```

Where persona_weight_i is from the persona profile in `scoring/persona-profiles.md`.

**Balance indicator:** If any dimension scores below 3.0, the composite is flagged regardless of its numeric value. A high composite can mask a critical weakness.

**Display precision:** Composite score to one decimal (e.g., 7.6, not 7.57 or 7.6124).

**Confidence adjustment:** If ≥3 dimensions have Low confidence, the composite is tagged as "Low confidence — significant data gaps."

---

## Comparison set and percentile computation

Percentiles are computed relative to the **metropolitan statistical area (MSA)** containing the subject address, not the nation. This ensures that a "Very Good" score in rural Montana is comparable to a "Very Good" score in Manhattan — both reflect the top 25% of their respective markets.

For engagements where MSA-level comparison data is not available (rural areas, territories):
- Fall back to state-level percentile
- Note the comparison set in the scorecard
- Tag: "Percentile relative to state — MSA data unavailable"

---

## Validation basis

The LOCUS scoring system draws on validated methodologies from:

- **Walk Score** — 172+ peer-reviewed publications; $3,250 property value correlation per point (Redfin study)
- **Trust for Public Land ParkScore** — nationally standardized park access metric
- **GreatSchools** — 150,000+ school profiles; rating methodology documented and peer-reviewed
- **AARP Livability Index** — 61-indicator scoring system used as structural reference
- **Niche.com** — Consumer-facing location scoring with documented methodology
- **NCREIF Property Index** — Institutional real estate benchmarking
- **FBI UCR** — Federal crime reporting standard

Any future changes to the LOCUS scoring methodology must be documented in a methodology ADR referencing this file.

---

*LOCUS Scoring Methodology — BHIL LOCUS Framework v1.0*
