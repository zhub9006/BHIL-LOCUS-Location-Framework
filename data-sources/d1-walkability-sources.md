---
dimension: D1
title: Walkability & Geospatial Sources
---

# D1 Data Sources — Walkability & Geospatial

## Primary Sources

### Walk Score® API
- **URL:** `https://api.walkscore.com/score`
- **Free tier:** 5,000 requests/day with API key
- **Register:** walkscore.com/professional/api.php
- **Returns:** Walk Score (0–100), Transit Score (0–100), Bike Score (0–100)
- **Attribution required:** "Walk Score® data provided by Walk Score®. Used under license."
- **Validity:** 1 year

```bash
WS_KEY="YOUR_WALKSCORE_API_KEY"
curl "https://api.walkscore.com/score?format=json&address=${ADDRESS_ENCODED}&lat=${LAT}&lon=${LON}&wsapikey=${WS_KEY}&transit=1&bike=1"
```

### Census Geocoder
- **URL:** `https://geocoding.geo.census.gov/geocoder/`
- **Free:** Yes, no key required
- **Returns:** Lat/lon, FIPS (state, county, tract, block)

```bash
curl "https://geocoding.geo.census.gov/geocoder/geographies/address?street=${STREET_ENCODED}&city=${CITY}&state=${STATE}&benchmark=2020&vintage=2020&format=json"
```

### Overpass API (OpenStreetMap)
- **URL:** `https://overpass-api.de/api/interpreter`
- **Free:** Yes
- **Returns:** All OSM nodes/ways within radius — streets, intersections, sidewalks, crosswalks

**Intersection density query:**
```bash
curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json];node[\"highway\"~\"motorway_junction|traffic_signals|crossing\"](around:800,${LAT},${LON});out count;"
```

## Secondary Sources

### Census TIGER Road Files
- Direct download for road network analysis
- URL: `https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html`
- Use for: Sidewalk network analysis, pedestrian infrastructure

### Google Street View (WebSearch)
- Use WebSearch for pedestrian infrastructure characterization
- Useful for: "sidewalk quality near [ADDRESS]" signals

## Fallback Sources

| Walk Score unavailable | Use: Overpass intersection count as proxy |
| Transit Score unavailable | Use: P06 transit route count + frequency |
| Bike Score unavailable | Use: OSM cycleway network within 800m |

