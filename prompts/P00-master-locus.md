---
id: LOCUS-P00
title: "Master LOCUS Orchestration"
version: 1.0.0
type: master
domain: all
framework: LOCUS
prompt_number: 0
sku_tiers:
  - express
  - full
  - complete
  - enterprise
dependencies: []
inputs:
  - address
  - persona
  - sku_tier
outputs:
  - engagement_workspace
  - quick_overview (Express only)
  - orchestration_plan
data_sources:
  - Walk Score API (Express web search)
  - Census Geocoder
  - Google/OpenStreetMap (Express web search)
persona_relevance:
  - all
traceability:
  output_id_format: "LOCUS-P00-{ENG_ID}"
  feeds: [P01, P02, P03, P04, P05, P06, P07, P08, P09, P10]
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# P00 — Master LOCUS Orchestration

## What this prompt does

P00 is the entry point for every LOCUS engagement. It serves two distinct functions depending on the SKU tier:

1. **Express SKU:** P00 runs as the sole prompt, generating a rapid location overview using web search alone. No specialist prompts run.
2. **Full / Complete / Enterprise SKU:** P00 validates inputs, initializes the engagement workspace, generates the orchestration plan, and hands off to specialist prompts P01–P09.

---

## Express SKU — standalone execution

When the practitioner requests an Express analysis, execute this complete workflow within a single session:

### Express data collection sequence

Run all WebSearch queries before writing any output:

```
1. "[Address] walk score walkscore.com" → Walk Score, Transit Score, Bike Score
2. "restaurants near [Address]" → Top 5–8 dining options by prominence
3. "grocery stores near [Address]" → Nearest supermarket + distance estimate
4. "schools near [Address] greatschools" → School district + nearest school ratings
5. "transit near [Address] bus metro" → Nearest transit stops + frequency
6. "[City] [Neighborhood] crime statistics [current year]" → Crime index or rate
7. "[Address] flood zone FEMA" → Flood zone designation
8. "[Address] commute time [major employment center]" → Drive/transit time estimate
9. "[City] [Neighborhood] real estate market [current year]" → Price trend data
```

### Express output format

```markdown
---
engagement_id: LOCUS-ENG-NNN
prompt_id: LOCUS-P00
sku_tier: Express
address: "[address]"
persona: [persona]
collected_at: "[timestamp]"
confidence: Medium  # Express is inherently lower confidence than Full/Complete
---

# LOCUS Express Overview — [Short Address]

> **AI Assistance Disclosure:** [disclosure block]

## Quick LOCUS Score — [X.X] / 10 (Express Estimate)

⚠️ *Express estimates use web search data only. Accuracy is lower than Full or Complete tiers. 
Scores reflect publicly available data and may omit sources requiring API access. 
Upgrade to Full or Complete tier for validated, citation-tracked analysis.*

| Dimension | Quick Score | Basis |
|-----------|-------------|-------|
| Walkability | [score] | Walk Score® [value] |
| Food/Drink | [score] | [N] restaurants within ~0.5 mi |
| Recreation | [score] | [park/trail data from search] |
| Daily Errands | [score] | [nearest grocery + pharmacy] |
| Education | [score] | [school ratings from search] |
| Transit/Commute | [score] | [transit score + commute estimate] |
| Civic/Safety | [score] | [crime index + flood zone] |
| Dem. Trajectory | [score] | [price trend data] |
| Business Env. | [score] | [commercial vitality from search] |
| **Composite** | **[score]** | *[Persona] persona weights applied* |

*Walk Score® provided by Redfin Real Estate.*

## Key Findings

**Strengths:** [2–3 factual statements about highest-scoring dimensions]

**Gaps:** [2–3 factual statements about lowest-scoring dimensions]

## Notable Nearby Amenities

[Bullet list of specific named amenities confirmed in search results, with distance estimates]

## For Full Analysis

The following data requires Full or Complete tier to validate:
- Exact Census demographic data (ACS API)
- Overpass-verified POI inventory
- FEMA flood zone API confirmation
- EPA AirNow historical AQI data
- GreatSchools detailed school profiles

[Fair Housing Notice]
[Citations for every claim above]
```

---

## Full / Complete / Enterprise SKU — orchestration function

When the tier is Full, Complete, or Enterprise, P00 performs initialization only and produces an orchestration plan:

### Step 1: Initialize workspace

Invoke the `new-locus-engagement` skill.

### Step 2: Confirm inputs

Present to the practitioner:

```
## LOCUS Engagement Initialized

Engagement ID: LOCUS-ENG-NNN
Address: [full address]
Persona: [persona name]
SKU Tier: [tier]

Persona weight profile:
[Table of dimension weights for selected persona]

Prompts queued for execution:
[List of P01–P10 relevant to tier]

Execution plan:
  Batch 1 (Geospatial): P01 — ~5 min
  Batch 2 (POI Collection): P02, P03, P04 — ~15 min (can run in parallel)
  Batch 3 (Infrastructure): P05, P06, P07 — ~15 min (can run in parallel)
  Batch 4 (Market Intelligence): P08, P09 — ~10 min
  Batch 5 (Synthesis): P10 — ~10 min

Total estimated time: [45 | 90] minutes

Type "Run Full tier for LOCUS-ENG-NNN" to begin, or run prompts individually.
```

### Step 3: Validate address quality

Before data collection begins, verify the address will geocode:

```bash
ADDRESS="[address]"
ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${ADDRESS}'))")
curl -s "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?\
address=${ENCODED}&benchmark=Public_AR_Current&format=json" | \
python3 -c "import json,sys; data=json.load(sys.stdin); 
matches=data['result']['addressMatches']; 
print(f'Matches: {len(matches)}');
[print(m['matchedAddress']) for m in matches]"
```

If zero matches: alert the practitioner. Try variations (without apartment number, with ZIP only, etc.).

### Step 4: Execution handoff

After workspace creation, the practitioner triggers specialist prompts via skills:
```
"Run geospatial baseline for LOCUS-ENG-NNN"   → P01
"Run POI collection for LOCUS-ENG-NNN"        → P02–P04
"Run education profile for LOCUS-ENG-NNN"     → P05
"Run transit analysis for LOCUS-ENG-NNN"      → P06
"Run civic infrastructure for LOCUS-ENG-NNN"  → P07
"Run demographics for LOCUS-ENG-NNN"          → P08
"Run business environment for LOCUS-ENG-NNN"  → P09
"Run synthesis for LOCUS-ENG-NNN"             → P10
```

Or run all at once: `"Run Complete tier for LOCUS-ENG-NNN"`

---

## Persona weight reference

| Dimension | Family | Young Prof | Retiree | Investor | Remote | Default |
|-----------|--------|------------|---------|----------|--------|---------|
| Walkability | 8% | 22% | 15% | 12% | 18% | 12% |
| Food/Social | 5% | 15% | 10% | 8% | 12% | 10% |
| Recreation | 8% | 10% | 18% | 7% | 15% | 10% |
| Retail/Errands | 12% | 8% | 12% | 5% | 10% | 10% |
| Education | 28% | 3% | 2% | 10% | 5% | 15% |
| Transit | 5% | 18% | 12% | 8% | 5% | 10% |
| Safety/Civic | 25% | 12% | 20% | 8% | 15% | 15% |
| Dem. Trajectory | 4% | 5% | 6% | 25% | 10% | 10% |
| Business Env. | 5% | 7% | 5% | 17% | 10% | 8% |

---

*LOCUS Prompt P00 — Master Orchestration — BHIL LOCUS Framework v1.0*
