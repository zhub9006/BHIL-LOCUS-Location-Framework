---
id: LOCUS-SKU-TIERS
title: "LOCUS SKU Tier Definitions"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS SKU Tier Definitions

## Overview

LOCUS offers four analysis tiers that reflect the depth of data collection, number of prompts executed, and turnaround time. Tier selection should be made before engagement initialization, as it determines which directory structure is created and which prompts are queued.

---

## Express (P00 only)

**Purpose:** Rapid location screening using web search data only. No specialist prompts, no API calls, no engagement workspace.

**When to use:**
- Initial location filtering before investing in Full/Complete analysis
- Situations where 80% accuracy is acceptable and time is the constraint
- Quick client demos of LOCUS capabilities
- Preliminary research before a site visit

**What runs:** P00 (Master LOCUS Orchestration) only

**Data sources:** Web search snippets, walkscore.com direct fetch, Google/Yelp public pages

**Limitations:**
- No Census FIPS codes (no ACS demographic data)
- No Overpass API POI inventory (no precision POI counts)
- No FEMA API flood zone confirmation
- No EPA AirNow AQI data
- Scores based on web search data quality — Medium confidence
- No structured citations log

**Output:**
- Single output file: `LOCUS-EXPRESS-[address-slug].md`
- Quick LOCUS Score estimate with Medium confidence disclaimer
- Key findings list
- Notable amenities from search results
- Full analysis upgrade recommendation

**Turnaround:** ~15 minutes

**Invocation:** "Run Express LOCUS for [address]" or "Quick LOCUS [address]"

---

## Full (7 prompts)

**Purpose:** Standard residential advisory analysis. Covers the core dimensions that drive most residential location decisions without the depth of Complete.

**When to use:**
- Standard residential relocation advisory
- Single-family or condo buyer research
- Rental market assessment for individual tenants
- Situations where 90-minute analysis is not warranted

**What runs:** P00 + P01 + P02 + P05 + P06 + P08 + P10

| Prompt | Dimension | Rationale for inclusion |
|--------|-----------|------------------------|
| P00 | Orchestration | Always required |
| P01 | Walkability & Geospatial | Foundation — provides FIPS + coordinates for all ACS joins |
| P02 | Food, Drink & Social | Core lifestyle dimension — high weight for most personas |
| P05 | Education | High weight for Family persona; included by default |
| P06 | Transportation & Commute | High weight for Young Professional; universal relevance |
| P08 | Demographics & Trajectory | Market direction signal |
| P10 | Synthesis | Always required for scored output |

**What's excluded from Full tier:**
- P03 (Recreation) — included in narrative via P01 Overpass data
- P04 (Daily Errands) — partially covered by P01 amenity inventory
- P07 (Civic Infrastructure) — safety signal partially from P08 data
- P09 (Business Environment) — not included; Investor persona only

**Scoring note:** Dimensions excluded from Full tier receive a score of 5.0 (median, Medium confidence) in the composite calculation. The scorecard notes which dimensions were not analyzed.

**Output:**
- Engagement workspace with 7 prompt directories
- Scorecard with 9 dimensions (7 analyzed, 2 at median default)
- Day in the Life narrative (300-word version)
- Final dossier (abbreviated Dimension Analyses for excluded prompts)
- Citations log

**Turnaround:** ~45 minutes

**Invocation:** "Run Full tier for LOCUS-ENG-NNN" or "Run Full LOCUS for [address]"

---

## Complete (11 prompts)

**Purpose:** Comprehensive analysis of all 9 dimensions with full data collection depth and a complete "Day in the Life" narrative.

**When to use:**
- Comprehensive residential relocation advisory
- Commercial real estate site evaluation
- Investment due diligence (single asset)
- Corporate employee relocation packet
- Situations where analytical defensibility is critical

**What runs:** All 11 prompts (P00 through P10)

**Execution plan:**

```
Phase 1 — Foundation (sequential, ~10 min):
  P00: Initialize workspace
  P01: Geospatial baseline + FIPS codes

Phase 2 — POI Collection (parallel-capable, ~20 min):
  P02: Food, drink, social scene
  P03: Recreation and green space
  P04: Daily errands and retail

Phase 3 — Infrastructure Analysis (parallel-capable, ~20 min):
  P05: Education profiling
  P06: Transportation and commute
  P07: Civic infrastructure and safety

Phase 4 — Market Intelligence (parallel-capable, ~15 min):
  P08: Demographics and trajectory
  P09: Business environment

Phase 5 — Synthesis (sequential, ~15 min):
  P10: Scoring + narrative + dossier assembly
```

