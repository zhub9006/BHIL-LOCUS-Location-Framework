---
dimension: D7
title: Civic Infrastructure & Safety Sources
---

# D7 Data Sources — Civic Infrastructure & Safety

> ⚠️ Fair Housing: All crime data is objective statistics only. No characterizations.

## Primary Sources

### FBI Crime Data Explorer
- **URL:** cde.ucr.cjis.gov
- **API:** api.usa.gov/crime/fbi/cde/
- **Free:** Yes
- **Returns:** Property crime, violent crime rates by city
- **Validity:** 2 years
- **Attribution:** "Crime data: FBI Crime Data Explorer"

```bash
curl "https://api.usa.gov/crime/fbi/cde/estimate/city/{CITY}/{STATE}?from=2019&to=2022&API_KEY=iiHnOKfno2Mgkt5AynpvPpUQTEyxE77jo1RU8PIv"
```

### FEMA Map Service Center (NFHL)
- **URL:** msc.fema.gov
- **API:** ArcGIS REST endpoint
- **Free:** Yes
- **Returns:** Flood zone designation (X, AE, VE, AO, etc.)
- **Attribution:** "Flood data: FEMA National Flood Hazard Layer"

### EPA AirNow
- **URL:** airnowapi.org (API), airnow.gov (web)
- **Free:** Yes (API key required, free registration)
- **Returns:** Current AQI, annual averages by ZIP/MSA
- **Attribution:** "Air quality data: U.S. EPA AirNow"

## Secondary Sources

### DOT National Transportation Noise Map
- **URL:** maps.dot.gov/BTS/NationalTransportationNoiseMap/
- **Free:** Yes (web interface; no API)
- **Returns:** Road and aviation noise in dBA by location

### Local Police Open Data Portals
- Many cities publish crime statistics dashboards
- WebSearch: "[CITY] crime data open data portal statistics"
- Use only official city/county sources

### 311 Open Data
- Many cities: data.cityname.gov/311-service-requests
- WebSearch: "[CITY] 311 open data infrastructure requests"

## National Average Benchmarks (for scoring context)

| Metric | National Average (2022) | Source |
|--------|------------------------|--------|
| Property crime rate | ~19.6 per 1,000 | FBI UCR |
| Violent crime rate | ~3.7 per 1,000 | FBI UCR |
| AQI "Good" days | Varies by region | EPA |

