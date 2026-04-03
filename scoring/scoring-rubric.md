---
id: LOCUS-SCORING-RUBRIC
title: "LOCUS Scoring Rubric"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Scoring Rubric

The scoring-agent uses this file as its primary reference during P10 synthesis. Every sub-metric mapping is defined here. The scoring-agent must not improvise mappings that are not in this document.

---

## Dimension 1: Walkability & Accessibility

### Sub-metric 1a: Walk Score® (weight: 40%)

Direct linear mapping with absolute anchors:

| Walk Score® | LOCUS Sub-score | Notes |
|------------|----------------|-------|
| 90–100 | 9.5–10.0 | Walker's Paradise — absolute anchor: floor at 9.5 |
| 80–89 | 8.0–9.4 | Very Walkable |
| 70–79 | 7.0–7.9 | Very Walkable |
| 60–69 | 6.0–6.9 | Walkable |
| 50–59 | 5.0–5.9 | Walkable |
| 40–49 | 4.0–4.9 | Car-Dependent (some errands on foot) |
| 30–39 | 3.0–3.9 | Car-Dependent |
| 26–29 | 2.5–2.9 | Car-Dependent |
| 0–25 | 1.0–2.4 | Almost all errands require car — absolute anchor: ceiling at 2.0 |
| Not available | 5.0 (Low confidence) | Not in Walk Score database |

*Calculation: sub-score = Walk Score® ÷ 10, clamped by anchors above*

### Sub-metric 1b: POI density within 0.5 miles (weight: 25%)

Density calculated as: (POI count from Overpass 800m radius) ÷ (π × 0.5²) per km²

| POI density per km² | LOCUS Sub-score | Percentile estimate |
|--------------------|----------------|---------------------|
| > 500 | 9.0–10.0 | 90th+ (dense urban core) |
| 300–499 | 7.5–8.9 | 75th–90th |
| 150–299 | 6.5–7.4 | 60th–75th |
| 80–149 | 5.5–6.4 | 45th–60th |
| 40–79 | 4.5–5.4 | 30th–45th |
| 20–39 | 3.5–4.4 | 15th–30th |
| 10–19 | 2.5–3.4 | 5th–15th |
| < 10 | 1.0–2.4 | Below 5th |

### Sub-metric 1c: Pedestrian infrastructure quality (weight: 15%)

Qualitative rubric based on city data or estimation:

| Condition | Sub-score | Evidence basis |
|-----------|-----------|---------------|
| Continuous sidewalks both sides, protected crossings, traffic calming | 8.5–10.0 | City report confirms >90% coverage |
| Mostly continuous sidewalks, signalized crossings | 7.0–8.4 | City report confirms 70–90% coverage |
| Partial sidewalks, mix of crossings | 5.0–6.9 | Partial city data or Walk Score sub-methodology estimate |
| Intermittent sidewalks, few marked crossings | 3.0–4.9 | Limited coverage confirmed |
| Minimal or no sidewalk infrastructure | 1.0–2.9 | City confirms <30% coverage |
| Not retrieved | 5.0 (Low confidence) | Default median; mark Low confidence |

### Sub-metric 1d: Pedestrian safety index (weight: 20%)

Based on pedestrian fatalities and injuries per 100,000 residents, sourced from NHTSA or city open data:

| Pedestrian injuries per 100K | Sub-score | Source |
|------------------------------|-----------|--------|
| < 5 (very low) | 9.0–10.0 | NHTSA / city data |
| 5–14 | 7.5–8.9 | |
| 15–29 | 6.0–7.4 | |
| 30–49 | 4.5–5.9 | |
| 50–74 | 3.0–4.4 | |
| 75–99 | 2.0–2.9 | |
| ≥ 100 (very high) | 1.0–1.9 | |
| Not retrieved | 5.0 (Low confidence) | |

---

## Dimension 5: Education Quality

### Sub-metric 5a: School performance rating bands (weight: 40%)

GreatSchools rating bands (no Enterprise license required):

| Rating Band | LOCUS Sub-score | Notes |
|------------|----------------|-------|
| All "above average" or "highly rated" | 8.5–10.0 | Absolute anchor: floor at 7.5 if confirmed |
| Mostly "above average" | 7.0–8.4 | |
| Mixed ("average" and "above average") | 5.5–6.9 | |
| Mostly "average" | 4.5–5.4 | |
| Mixed ("average" and "below average") | 3.5–4.4 | |
| Mostly "below average" | 2.5–3.4 | |
| All "below average" | 1.0–2.4 | |
| No ratings available | 5.0 (Low confidence) | |