**Output:**
- Full engagement workspace with all 11 prompt directories
- Complete scorecard with all 9 dimensions at High/Medium confidence
- Day in the Life narrative (500-word version)
- Full final dossier with complete Dimension Analyses
- Data currency table with all source validity windows
- Complete citations log (typically 40–80 source rows)

**Turnaround:** ~90 minutes

**Invocation:** "Run Complete tier for LOCUS-ENG-NNN" or "Run full LOCUS analysis for [address]"

---

## Enterprise (Complete × N + comparative)

**Purpose:** Multi-address comparative analysis for corporate relocation decisions, portfolio intelligence, or market-area assessments requiring apples-to-apples comparison across multiple candidate locations.

**When to use:**
- Corporate headquarters or regional office relocation (compare 3–5 cities/sites)
- Real estate portfolio health assessment (multiple assets)
- Employee relocation program (compare candidate neighborhoods for relocated employees)
- Market area assessment (compare neighborhoods within a metro)
- Competitive site selection (retail, restaurant, healthcare)

**What runs:** Complete tier for each address, plus comparative synthesis

**Execution structure:**

```
For each address (N addresses):
  Engagement ID: LOCUS-ENG-{NNN+0}, LOCUS-ENG-{NNN+1}, ... LOCUS-ENG-{NNN+N-1}
  All 11 prompts execute per address
  Each address produces a standalone LOCUS dossier

Comparative phase:
  Load all scorecard files
  Normalize scores to same comparison set (use largest MSA if cross-metro)
  Generate comparative-template.md output
  Identify dimension leaders and laggards per address
  Generate executive comparative summary
```

**Comparative output template** (`templates/comparative-template.md`):

```markdown
# LOCUS Comparative Analysis — [N] Addresses

**Persona:** [persona]
**Analysis date:** [date]

## Summary ranking

| Rank | Address | LOCUS Score | Best Dimension | Weakest Dimension |
|------|---------|-------------|---------------|------------------|
| 1 | [address] | [score] | [dimension] | [dimension] |
| 2 | ... | | | |

## Dimension comparison matrix

| Dimension | [Address 1] | [Address 2] | [Address 3] |
|-----------|-------------|-------------|-------------|
| Walkability | [score] | [score] | [score] |
| Food/Social | ... | | |
| [all 9 dimensions] | | | |
| **COMPOSITE** | **[score]** | **[score]** | **[score]** |

## Persona-fit analysis

[For each address: 2–3 sentences on how well it matches the selected persona]

## Recommendation context

[Factual summary of tradeoffs. No recommendation — present data only.]
[Include disclaimer: "Selection decisions should involve human advisory and site visits."]
```

**Turnaround:** ~90 minutes per address + ~30 minutes comparative synthesis
- 3 addresses: ~5 hours total
- 5 addresses: ~8 hours total

**Invocation:** "Run Enterprise tier for [address1], [address2], [address3] — persona: [persona]"

---

## Tier selection guide

Ask these questions to determine the right tier:

```
Q1: Is this for quick screening or a real decision?
  → Quick screening: Express
  → Real decision: proceed to Q2

Q2: How many dimensions matter to this client?
  → Walkability + dining + transit + schools + trajectory only: Full
  → All 9 dimensions matter: Complete

Q3: Are multiple locations being compared?
  → Yes, 2+ locations: Enterprise
  → No: Complete

Q4: Is this for institutional investment or corporate relocation?
  → Yes: Complete or Enterprise (defensibility requirement)
  → No: Full may suffice
```

---

## Tier comparison table

| Feature | Express | Full | Complete | Enterprise |
|---------|---------|------|----------|-----------|
| Prompts | 1 | 7 | 11 | 11 per address + comparative |
| FIPS codes | No | Yes | Yes | Yes |
| API data collection | No | Yes | Yes | Yes |
| Dimensions scored | 9 (estimated) | 7 (2 default) | 9 | 9 per address |
| Citation log | No | Yes | Yes | Yes per address |
| Day in the Life | No | Short | Full | Full per address |
| Comparative analysis | No | No | No | Yes |
| Fair Housing validation | Web only | Full | Full | Full |
| Human review required | Recommended | Required | Required | Required |
| Confidence level | Medium | High/Medium | High | High |
| Typical turnaround | 15 min | 45 min | 90 min | 5–8 hours |

---

*LOCUS SKU Tier Definitions — BHIL LOCUS Framework v1.0*
