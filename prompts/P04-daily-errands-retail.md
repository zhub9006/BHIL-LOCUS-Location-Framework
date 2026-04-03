---
template: prompt
id: P04
title: Daily Errands & Retail Collection
dimension: D4
version: "1.0"
depends_on: [P01, P02, P03]
outputs: [p04-errands-retail-output.md, citations.md]
estimated_time: "6–8 minutes"
web_search_queries: 4–6
---

# P04 — Daily Errands & Retail

**Dimension:** D4 · Daily Errands & Retail
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Assess the "errand runnability" of the subject address — how much of daily life can be conducted on foot or within short distance. Key inputs to the Walk Score® "errands" model and D4 scoring.

---

## Pre-Flight

1. Confirm lat/lon from P01
2. Continue POI ID sequence from P03 endpoint
3. Grocery access is the highest-weight sub-metric — prioritize

---

## Data Collection Steps

### Step 1 — Grocery Access (WebSearch + Overpass)

**WebSearch:**
```
Query A: grocery stores supermarkets near [STREET ADDRESS, CITY STATE]
Query B: Whole Foods Trader Joes Safeway Kroger [CITY] [ZIP] near [NEIGHBORHOOD]
```

**Overpass — grocery within 1500m:**
```bash
LOCUS_LAT="[LAT_FROM_P01]"
LOCUS_LON="[LON_FROM_P01]"

curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json][timeout:25];
    (
      node[\"shop\"~\"supermarket|grocery|convenience|butcher|bakery|deli\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
      way[\"shop\"~\"supermarket|grocery\"](around:1500,${LOCUS_LAT},${LOCUS_LON});
    );
    out center tags;" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
for e in data.get('elements', []):
    tags = e.get('tags', {})
    print(tags.get('name','[unnamed]'), '|', tags.get('shop','?'))
"
```

**Classify by tier:**
- Tier 1 (full-service): Traditional supermarket, warehouse club, natural/organic grocery
- Tier 2 (specialty): Butcher, fish market, produce market, ethnic grocery
- Tier 3 (convenience): Convenience store, mini-mart, dollar store with food

Record nearest Tier 1 distance. Binary flag: Tier 1 within 800m (yes/no).

---

### Step 2 — Pharmacy Access (WebSearch)

```
Query C: pharmacy drugstore CVS Walgreens Rite Aid near [STREET ADDRESS, CITY STATE]
```

Record: Nearest pharmacy name + distance. Binary: pharmacy within 800m.

---

### Step 3 — Healthcare Access (WebSearch)

```
Query D: urgent care primary care clinic hospital near [STREET ADDRESS, CITY STATE]
```

Collect:
- Nearest primary care / urgent care: name, distance
- Nearest hospital / ER: name, distance
- Dental: name, distance (if easily found)

Note: This is a meaningful sub-metric for Retiree and Family personas.

---

### Step 4 — Banking & Financial Services (WebSearch/Overpass)

Overpass within 800m:
```bash
curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json][timeout:20];
    node[\"amenity\"~\"bank|atm\"](around:800,${LOCUS_LAT},${LOCUS_LON});
    out tags;" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
elems = data.get('elements', [])
print(f'Banks/ATMs within 800m: {len(elems)}')
"
```

Record: Count of banks + ATMs within 800m.

---

### Step 5 — General Retail Density (WebSearch)

```
Query E: shopping retail stores near [STREET ADDRESS, CITY STATE]
```

Characterize: Is there a retail district, strip mall, or shopping center within 1500m?
Note any anchor retailers (Target, Costco, Home Depot) within 3000m.

---

### Step 6 — Hardware / Home Goods (WebSearch)

```
Query F: hardware store home goods near [STREET ADDRESS, CITY STATE]
```

Record: Name, distance. Binary: hardware/home goods within 3000m.

---

## Scoring Inputs Required

| Sub-metric | Key Data Points |
|------------|----------------|
| Grocery access | Tier 1 grocery distance; binary within 800m |
| Pharmacy access | Nearest distance; binary within 800m |
| Healthcare access | Nearest urgent care distance; nearest hospital distance |
| General retail | Retail district presence; anchor stores within 3km |
| Banking | Count banks/ATMs within 800m |

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p04-errands-retail-output.md`

```markdown
---
prompt: P04
engagement_id: {{ENGAGEMENT_ID}}
dimension: D4
completed: [ISO_DATE]
---

# P04 Output — Daily Errands & Retail

## Essential Access Summary
- Full-service grocery (Tier 1): [NAME] — [N] m ☐ Within 800m
- Pharmacy: [NAME] — [N] m ☐ Within 800m
- Urgent care / primary care: [NAME] — [N] m
- Hospital / ER: [NAME] — [N] m
- Banks/ATMs within 800m: [N]
- Hardware/home goods within 3km: ☐ Yes / [NAME]
- Retail district within 1500m: ☐ Yes ☐ No

## POI Inventory — D4
[TABLE: POI ID | Name | Category | Tier | Distance | Citation]

## Errands Car-Free Assessment
[One paragraph: can essential errands (grocery, pharmacy, healthcare) be accomplished without a car? Base on distances and pedestrian infrastructure from P01.]

## Scoring Inputs for D4
- Grocery score input: [distance to Tier 1] m / binary: [Y/N]
- Pharmacy score input: [distance] m / binary: [Y/N]
- Healthcare score input: [urgent care distance] m, [hospital distance] m
- Retail density input: [district presence + anchor stores]
- Banking input: [count within 800m]

## Data Quality Notes
[Gaps, fallbacks, confidence]

## Citations Added (P04)
[List new CIT-NNN entries]
```

---

## Update engagement-metadata.md

Set `P04_daily_errands_retail: true`.

---

*P04 complete → proceed to P05 (Education) or P06 (Transportation) per workflow tier*