*If Enterprise GreatSchools license: numeric ratings 1–10 can be averaged directly*

### Sub-metric 5b: School accessibility (distance to nearest) (weight: 20%)

| Distance to nearest school | Sub-score |
|---------------------------|-----------|
| ≤ 0.25 mi (5-min walk) | 9.0–10.0 |
| 0.26–0.5 mi (10-min walk) | 7.5–8.9 |
| 0.51–1.0 mi (20-min walk or bike) | 6.0–7.4 |
| 1.1–2.0 mi (drive / transit needed) | 4.5–5.9 |
| 2.1–5.0 mi | 3.0–4.4 |
| > 5.0 mi | 1.5–2.9 |

### Sub-metric 5c: Per-pupil expenditure (weight: 20%)

Relative to state average (from NCES CCD data):

| Expenditure vs state average | Sub-score |
|-----------------------------|-----------|
| ≥ 150% of state average | 9.0–10.0 |
| 125–149% | 7.5–8.9 |
| 110–124% | 6.5–7.4 |
| 95–109% (at state average) | 5.5–6.4 |
| 80–94% | 4.5–5.4 |
| 65–79% | 3.5–4.4 |
| < 65% | 1.5–3.4 |
| Not retrieved | 5.0 (Low confidence) |

### Sub-metric 5d: School option diversity (weight: 20%)

Counts of public, charter, and private schools within 2 miles:

| Total school options within 2 mi | Sub-score |
|---------------------------------|-----------|
| 10+ options including public + charter + private | 9.0–10.0 |
| 7–9 options with multiple types | 7.5–8.9 |
| 4–6 options | 6.0–7.4 |
| 2–3 options | 4.5–5.9 |
| 1 option (public only) | 3.0–4.4 |
| 0 options within 2 miles | 1.0–2.9 |

---

## Dimension 7: Civic Infrastructure & Safety

### Sub-metric 7a: Crime rate (weight: 30%)

**Property crime rate** (property crimes per 1,000 residents) and **violent crime rate** (violent crimes per 1,000 residents), combined as weighted composite (property 60% + violent 40%):

| Combined crime index | Sub-score | Typical context |
|--------------------|-----------|----------------|
| < 10 | 9.0–10.0 | Exceptionally low crime |
| 10–19 | 7.5–8.9 | Below US average |
| 20–29 | 6.5–7.4 | Moderate — at US average |
| 30–44 | 5.0–6.4 | Above average |
| 45–59 | 3.5–4.9 | High crime |
| 60–79 | 2.5–3.4 | Very high crime |
| ≥ 80 | 1.0–2.4 | Extreme crime levels |
| Not retrieved | 5.0 (Low confidence) | Note data gap prominently |

*Source preference: FBI UCR (preferred, standardized) → City open data → State crime data*

**Never characterize crime data qualitatively.** Always present as: "X crimes per 1,000 residents [Source: FBI UCR, DATE]"

### Sub-metric 7b: Flood risk (weight: 20%)

FEMA National Flood Hazard Layer zone designation:

| FEMA Zone | Risk Level | Sub-score | Anchor |
|-----------|-----------|-----------|--------|
| Zone X (unshaded) | Minimal | 9.0–10.0 | None |
| Zone X (shaded) | Moderate | 7.0–8.9 | None |
| Zone AO/AH | Low-moderate | 5.5–6.9 | None |
| Zone A (no BFE) | High | 4.0–5.4 | ⚠️ Flag |
| Zone AE | High (100-yr) | 2.5–3.9 | ⚠️ Flag + −1.0 dimension penalty |
| Zone VE | Coastal high | 1.5–2.4 | ⚠️ Flag + −1.0 dimension penalty |
| Zone V | Coastal high | 1.0–1.9 | ⚠️ Flag + −1.0 dimension penalty |
| Unknown / not retrieved | 5.0 (Low confidence) | Note gap |

### Sub-metric 7c: Air quality (weight: 20%)

EPA AirNow annual AQI and category:

