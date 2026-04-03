---
dimension: D9
title: Business Environment Sources
---

# D9 Data Sources — Business Environment

## Primary Sources

### Overpass API (OpenStreetMap)
Tags: `shop=*` · `office=*` · `building=commercial|office|retail`
Provides commercial node count within radius as density proxy.

### Census Business Dynamics Statistics
- County-level business formation rates
- See D8 sources for API patterns

## Secondary Sources

### CoStar Group (Commercial Real Estate)
- **Tier:** Commercial product ($$$)
- **Free alternative:** WebSearch CoStar news articles for local market reports
- **Returns:** Vacancy rates, cap rates, absorption rates

### LoopNet (WebSearch)
- Free commercial listings site
- WebSearch `site:loopnet.com [CITY]` for vacancy signal

### Local Business Journals (WebSearch)
- "[CITY] Business Journal" publications are strong D9 sources
- WebSearch: `site:[CITY]businessjournal.com [NEIGHBORHOOD] commercial real estate`

### Yelp (Business density cross-check)
- Yelp category counts as secondary validation for Overpass counts
- Categories: real_estate, professional_services, financial_services

## Coworking / Startup Ecosystem

### Coworker.com
- WebSearch: `site:coworker.com [CITY]` for coworking space listings

### AngelList / Crunchbase (WebSearch)
- Startup ecosystem signal: `[CITY] startups funding 2023 2024`

## Attribution

- CoStar / commercial real estate data: cite source + access date
- Business Journal articles: cite publication, author, date
- Crunchbase: cite as "Crunchbase data, accessed [DATE]"

