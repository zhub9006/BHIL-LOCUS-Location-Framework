---
template: prompt
id: P02
title: Food, Drink & Social Collection
dimension: D2
version: "1.0"
depends_on: [P01]
outputs: [p02-food-social-output.md, citations.md]
estimated_time: "8–12 minutes"
web_search_queries: 6–8
---

# P02 — Food, Drink & Social

**Dimension:** D2 · Food, Drink & Social Life
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Collect structured data on the food, beverage, and social amenity landscape within 400m, 800m, and 1500m of the subject address to score D2 and populate the POI inventory.

---

## Pre-Flight

1. Confirm engagement workspace: `engagements/{{ENGAGEMENT_ID}}/`
2. Confirm P01 output exists: `engagements/{{ENGAGEMENT_ID}}/p01-walkability-geospatial-output.md`
3. Load address from `engagement-metadata.md`
4. Open `citations.md` — append new rows; do not overwrite

---

## Data Collection Steps

### Step 1 — Restaurant Density & Cuisine Diversity (WebSearch + WebFetch)

**Search queries to run (run all, record results):**

```
Query A: restaurants near [STREET ADDRESS, CITY STATE] site:maps.google.com OR yelp.com
Query B: "restaurants" "[CITY]" "[NEIGHBORHOOD]" diversity cuisine types
Query C: coffee shops cafes near [STREET ADDRESS, CITY STATE]
```

**Collect for each restaurant/cafe found:**
- Name, category/cuisine, approximate distance, rating (if available), price tier
- Assign POI ID: `POI-{{ENGAGEMENT_ID}}-NNN` (sequential from P01 endpoint)
- Record citation row for each data source used

**Target collection:**
- Minimum 10 restaurants within 1500m (if present)
- All coffee shops within 800m
- Count unique cuisine categories (use standard taxonomy: American, Mexican, Asian-broadly, etc.)

---

### Step 2 — Overpass API — Food POIs (Bash)

Run Overpass API query for amenity food/drink tags within 1500m radius:

```bash
LOCUS_LAT="[LAT_FROM_P01]"
LOCUS_LON="[LON_FROM_P01]"

curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json][timeout:30];
    (
      node[\"amenity\"~\"restaurant|cafe|bar|pub|fast_food|food_court|ice_cream\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
      way[\"amenity\"~\"restaurant|cafe|bar|pub|fast_food\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
    );
    out center;" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
elements = data.get('elements', [])
counts = {}
for e in elements:
    t = e.get('tags', {}).get('amenity', 'unknown')
    counts[t] = counts.get(t, 0) + 1
print(f'Total food/drink POIs: {len(elements)}')
for k,v in sorted(counts.items(), key=lambda x: -x[1]):
    print(f'  {k}: {v}')
"
```

Record: total count by type, raw JSON for POI inventory.
Citation: OpenStreetMap / Overpass API, access date today.

---

### Step 3 — Bar, Brewery & Nightlife (WebSearch)

```
Query D: bars breweries nightlife near [STREET ADDRESS, CITY STATE]
Query E: [NEIGHBORHOOD NAME] bars restaurants "happy hour"
```

Collect: Name, type (bar/brewery/wine bar/cocktail), distance estimate.
Note: Nightlife density matters for Young Professional and Remote Worker personas; less weight for Family/Retiree.

---

### Step 4 — Cultural Venues (WebSearch)

```
Query F: museums galleries theaters live music venues near [STREET ADDRESS, CITY STATE]
```

Collect: Name, type, approximate distance.
Target: Any cultural venue within 3000m (cultural venues have wider catchment).

---

### Step 5 — Quality Signal (WebSearch/WebFetch)

If Yelp results available:
- Collect average star ratings for top 10 restaurants by proximity
- Calculate simple average as quality signal

If not available: mark quality_signal as "unavailable — use default 7.0/10"
Citation: Yelp.com, accessed [DATE].

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p02-food-social-output.md`

```markdown
---
prompt: P02
engagement_id: {{ENGAGEMENT_ID}}
dimension: D2
completed: [ISO_DATE]
---

# P02 Output — Food, Drink & Social

## Raw Counts
- Restaurants within 400m: [N]
- Restaurants within 800m: [N]
- Restaurants within 1500m: [N]
- Unique cuisine categories: [N]
- Coffee/tea shops within 800m: [N]
- Bars/breweries within 800m: [N]
- Cultural venues within 3000m: [N]
- Average restaurant rating: [X.X] / 5.0 (source: [SOURCE])

## POI Inventory — D2
[TABLE: POI ID | Name | Category | Distance | Rating | Citation]

## Scoring Inputs for D2
- Restaurant density raw score input: [N per sq km, calculated]
- Cuisine diversity input: [N unique categories]
- Coffee access: [nearest distance in meters]
- Cultural venue access: [nearest distance]
- Nightlife density: [count within 800m]
- Quality signal: [avg rating or "unavailable"]

## Data Quality Notes
[Any gaps, fallback sources, low-confidence entries]

## Citations Added (P02)
[List new CIT-NNN entries added to citations.md]
```

---

## Update citations.md

Append all new citation rows. Required minimum: 3 citations for D2.
Required attribution if Walk Score used in any P02 search result: per `integration/compliance.md`.

---

## Update engagement-metadata.md

Set `P02_food_drink_social: true` in progress block.
Set `last_updated` to today's date.

---

## Common Issues

| Issue | Resolution |
|-------|-----------|
| Google Maps results don't give distance | Use Overpass count + WebSearch cross-reference |
| Yelp blocked / paywalled | Use Google Maps ratings or mark unavailable |
| Rural address — very few POIs | Score using absolute thresholds, not percentile; note in Data Quality |
| Chain-dominated results | Record names; cuisine diversity counts chains separately |

---

*P02 complete → proceed to P03 (Recreation & Green Space)*
