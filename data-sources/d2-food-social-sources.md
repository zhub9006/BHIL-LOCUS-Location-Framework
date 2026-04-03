---
dimension: D2
title: Food, Drink & Social Sources
---

# D2 Data Sources — Food, Drink & Social

## Primary Sources

### Overpass API (OpenStreetMap)
Tags: `amenity=restaurant|cafe|bar|pub|fast_food|ice_cream|food_court`
Free, no key, returns counts and named nodes within radius.

### Yelp Fusion API
- **Tier:** Free (500 calls/day with key)
- **Register:** yelp.com/developers
- **Returns:** Business name, rating, review count, category, distance
- **Attribution:** Required per Yelp ToS
- **Validity:** 6 months

### Google Places API (Nearby Search)
- **Tier:** Paid ($17/1,000 requests) — use judiciously
- **Alternative:** WebFetch Google Maps search results page (free, slower)

## Secondary Sources

### WebSearch — Restaurant Aggregators
Priority order: Google Maps → Yelp → TripAdvisor → OpenTable (for upscale)

### Foursquare / Swarm
- WebSearch `site:foursquare.com [CITY] [NEIGHBORHOOD]` for venue lists

## Fallback

| Yelp blocked | Use Google Maps search results page via WebFetch |
| No ratings available | Mark quality_signal as "unavailable"; use score default 6.5 |
| Rural area — <5 restaurants | Apply absolute floor scoring; note in data quality |

