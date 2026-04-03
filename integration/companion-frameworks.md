---
id: LOCUS-INTEGRATION-COMPANIONS
title: "LOCUS Companion Framework Integration"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Companion Framework Integration

## Overview

LOCUS is designed as a component in the broader BHIL intelligence ecosystem, not a standalone product. The location intelligence it produces directly feeds four companion frameworks, and it draws on established BHIL methodology patterns (traceability IDs, YAML frontmatter, engagement-based workspaces) that work consistently across the ecosystem.

This document defines the integration specifications for each companion framework relationship.

---

## Framework map

```
                    ┌─────────────────────────────────┐
                    │         BHIL Ecosystem           │
                    └─────────────────────────────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
          ┌───▼───┐            ┌────▼────┐           ┌────▼────┐
          │ LOCUS │            │ VANTAGE │           │  CODEX  │
          │(Location│          │(Digital │           │(Corporate│
          │ Intel) │           │ Audit)  │           │Dossier) │
          └───┬───┘            └────┬────┘           └────┬────┘
              │                     │                     │
              └──────────┬──────────┘                     │
                         │                                │
                    ┌────▼────┐                    ┌──────▼─────┐
                    │SENTINEL │                    │  VERDICT   │
                    │(Property│                    │(Fund Due   │
                    │ Intel)  │                    │Diligence)  │
                    └─────────┘                    └────────────┘
```

**LOCUS provides the community/location layer** that each companion framework requires to contextualize property, digital, corporate, or fund intelligence.

---

## LOCUS → SENTINEL (Property Asset Intelligence)

### Relationship

SENTINEL analyzes the property itself — physical condition, valuation, title history, structural risk. LOCUS provides the community context that SENTINEL cannot generate internally: walkability, school access, neighborhood trajectory, safety data.

A complete property intelligence package combines:
- SENTINEL: What is this property worth and what are its physical risks?
- LOCUS: What kind of location supports (or limits) this property's value?

### Integration point

LOCUS engagement outputs feed the `neighborhood_context` section of the SENTINEL property analysis template. The integration is read-only — SENTINEL references LOCUS data but does not modify it.

**SENTINEL template section:**

```yaml
# In SENTINEL-PROP-NNN engagement metadata
community_intelligence:
  source: LOCUS-ENG-{NNN}
  dossier: LOCUS-DOS-{NNN}
  locus_score: [composite score]
  persona: [persona used]
  key_inputs:
    walkability_score: [score]
    education_score: [score]
    safety_score: [score]
    trajectory_score: [score]
    transit_score: [score]
  retrieved: "[date of LOCUS collection]"
  valid_until: "[shortest validity window from LOCUS citations]"
```

**SENTINEL narrative uses LOCUS data as:**
- Walkability score → "community amenity context" section
- Education score → "school district quality" for residential properties
- Safety score → "neighborhood risk context" alongside property-specific risk
- Trajectory score → "market trajectory support" for valuation opinion

### LOCUS data currency for SENTINEL

SENTINEL property analyses should be re-run if LOCUS data is more than:
- 90 days old (Walk Score may have changed)
- 30 days old in high-velocity markets (Zillow ZHVI moves fast)
- 12 months old (school ratings, ACS demographics)

The LOCUS `valid_until` field in SENTINEL metadata flags when refresh is needed.

### Cross-traceability

```
LOCUS-ENG-003 → SENTINEL-PROP-012
```

Both documents record this link. An auditor can move in both directions: from a SENTINEL claim about neighborhood safety → LOCUS-ENG-003 → citations.md → FBI UCR source URL.

---

## LOCUS → VANTAGE (Digital Audit)

### Relationship

VANTAGE audits a business or brand's digital presence, reputation, and AEO (AI Engine Optimization) positioning. For commercial-district VANTAGE engagements, LOCUS P09 (Business Environment) provides the physical-world context that digital signals alone cannot supply.

The insight: A business may have weak digital presence in a strong commercial corridor (opportunity) or strong digital presence in a declining corridor (risk). Comparing LOCUS P09 signals with VANTAGE digital metrics reveals this gap.

### Integration point

**VANTAGE uses from LOCUS:**
- P09: Business density, commercial corridor health, foot traffic proxies
- P02: Restaurant and retail review density (digital review ecosystem health)
- P08: Neighborhood trajectory (commercial investment context)

**LOCUS uses from VANTAGE (where available):**
- Digital review sentiment for businesses in the POI inventory (enhances P02 scoring)
- Business digital presence scores as a supplementary commercial vitality signal for P09

### Integration field

```yaml
# In VANTAGE engagement metadata
physical_context:
  source: LOCUS-ENG-{NNN}
  business_density: [Census CBP figure]
  commercial_vitality_score: [LOCUS P09 score]
  corridor_trajectory: [ascending | stable | declining]
  review_ecosystem_density: [LOCUS P02 data]
```

### Key analytical pattern: Physical-Digital Gap Analysis

When a LOCUS engagement covers an area with VANTAGE clients:

```
LOCUS P09 Commercial Vitality: 7.2 (active, dense, ascending)
VANTAGE Digital Presence Score: 4.1 (weak digital footprint)

Gap: Strong physical presence, weak digital → opportunity for digital investment
```

---

