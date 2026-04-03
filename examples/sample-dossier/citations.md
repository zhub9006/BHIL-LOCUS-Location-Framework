# Citations

**Engagement:** LOCUS-2025-0001
**Address:** 613 E Pine St, Seattle, WA 98122

---

## Citation Log

All sources accessed during this engagement are logged below. Each citation
maps to a scorecard dimension (D1–D9) and the prompt that consumed it.

---

### D1 — Walkability & Geospatial

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C1-001 | Walk Score                    | https://www.walkscore.com/score/613-e-pine-st-seattle-wa-98122   | 2025-06-15  | Freemium  |
| C1-002 | OpenStreetMap / Overpass API  | https://overpass-api.de/                                          | 2025-06-15  | Free      |
| C1-003 | FEMA Flood Map Service        | https://msc.fema.gov/portal/search#searchresultsanchor           | 2025-06-15  | Free Gov  |
| C1-004 | Seattle GIS Open Data         | https://data-seattlecitygis.opendata.arcgis.com/                  | 2025-06-15  | Free Gov  |

### D2 — Food, Drink & Social

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C2-001 | Google Places API             | https://maps.googleapis.com/maps/api/place/nearbysearch/json     | 2025-06-15  | Freemium  |
| C2-002 | Yelp Fusion API               | https://api.yelp.com/v3/businesses/search                        | 2025-06-15  | Commercial|

### D3 — Recreation & Green Space

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C3-001 | Seattle Parks & Recreation    | https://www.seattle.gov/parks/find/parks                          | 2025-06-15  | Free Gov  |
| C3-002 | Trust for Public Land ParkScore| https://parkserve.tpl.org/                                       | 2025-06-15  | Free      |

### D4 — Daily Errands & Retail

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C4-001 | Google Places API             | https://maps.googleapis.com/maps/api/place/nearbysearch/json     | 2025-06-15  | Freemium  |
| C4-002 | Walk Score Grocery API        | https://www.walkscore.com/professional/api.php                    | 2025-06-15  | Freemium  |

### D5 — Education

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C5-001 | GreatSchools API              | https://www.greatschools.org/api/docs/main.page                  | 2025-06-15  | Freemium  |
| C5-002 | OSPI School Report Cards      | https://reportcard.ospi.k12.wa.us/                               | 2025-06-15  | Free Gov  |

### D6 — Transportation & Commute

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C6-001 | King County Metro GTFS        | https://kingcounty.gov/en/dept/metro/rider-tools/mobile-and-online-tools/general-transit-feed-specification | 2025-06-15 | Free Gov |
| C6-002 | Sound Transit Link Light Rail | https://www.soundtransit.org/ride-with-us/routes-schedules/1-line| 2025-06-15  | Free Gov  |
| C6-003 | Google Maps Distance Matrix   | https://maps.googleapis.com/maps/api/distancematrix/json         | 2025-06-15  | Freemium  |

### D7 — Civic & Infrastructure

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C7-001 | Seattle Police Dept. (SPD) Crime Dashboard | https://www.seattle.gov/police/information-and-data/crime-dashboard | 2025-06-15 | Free Gov |
| C7-002 | Seattle Utilities (SCL/SPU)   | https://myutilities.seattle.gov/                                  | 2025-06-15  | Free Gov  |

### D8 — Demographics & Trajectory

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C8-001 | U.S. Census ACS 5-Year (2023) | https://data.census.gov/                                          | 2025-06-15  | Free Gov  |
| C8-002 | Zillow Research               | https://www.zillow.com/research/data/                             | 2025-06-15  | Free      |

### D9 — Business Environment

| ID     | Source                        | URL / Reference                                                   | Accessed    | Tier      |
|--------|-------------------------------|-------------------------------------------------------------------|-------------|-----------|
| C9-001 | U.S. Census County Business Patterns | https://www.census.gov/programs-surveys/cbp.html           | 2025-06-15  | Free Gov  |
| C9-002 | CoStar / LoopNet (reference)  | https://www.loopnet.com/                                          | 2025-06-15  | Commercial|

---

## Citation Integrity Notes

- All freemium and commercial sources accessed within rate limits of their respective free tiers unless otherwise noted
- No sources contained protected-class demographic variables used in scoring
- Data currency: All sources accessed within 18-month window per `integration/data-currency.md`
