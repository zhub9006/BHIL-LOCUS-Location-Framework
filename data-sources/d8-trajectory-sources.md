---
dimension: D8
title: Neighborhood Trajectory Sources
---

# D8 Data Sources — Neighborhood Trajectory

> ⚠️ Fair Housing CRITICAL: Economic indicators only. No demographic composition data.

## Primary Sources

### Census ACS 5-Year Estimates API
- **URL:** api.census.gov/data/{year}/acs/acs5
- **Free:** Yes
- **Variables to use:**
  - B01003_001E — Total population ✅
  - B19013_001E — Median household income ✅
  - B25077_001E — Median home value (owner-occupied) ✅
- **Variables NEVER to use:**
  - B02001_* — Race ❌
  - B03002_* — Hispanic/Latino origin ❌
  - Any demographic composition variable ❌

### Census Building Permits Survey
- **URL:** api.census.gov/data/timeseries/eits/cbps
- **Free:** Yes
- **Returns:** Monthly permit data by county

### Census Business Dynamics Statistics (BDS)
- **URL:** api.census.gov/data/timeseries/bds
- **Free:** Yes
- **Returns:** Business births, deaths, net formation by county/sector

## Secondary Sources

### Zillow Research Data
- **URL:** zillow.com/research/data/
- **Free:** Downloadable CSV files
- **Returns:** Home value index, appreciation rates, inventory
- **Validity:** 6 months (market data)
- **Attribution:** "Home value data: Zillow Research"

### Redfin Data Center
- **URL:** redfin.com/news/data-center/
- **Free:** Downloadable CSV
- **Returns:** Median sale price, price/sqft, days on market

### Local News / Development Pipeline (WebSearch)
For qualitative trajectory signals:
```
WebSearch: "[CITY] [NEIGHBORHOOD] development investment plans 2023 2024"
WebSearch: "[CITY] rezoning new construction announcements"
```

## BLS CPI Deflator (for real income change)
- **URL:** bls.gov/cpi/
- **API:** api.bls.gov/publicAPI/v2/timeseries/data/CUUR0000SA0
- Annual CPI-U averages for inflation adjustment