## LOCUS → CODEX (Corporate Dossier)

### Relationship

CODEX produces intelligence dossiers on companies, executives, and competitive landscapes. For enterprise relocation intelligence and site selection contexts, LOCUS provides the location intelligence component of the "operating environment" section.

This is the highest-volume integration pathway for Enterprise SKU LOCUS engagements — a corporate CODEX dossier evaluating company headquarters relocation requires LOCUS Complete analyses for each candidate city/site.

### Integration point

**CODEX uses from LOCUS:**
- Full dossier reference (LOCUS-DOS-NNN) as the location intelligence source
- Scorecard composite for executive summary
- Dimension scores for operating environment sections:
  - Walkability → talent attraction signal (YP and young professional labor pool)
  - Education → family-tier talent retention
  - Transit → commute infrastructure for employee base
  - Business Environment → commercial ecosystem, competition, supply chain
  - Trajectory → long-term location quality trend

### Enterprise LOCUS + CODEX workflow

```
Step 1: CODEX identifies 3–5 candidate cities/sites for relocation evaluation
Step 2: LOCUS Enterprise SKU runs Complete analysis for each candidate address
         → LOCUS-ENG-010 (Seattle HQ candidate)
         → LOCUS-ENG-011 (Portland candidate)
         → LOCUS-ENG-012 (Denver candidate)
Step 3: LOCUS comparative-template.md normalizes scores across all candidates
Step 4: CODEX operating environment section references comparative table
         → "Seattle candidate scores highest on Transit (8.5) and Business Env (8.1)"
         → "Denver candidate scores highest on trajectory (8.8) and Walkability (7.9)"
Step 5: CODEX synthesizes with talent market, tax, regulatory, and cultural data
```

### Cross-traceability

```
LOCUS-ENG-010, LOCUS-ENG-011, LOCUS-ENG-012 → CODEX-ENT-007
```

---

## LOCUS → VERDICT (Fund Due Diligence)

### Relationship

VERDICT performs due diligence on real estate funds, private equity real estate vehicles, and specific portfolio assets. LOCUS P08 (Demographic Trajectory) and P09 (Business Environment) provide the neighborhood-level market intelligence that institutional underwriting requires but rarely assembles systematically.

**VERDICT uses LOCUS for:**
- Submarket quality assessment (LOCUS composite as a defensible quality signal)
- Trajectory scoring (ascending/stable/declining — maps to rent growth expectations)
- Commercial vitality (industrial, office, and retail demand signals)
- Flood and environmental risk (P07 data feeds risk adjustment factors)

### Integration fields

```yaml
# In VERDICT engagement metadata for each portfolio address
location_intelligence:
  source: LOCUS-ENG-{NNN}
  locus_score: [composite — Investor persona]
  trajectory_signal: [ascending | stable | declining]
  trajectory_score: [P08 score]
  business_vitality: [P09 score]
  flood_zone: [FEMA designation]
  aqi_band: [Good | Moderate | Unhealthy-SG | Unhealthy]
  school_score: [P05 — relevant for residential]
  comparable_to: [NCREIF submarket grade if available]
```

**Why Investor persona:** VERDICT always uses the Investor persona weights (25% trajectory + 17% business environment = 42% of composite). This concentrates the signal on what matters for investment underwriting.

### LOCUS → VERDICT analytical mappings

| LOCUS Signal | VERDICT Application |
|-------------|---------------------|
| Trajectory 8–10 | Strong ascending — support rent growth assumption above metro average |
| Trajectory 4–5 | Stable — underwrite at metro average rent growth |
| Trajectory 1–3 | Declining — haircut rent growth assumptions; flag for strategic review |
| Civic Safety < 4.0 | Higher cap rate applied; flag for tenant quality risk |
| FEMA Zone AE/VE | Insurance cost uplift; flag for flood risk premium |
| AQI Unhealthy | ESG risk flag; potential tenant preference risk |
| Education 8+ | Strong residential demand signal; supports cap rate compression |

---

## Ecosystem consistency standards

All BHIL frameworks share these structural conventions to enable cross-framework traceability:

### Shared ID system logic

| Framework | Engagement ID | Output ID |
|-----------|-------------|----------|
| LOCUS | LOCUS-ENG-NNN | LOCUS-DOS-NNN |
| SENTINEL | SENTINEL-ENG-NNN | SENTINEL-PROP-NNN |
| VANTAGE | VANTAGE-ENG-NNN | VANTAGE-AEO-NNN |
| CODEX | CODEX-ENG-NNN | CODEX-ENT-NNN |
| VERDICT | VERDICT-ENG-NNN | VERDICT-FUND-NNN |

### Shared YAML frontmatter fields

All BHIL frameworks use these standard fields:
- `engagement_id`
- `status` (in-progress | complete | delivered | archived)
- `initiated_at` (ISO timestamp)
- `downstream_references` (array of framework-id pairs)
- `human_review` (attestation block)

### Cross-framework citation standard

When a downstream framework references LOCUS data:
```
[Source: LOCUS-ENG-003, claim: Walk Score® 87, original source: walkscore.com, retrieved 2026-04-01]
```

The original source is always preserved. LOCUS is an intermediary, not a primary source.

---

*LOCUS Companion Framework Integration — BHIL LOCUS Framework v1.0*
