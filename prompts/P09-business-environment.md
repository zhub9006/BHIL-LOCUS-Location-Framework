---
template: prompt
id: P09
title: Business Environment Analysis
dimension: D9
version: "1.0"
depends_on: [P01, P04]
outputs: [p09-business-environment-output.md, citations.md]
estimated_time: "6–8 minutes"
web_search_queries: 4–5
---

# P09 — Business Environment

**Dimension:** D9 · Business Environment
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Profile the commercial vitality of the area: business density, anchor tenants, retail vacancy signals, employment center proximity, and coworking/startup ecosystem access. D9 is weighted highest for **Investor** (25%) and **Remote Worker** (15%); minimal for Retiree (5%).

---

## Pre-Flight

1. Load address and lat/lon from engagement-metadata.md
2. Review P04 output — some business/retail data may already be collected (avoid duplication)
3. Continue POI ID sequence from latest POI assigned

---

## Data Collection Steps

### Step 1 — Business Density via Overpass (Bash)

```bash
LOCUS_LAT="[LAT_FROM_P01]"
LOCUS_LON="[LON_FROM_P01]"

# Commercial nodes within 1500m
curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json][timeout:30];
    (
      node[\"shop\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
      node[\"office\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
      node[\"amenity\"~\"bank|post_office\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
      way[\"building\"~\"commercial|office|retail\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
    );
    out count;" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
total = data.get('elements', [{}])[0].get('tags', {}).get('total', 'N/A')
print(f'Commercial/office nodes within 1500m: {total}')
"
```

Record raw count. Use as D9 density input.

**Density benchmarks (per scoring rubric):**
- >200 commercial nodes: dense urban commercial core
- 100–200: active urban/inner-ring commercial
- 50–100: established suburban commercial
- 20–50: light suburban/mixed
- <20: auto-oriented / limited commercial

---

### Step 2 — Anchor Tenant Assessment (WebSearch)

```
Query A: major employers anchor tenants commercial district near [STREET ADDRESS, CITY STATE]
Query B: [CITY] [NEIGHBORHOOD] office buildings corporate tenants business district
```

**Anchor tiers:**
- Tier 1: Fortune 500 headquarters, major hospital system, university campus, government center
- Tier 2: Regional employer (500+ jobs), major hotel, convention center, large retail anchor
- Tier 3: Community anchors (school district office, mid-size employer, established retail)

Record: Any Tier 1 or Tier 2 anchors within 1 mile.

---

### Step 3 — Retail Vacancy Signal (WebSearch)

```
Query C: [CITY] [NEIGHBORHOOD] retail vacancy storefronts commercial real estate 2023 2024
```

Look for:
- Local news mentions of retail closures or openings
- Commercial real estate reports mentioning area vacancy rates
- Visual signals if Google Street View mentioned in search results

**Vacancy signal classification:**
- Low vacancy: multiple recent openings, limited "for lease" signals
- Moderate vacancy: some vacancies but stable
- Elevated vacancy: multiple closures, significant "for lease" inventory
- High vacancy: widespread disinvestment signals

Cite any news sources found.

---

### Step 4 — Employment Center Proximity (WebSearch)

```
Query D: major employment centers job centers near [CITY STATE] [ZIP]
```

Record:
- Nearest employment center (office park, business district, industrial corridor)
- Estimated drive/transit time from subject address
- Scale estimate (thousands of jobs)

---

### Step 5 — Coworking & Startup Access (WebSearch)

```
Query E: coworking space shared office WeWork Regus startup hub incubator near [STREET ADDRESS, CITY STATE]
```

Collect: Name, type, distance, approx price point if findable.
Highly relevant for Remote Worker persona; noted for Young Professional.

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p09-business-environment-output.md`

```markdown
---
prompt: P09
engagement_id: {{ENGAGEMENT_ID}}
dimension: D9
completed: [ISO_DATE]
---

# P09 Output — Business Environment

## Business Density
- Commercial/office nodes within 1500m (Overpass): [N]
- Density tier: [Dense urban / Active urban / Established suburban / Light suburban / Limited]

## Anchor Tenants
- Tier 1 anchors within 1 mile: [Name(s) or "None identified"]
- Tier 2 anchors within 1 mile: [Name(s) or "None identified"]

## Retail Vacancy Signal
- Vacancy characterization: [Low / Moderate / Elevated / High]
- Supporting evidence: [brief note on what signals were found]

## Employment Centers
- Nearest employment center: [NAME] — [N] miles / [N] min
- Scale estimate: [approx jobs]

## Coworking & Startup Access
- Coworking spaces within 1500m: [N]
- Names: [list or "None identified"]
- Startup ecosystem signal: [present / minimal / absent]

## Scoring Inputs for D9
- Business density input: [node count]
- Anchor tenant input: [tier of strongest anchor]
- Vacancy input: [tier]
- Employment proximity input: [drive time in minutes]
- Coworking input: [count within 1500m]

## Data Quality Notes
[Overpass accuracy limits, vacancy signal limitations, data recency]

## Citations Added (P09)
[List new CIT-NNN entries]
```

---

## Update engagement-metadata.md

Set `P09_business_environment: true`.

---

*P09 complete → proceed to P10 (Synthesis & Dossier)*
