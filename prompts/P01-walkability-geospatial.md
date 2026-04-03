---
id: LOCUS-P01
title: "Walkability & Geospatial Baseline"
version: 1.0.0
type: specialist
domain: walkability-geospatial
framework: LOCUS
prompt_number: 1
sku_tiers: [express, full, complete, enterprise]
dependencies: []
inputs:
  - address
  - engagement_id
outputs:
  - coordinates (lat/lon)
  - fips_codes (state/county/tract/block_group)
  - walk_score
  - transit_score
  - bike_score
  - amenity_inventory (Overpass)
  - pedestrian_infrastructure_assessment
data_sources:
  - Census Geocoder (primary geocoding)
  - Walk Score API / walkscore.com
  - OpenStreetMap via Overpass API
  - Census TIGER/Line (boundary confirmation)
persona_relevance:
  - all
traceability:
  output_id_format: "LOCUS-P01-{ENG_ID}"
  feeds: [P02, P03, P04, P05, P06, P07, P10]
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# P01 — Walkability & Geospatial Baseline

## Prompt instruction

You are executing P01 of a LOCUS location intelligence engagement. Your role is to establish the geospatial foundation for this engagement. Every subsequent prompt (P02–P10) depends on the FIPS codes and coordinates you produce here.

**Engagement context:**
- Engagement ID: `{{engagement_id}}`
- Target address: `{{address}}`
- SKU tier: `{{sku_tier}}`

---

## Data collection sequence

Execute in order. Do not skip steps.

### 1. Geocode the address

**Method:** Census Geocoder API (preferred — returns FIPS codes directly)

```bash
# Replace spaces with + in address for URL encoding
ADDRESS_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('{{address}}'))")

curl -s "https://geocoding.geo.census.gov/geocoder/geographies/onelineaddress?\
address=${ADDRESS_ENCODED}&benchmark=Public_AR_Current&vintage=Current_Current&format=json" \
-o "engagements/{{engagement_id}}/p01-geospatial-baseline/raw-data/census-geocoder.json"
```

Extract and record:
- Latitude: from `result.addressMatches[0].coordinates.y`
- Longitude: from `result.addressMatches[0].coordinates.x`
- Matched address: from `result.addressMatches[0].matchedAddress` — note if different from input
- State FIPS (2-digit): from `geographies["States"][0].GEOID`
- County FIPS (5-digit): from `geographies["Counties"][0].GEOID`
- Census Tract (11-digit): from `geographies["Census Tracts"][0].GEOID`
- Block Group (12-digit): from `geographies["Census Block Groups"][0].GEOID`

**If Census Geocoder returns zero matches:**
Try with apartment/unit number removed. If still no match, use Google Geocoding API (requires GOOGLE_GEOCODING_KEY). If still no match, use Nominatim (`https://nominatim.openstreetmap.org/search?q={ENCODED}&format=json`). Document which geocoder was used.

**Write FIPS codes to engagement-metadata.md immediately.** Do not proceed to step 2 until confirmed.

### 2. Collect Walk Score data

**Method:** WebSearch → WebFetch

```
WebSearch: "{{address}} walk score walkscore.com"
```

The Walk Score address page URL pattern: `https://www.walkscore.com/score/[address-slug]`

WebFetch the address page and extract:
- **Walk Score®** (0–100): The numeric score and category label
  - 90–100: Walker's Paradise
  - 70–89: Very Walkable
  - 50–69: Walkable
  - 25–49: Some Errands on Foot
  - 0–24: Almost All Errands Require a Car
