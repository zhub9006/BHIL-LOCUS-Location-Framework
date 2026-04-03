---
dimension: D3
title: Recreation & Green Space Sources
---

# D3 Data Sources — Recreation & Green Space

## Primary Sources

### Trust for Public Land — ParkServe
- **URL:** parkserve.tpl.org
- **Free:** Yes (map interface)
- **API:** Unofficial; use WebFetch on ParkServe search pages
- **Returns:** Park access scores, park names, acreage by city/tract
- **Validity:** 2 years

### Overpass API
Tags: `leisure=park|garden|playground|dog_park|nature_reserve|pitch|sports_centre`

```bash
curl -s "https://overpass-api.de/api/interpreter" \
  --data-urlencode "data=[out:json];(way[\"leisure\"~\"park|garden\"](around:800,${LAT},${LON}););out center tags;"
```

## Secondary Sources

### AllTrails
- **URL:** alltrails.com
- **Free tier:** WebSearch + WebFetch for trail listings
- **Registration required:** For API access (not needed for WebFetch)
- **Returns:** Trail name, length, difficulty, ratings

### City Parks & Recreation Department
- WebSearch: "[CITY] parks recreation department"
- Returns: Official park lists, amenities, programming schedules

### Google Maps (Parks layer)
- WebSearch: "parks near [ADDRESS]" + WebFetch Google Maps results

## Attribution
- Trust for Public Land ParkServe data requires attribution in deliverables

