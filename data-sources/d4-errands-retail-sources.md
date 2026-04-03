---
dimension: D4
title: Daily Errands & Retail Sources
---

# D4 Data Sources — Daily Errands & Retail

## Primary Sources

### Overpass API
Tags: `shop=supermarket|grocery|convenience|pharmacy` · `amenity=bank|atm|hospital|doctors|dentist`

### Google Places (WebSearch)
Search: "grocery near [ADDRESS]" → WebFetch search results page

## Secondary Sources

### Yelp
Categories: grocery, pharmacy, urgent_care, banks

### USDA Food Access Research Atlas
- **URL:** ers.usda.gov/data-products/food-access-research-atlas/
- **Free:** Yes
- **Returns:** Food desert designation, low-income/low-access tracts
- **Useful for:** Rural and suburban engagements where grocery access is sparse

```bash
# USDA Food Atlas API
curl "https://ers.usda.gov/webdocs/DataFiles/80591/DataDownload2019.xlsx" -o /tmp/food_atlas.xlsx
# Then parse for tract-level data matching FIPS codes from P01
```

## Validation Priority

Grocery access is the #1 sub-metric for D4. Always verify:
1. Name of nearest full-service grocery
2. Walking distance in meters
3. Whether it is within 800m (binary flag)

Do not rely solely on Overpass for grocery — names may be outdated. Confirm with WebSearch.