- **Transit Score** (0–100): Category label (Rider's Paradise / Excellent Transit / Good Transit / Some Transit / Minimal Transit)
- **Bike Score** (0–100): Category label

**If WebFetch fails:** Use the Walk Score API directly (requires WALK_SCORE_API_KEY):
```bash
curl "https://api.walkscore.com/score?format=json&address=${ADDRESS_ENCODED}\
&lat={{lat}}&lon={{lon}}&transit=1&bike=1&wsapikey=${WALK_SCORE_API_KEY}"
```

**Mandatory attribution:** Every Walk Score display requires:
1. The ® symbol on first reference: "Walk Score®"
2. Link to the address's walkscore.com page
3. Attribution: "Walk Score® provided by Redfin Real Estate"

### 3. Overpass API — Amenity inventory

**Method:** Bash curl to Overpass API

Collect in two radius rings: 400m (5-min walk) and 1,500m (full walkable zone):

```bash
LAT="{{lat}}"
LON="{{lon}}"

# 400m radius — immediate walk zone
curl -s "https://overpass-api.de/api/interpreter" \
  --data "[out:json];(
    node['amenity'](around:400,${LAT},${LON});
    node['shop'](around:400,${LAT},${LON});
    node['leisure'](around:400,${LAT},${LON});
  );out body;" \
  -o "engagements/{{engagement_id}}/p01-geospatial-baseline/raw-data/overpass-400m.json"

# 1500m radius — walkable zone
curl -s "https://overpass-api.de/api/interpreter" \
  --data "[out:json];(
    node['amenity'](around:1500,${LAT},${LON});
    node['shop'](around:1500,${LAT},${LON});
    node['leisure'](around:1500,${LAT},${LON});
  );out body;" \
  -o "engagements/{{engagement_id}}/p01-geospatial-baseline/raw-data/overpass-1500m.json"
```

Analyze and record:
- Total POI count at each radius
- Count by category (restaurant, cafe, supermarket, pharmacy, park, school, etc.)
- POI density: total ÷ (π × r²) in km² for each radius
- Notable name-brand anchors (pharmacy chains, grocery chains) — these appear in P04

### 4. Pedestrian infrastructure assessment

**Method:** WebSearch

Run these searches:
```
"{{city}} pedestrian infrastructure report sidewalk coverage"
"{{neighborhood}} street grid walkability pedestrian"
"{{city}} transportation department sidewalk inventory"
```

Look for:
- City sidewalk coverage percentage (from transportation department reports)
- Intersection density (intersections per square mile — higher = more walkable grid)
- Block length averages (shorter = more walkable)
- Any noted pedestrian deficiencies (missing sidewalks, high-speed arterials)

If city-specific data not found: Note "City sidewalk data not retrieved. Estimate derived from Walk Score sub-methodology." (Medium confidence)

---

## Output template

Write to `engagements/{{engagement_id}}/p01-geospatial-baseline/output.md`:

```markdown
## P01 — Walkability & Geospatial Baseline

**Engagement:** {{engagement_id}}  
**Address:** {{address}}  
**Collected:** [timestamp]  
**Confidence:** [High | Medium | Low]

---

### Geocoded Location

| Field | Value | Source |
|-------|-------|--------|
| Latitude | [value] | Census Geocoder |
| Longitude | [value] | Census Geocoder |
| Matched address | [matched address] | Census Geocoder |
| State FIPS | [code] | Census Geocoder |
| County FIPS | [code] | Census Geocoder |
| Census Tract | [11-digit code] | Census Geocoder |
| Block Group | [12-digit code] | Census Geocoder |
| Geocoder used | [Census / Google / Nominatim] | N/A |

[Source: Census Geocoder, retrieved DATE]

---

### Walk Score® Data

| Score Type | Score | Category |
|-----------|-------|---------|
| Walk Score® | [0–100] | [label] |
| Transit Score | [0–100] | [label] |
| Bike Score | [0–100] | [label] |

Walk Score® provided by Redfin Real Estate. [Source: walkscore.com, retrieved DATE]

---

### Amenity Inventory

**Within 400m (5-minute walk zone):**
- Total POIs: [count]
- Restaurants/cafes: [count]
- Grocery/market: [count]
- Parks/green space: [count]
- Other notable: [categories]
- POI density: [calc] per km²

**Within 1,500m (full walkable zone):**
- Total POIs: [count]
- [full category breakdown]
- POI density: [calc] per km²

[Source: OpenStreetMap via Overpass API, retrieved DATE]

---

### Pedestrian Infrastructure

[Findings with sources, or: "Not retrieved — estimate from Walk Score methodology (Medium confidence)"]

---

### Data Gaps

[List any data points not retrieved]

---

**Collection complete:** [timestamp]  
**Ready for scoring:** yes  
**Feeds into:** P02 (coordinates/amenity map), P03 (parks confirmed), P04 (retail confirmed), P10 (scoring)
```

---

## Scoring inputs this prompt provides

| Sub-metric | Data Point | Dimension Weight |
|-----------|------------|----------------|
| Walk Score | Direct from Walk Score API | 40% of Walkability |
| POI density 0.5mi | Overpass count ÷ π×0.5² | 25% of Walkability |
| Pedestrian infrastructure | City report / estimated | 15% of Walkability |
| Pedestrian safety | Crime data cross-reference with P07 | 20% of Walkability |

---

## Common issues and resolutions

**Walk Score shows N/A for this address:** Some rural or very new addresses don't have Walk Scores. Record as: "Walk Score: Not available — address not in Walk Score database." The scoring-agent will apply the minimum walkability score for this sub-metric.

**Census Geocoder matches wrong address:** If the matched address is in a different city or ZIP, the FIPS codes are wrong. Alert the practitioner and try with the ZIP code added explicitly.

**Overpass API timeout:** Reduce radius to 1,000m. If still timing out, use `[out:json][timeout:60]` prefix. If still failing, use OSM Nominatim to find the nearest POIs.

---

*LOCUS Prompt P01 — Walkability & Geospatial Baseline — BHIL LOCUS Framework v1.0*