| AQI | Category | Sub-score | Anchor |
|-----|----------|-----------|--------|
| 0–50 | Good | 9.0–10.0 | None |
| 51–100 | Moderate | 7.0–8.9 | None |
| 101–150 | Unhealthy for Sensitive Groups | 5.0–6.9 | None |
| 151–200 | Unhealthy | 3.0–4.9 | −1.0 dimension penalty |
| 201–300 | Very Unhealthy | 1.5–2.9 | −1.0 dimension penalty |
| 301+ | Hazardous | 1.0–1.4 | −1.0 dimension penalty |
| Not retrieved | 5.0 (Low confidence) | Note gap |

### Sub-metric 7d: Noise environment (weight: 15%)

Bureau of Transportation Statistics National Transportation Noise Map — 24-hour equivalent sound level (dB):

| Sound level (Ldn dB) | Sub-score | Typical context |
|---------------------|-----------|----------------|
| < 45 dB | 9.5–10.0 | Quiet residential |
| 45–49 dB | 8.0–9.4 | Moderately quiet |
| 50–54 dB | 6.5–7.9 | Slight road or air noise |
| 55–59 dB | 5.0–6.4 | Noticeable noise |
| 60–64 dB | 3.5–4.9 | Significant noise exposure |
| 65–69 dB | 2.5–3.4 | High noise (EPA threshold) |
| ≥ 70 dB | 1.0–2.4 | Very high noise |
| Not retrieved | 6.0 (Low confidence) | Default to moderate |

### Sub-metric 7e: 311 complaint density (weight: 15%)

311 calls per 1,000 residents, normalized by category (noise, sanitation, housing violations, street conditions):

| Complaint density (per 1K residents/year) | Sub-score |
|-------------------------------------------|-----------|
| < 20 | 8.5–10.0 |
| 20–39 | 7.0–8.4 |
| 40–69 | 5.5–6.9 |
| 70–99 | 4.5–5.4 |
| 100–149 | 3.5–4.4 |
| ≥ 150 | 1.5–3.4 |
| City 311 data unavailable | 5.0 (Low confidence) |

*311 data is only available for cities with open data portals (NYC, Chicago, SF, Boston, DC, Seattle, etc.). For unavailable cities, mark Low confidence and use default.*

---

## Dimension 8: Demographic Character & Trajectory

### Trajectory composite (weight: 40% of Dimension 8)

See `scoring/trajectory-methodology.md` for full trajectory calculation. Summary scores:

| Trajectory composite | Sub-score | Interpretation |
|---------------------|-----------|---------------|
| 0.8–1.0 (strong ascending) | 8.0–10.0 | Significant above-metro appreciation/growth |
| 0.6–0.79 (moderately ascending) | 6.0–7.9 | Modest above-metro indicators |
| 0.4–0.59 (stable) | 4.5–5.9 | Tracking metro; stable |
| 0.2–0.39 (moderately declining) | 3.0–4.4 | Below-metro indicators |
| 0.0–0.19 (declining) | 1.0–2.9 | Significant below-metro signals |

---

## Dimension 9: Business Environment

### Sub-metric 9a: Business density (weight: 30%)

Census CBP establishments per km² relative to county:

| Establishments per km² | Sub-score | Typical context |
|-----------------------|-----------|----------------|
| > 100 | 9.0–10.0 | Dense commercial district |
| 50–100 | 7.5–8.9 | Active commercial corridor |
| 25–49 | 6.0–7.4 | Mixed commercial/residential |
| 10–24 | 4.5–5.9 | Light commercial |
| 5–9 | 3.5–4.4 | Sparse commercial |
| < 5 | 1.5–3.4 | Primarily residential, minimal commercial |

---

## Missing data protocol

For any sub-metric where data collection failed:

1. **Record in output.md:** "Sub-metric [name]: DATA NOT RETRIEVED — [reason attempted]"
2. **Assign default score:** 5.0 (median) unless an absolute threshold has been triggered
3. **Assign confidence:** Low
4. **Flag in scorecard:** List all Low-confidence sub-metrics in the scorecard header
5. **Do not guess:** Never estimate a sub-metric score based on intuition about the address

The resulting composite will be tagged: "⚠️ Low confidence in [N] dimensions — [list]"

---

*LOCUS Scoring Rubric — BHIL LOCUS Framework v1.0*
