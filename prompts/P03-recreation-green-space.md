---
template: prompt
id: P03
title: Recreation & Green Space Collection
dimension: D3
version: "1.0"
depends_on: [P01, P02]
outputs: [p03-recreation-output.md, citations.md]
estimated_time: "6–10 minutes"
web_search_queries: 5–7
---

# P03 — Recreation & Green Space

**Dimension:** D3 · Recreation & Green Space
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Collect data on parks, trails, green space, and fitness/recreation facilities accessible from the subject address to score D3.

---

## Pre-Flight

1. Confirm engagement workspace exists
2. Confirm lat/lon from P01 output
3. Continue POI ID sequence from P02 endpoint

---

## Data Collection Steps

### Step 1 — Overpass API — Parks & Green Space (Bash)

```bash
LOCUS_LAT="[LAT_FROM_P01]"
LOCUS_LON="[LON_FROM_P01]"

# Parks within 800m
curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json][timeout:30];
    (
      node[\"leisure\"~\"park|garden|playground|dog_park|nature_reserve\"](around:800,${LOCUS_LAT},${LOCUS_LON});
      way[\"leisure\"~\"park|garden|playground|dog_park|nature_reserve\"](around:800,${LOCUS_LAT},${LOCUS_LON});
      relation[\"leisure\"~\"park|garden\"](around:800,${LOCUS_LAT},${LOCUS_LON});
    );
    out center tags;" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
elements = data.get('elements', [])
print(f'Green space features within 800m: {len(elements)}')
for e in elements[:20]:
    tags = e.get('tags', {})
    name = tags.get('name', '[unnamed]')
    ltype = tags.get('leisure', tags.get('landuse', '?'))
    print(f'  {ltype}: {name}')
"
```

Citation: OpenStreetMap / Overpass API, access date today.

---

### Step 2 — Trust for Public Land & Park Score (WebSearch/WebFetch)

```
Query A: "[CITY STATE]" park score trust public land parkserve
Query B: site:parkserve.tpl.org "[CITY]" park access 10-minute walk
```

Attempt to fetch ParkServe score for the city/census tract if available.
ParkServe URL pattern: `https://parkserve.tpl.org/mapping/`

Record: City park score (% residents within 10-min walk), if available.
Citation: Trust for Public Land ParkServe.

---

### Step 3 — Named Parks & Green Space Detail (WebSearch)

```
Query C: parks near [STREET ADDRESS, CITY STATE] acres amenities
Query D: "[NEAREST PARK NAME FROM STEP 1]" [CITY] amenities hours
```

For top 3–5 parks:
- Confirm name, type, acreage (if available), amenities (playground, dog park, sports fields, picnic)
- Confirm walking distance estimate

---

### Step 4 — Trails & Paths (WebSearch)

```
Query E: hiking biking trails near [STREET ADDRESS, CITY STATE]
Query F: AllTrails "[CITY STATE]" trails [NEIGHBORHOOD]
```

Attempt WebFetch on AllTrails search results page if URLs returned.
Collect: Trail name, type (paved/unpaved), length, distance to trailhead.

---

### Step 5 — Fitness Facilities (WebSearch)

```
Query G: gyms fitness centers yoga near [STREET ADDRESS, CITY STATE]
```

Collect: Name, type (gym/yoga/CrossFit/YMCA), distance.
YMCA presence is notable for Family and Retiree personas.

---

### Step 6 — Recreation Programming (WebSearch)

```
Query H: recreation center programs [CITY] near [ZIP CODE]
```

Check for: City recreation centers, senior centers (Retiree persona), youth sports leagues (Family persona).
Record: Presence/absence + distance.

---

## Scoring Inputs Required

| Sub-metric | What to Calculate |
|------------|-----------------|
| Park proximity | Distance to nearest named park (meters) |
| Green space acreage | Sum of park acreage within 800m (estimate if exact unknown) |
| Trail access | Distance to nearest trail access point (meters) |
| Fitness facility | Count of gyms/fitness within 800m |
| Recreation programming | Binary: city rec center within 1500m + programming quality estimate |

**Acreage estimation:** If exact acreage unavailable, use park footprint:
- Small neighborhood park: estimate 1–3 acres
- Medium community park: estimate 5–20 acres
- Large regional park: estimate 50+ acres
Note estimation in data quality.

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p03-recreation-output.md`

```markdown
---
prompt: P03
engagement_id: {{ENGAGEMENT_ID}}
dimension: D3
completed: [ISO_DATE]
---

# P03 Output — Recreation & Green Space

## Raw Counts & Measurements
- Parks/green space features within 800m: [N]
- Named parks within 800m: [list]
- Total estimated green space acreage within 800m: [X] acres
- Trail access: [nearest trailhead distance] m / [trail name]
- Fitness facilities within 800m: [N]
- City rec center within 1500m: ☐ Yes ☐ No
- TPL Park Score for [CITY]: [X]% (source: ParkServe)

## POI Inventory — D3
[TABLE: POI ID | Name | Type | Acreage | Distance | Amenities | Citation]

## Scoring Inputs for D3
- Park proximity score input: [nearest park distance in meters]
- Green space acreage input: [total acres within 800m]
- Trail access input: [distance in meters]
- Fitness facility input: [count within 800m]
- Recreation programming input: [present/absent + quality note]

## Data Quality Notes
[Acreage estimates, unavailable data, fallbacks used]

## Citations Added (P03)
[List new CIT-NNN entries]
```

---

## Update engagement-metadata.md

Set `P03_recreation_green_space: true`.

---

## Common Issues

| Issue | Resolution |
|-------|-----------|
| Overpass returns unnamed green spaces | Count unnamed parks at 0.5 weight; note in data quality |
| ParkServe city not indexed | Use Overpass counts as primary; note ParkServe unavailable |
| AllTrails paywalled | Use WebSearch trail mentions + distance estimate |
| Urban address — no named parks within 800m | Score park proximity low; check for plazas/squares as partial substitute |

---

*P03 complete → proceed to P04 (Daily Errands & Retail)*
