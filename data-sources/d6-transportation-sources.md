---
dimension: D6
title: Transportation & Commute Sources
---

# D6 Data Sources — Transportation & Commute

## Primary Sources

### Walk Score® Transit API
- Same API key as D1
- `transit=1` parameter returns Transit Score
- Returns: Transit Score (0–100) + nearby routes

### Transit Agency GTFS Feeds
- **URL:** transitfeeds.com or agency website
- **Free:** Yes (open data standard)
- **Returns:** Routes, stops, schedules, frequencies
- **Validity:** 3 months (agencies publish seasonal)

```bash
# Many agencies publish GTFS at standard paths
# Example: King County Metro
curl "https://metro.kingcounty.gov/GTFS/google_transit.zip" -o /tmp/gtfs.zip
```

### Google Maps Transit Directions (WebSearch)
Most reliable fallback for commute time:
```
WebSearch: "transit directions [ADDRESS] to downtown [CITY]"
```

## Secondary Sources

### 511 Regional APIs (Bay Area, NY Metro)
- Regional real-time transit data APIs
- WebSearch: "[CITY] 511 transit api developer"

### BLS Commute Time Data
- American Community Survey Table B08013 (aggregate travel time)
- ACS API: variable B08012_001E (workers by travel time)

### Airport Distance (WebSearch)
```
WebSearch: "drive time [CITY] to [AIRPORT CODE] airport"
```

## Bias Note

Google Maps commute times represent average conditions, not worst-case rush hour. If precision matters, note "±15 minutes peak variability" in output.

