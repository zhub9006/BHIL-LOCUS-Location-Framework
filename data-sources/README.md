---
document: data-sources-index
version: "1.0"
---

# Data Sources Index — All 9 Dimensions

> This index documents the primary, secondary, and fallback data sources for each LOCUS dimension.
> For access instructions, API patterns, and bash recipes, see the individual dimension source files.
> For validity windows, see `integration/data-currency.md`.

---

## Tier Architecture

LOCUS uses a three-tier data architecture to maximize free government data while selectively using commercial sources.

```
Tier 1 — Free Government Data (always use first)
    Census Bureau · FBI UCR · FEMA · EPA · NCES · BLS

Tier 2 — Freemium / Licensed Data (use with attribution)
    Walk Score® · GreatSchools · OpenStreetMap / Overpass API

Tier 3 — Commercial Data (optional, cite carefully)
    Yelp · Google Places · Zillow · Redfin · Placer.ai
```

**Rule:** Never use Tier 3 as the sole source for a scored sub-metric. Always cross-reference with Tier 1 or Tier 2.

---

## Dimension Source Matrix

| Dimension | Primary | Secondary | Tertiary |
|-----------|---------|-----------|---------|
| D1 Walkability | Walk Score® API | Census TIGER roads | OSM Overpass |
| D2 Food & Social | OSM Overpass | Yelp / Google Places | WebSearch |
| D3 Recreation | OSM Overpass | TPL ParkServe | AllTrails |
| D4 Errands & Retail | OSM Overpass | Google Places | WebSearch |
| D5 Education | GreatSchools | NCES CCD | State DOE |
| D6 Transportation | Walk Score® Transit | GTFS feeds | Agency WebSearch |
| D7 Civic & Safety | FBI CDE + FEMA + EPA | Local police stats | WebSearch |
| D8 Trajectory | Census ACS API | Census BPS | Zillow/Redfin |
| D9 Business | OSM Overpass | Census BDS | WebSearch |

---

## API Quick Reference

### Always-Free APIs (no key required)

```bash
# Census Geocoder
curl "https://geocoding.geo.census.gov/geocoder/geographies/address?street=ADDRESS&city=CITY&state=ST&benchmark=2020&vintage=2020&format=json"

# Census ACS
curl "https://api.census.gov/data/2022/acs/acs5?get=B19013_001E,B25077_001E&for=tract:TRACT&in=state:ST+county:COUNTY"

# Overpass API (OSM)
curl -s "https://overpass-api.de/api/interpreter" --data-urlencode "data=QUERY"

# FEMA Flood Zone
curl "https://msc.fema.gov/arcgis/rest/services/NFHL/7/query?geometry=LON,LAT&geometryType=esriGeometryPoint&outFields=FLD_ZONE,SFHA_TF&f=json"
```

### Free Registration APIs

```bash
# Walk Score (free tier — register at walkscore.com/professional/api.php)
curl "https://api.walkscore.com/score?format=json&address=ADDRESS&lat=LAT&lon=LON&wsapikey=YOUR_KEY&transit=1&bike=1"

# EPA AirNow (register at airnowapi.org)
curl "https://www.airnowapi.org/aq/observation/latLong/current/?format=json&latitude=LAT&longitude=LON&distance=25&API_KEY=YOUR_KEY"
```

### Free with Attribution

```bash
# OpenStreetMap Nominatim (geocoding alternative)
curl "https://nominatim.openstreetmap.org/search?q=ADDRESS&format=json&addressdetails=1" \
  -H "User-Agent: BHIL-LOCUS/1.0"

# GreatSchools (WebFetch school pages — no API required)
# URL pattern: https://www.greatschools.org/[state]/[city]/[school-id]-[school-name]/
```

---

## WebSearch Source Priority

When using WebSearch for a LOCUS dimension, prefer sources in this order:

1. Government (.gov) — highest authority
2. Academic / research institution (.edu)
3. Established news organizations (NYT, WaPo, local newspaper of record)
4. Industry publications (CoStar, Urban Land Institute, National Association of Realtors)
5. Commercial data services (Zillow, Redfin, Walk Score)
6. General web results — use with extra scrutiny

**Never cite:** Personal blogs, Reddit posts, anonymous sources, undated content, promotional materials.

---

## Source Files by Dimension

See individual files for detailed API patterns, bash recipes, and WebFetch strategies:

- `data-sources/d1-walkability-sources.md`
- `data-sources/d2-food-social-sources.md`
- `data-sources/d3-recreation-sources.md`
- `data-sources/d4-errands-retail-sources.md`
- `data-sources/d5-education-sources.md`
- `data-sources/d6-transportation-sources.md`
- `data-sources/d7-civic-safety-sources.md`
- `data-sources/d8-trajectory-sources.md`
- `data-sources/d9-business-sources.md`

---

*Data Sources Index · LOCUS Framework · BHIL*
