---
template: poi-inventory
engagement_id: "{{ENGAGEMENT_ID}}"
address: "{{RAW_ADDRESS}}"
collection_date: "{{ISO_DATE}}"
collection_radius_m: 1500
poi_count: 0
---

# POI Inventory — {{ENGAGEMENT_ID}}

> **Usage:** Populated by skills run-poi-collection (P02–P04).
> POI IDs are assigned sequentially: `POI-{{ENGAGEMENT_ID}}-NNN`.
> Each entry cites the source citation from `citations.md`.

---

## D2 — Food, Drink & Social

### Restaurants & Cafes
| POI ID | Name | Category | Distance (m) | Rating | Price | Citation |
|--------|------|----------|-------------|--------|-------|----------|
| | | | | | | |

**Sub-totals:**
- Restaurants within 400m: ___
- Restaurants within 800m: ___
- Restaurants within 1500m: ___
- Cuisine diversity score (unique categories): ___

### Coffee & Tea
| POI ID | Name | Type | Distance (m) | Hours (approx) | Citation |
|--------|------|------|-------------|---------------|----------|
| | | | | | |

### Bars, Breweries & Nightlife
| POI ID | Name | Type | Distance (m) | Citation |
|--------|------|------|-------------|----------|
| | | | | |

### Cultural Venues (museums, galleries, theaters, live music)
| POI ID | Name | Type | Distance (m) | Citation |
|--------|------|------|-------------|----------|
| | | | | |

---

## D3 — Recreation & Green Space

### Parks & Green Space
| POI ID | Name | Type | Area (acres) | Distance (m) | Amenities | Citation |
|--------|------|------|-------------|-------------|-----------|----------|
| | | | | | | |

**Totals:**
- Parks within 800m: ___
- Total accessible green space within 800m (acres): ___
- Dog-friendly parks: ___
- Parks with playgrounds: ___

### Fitness & Recreation Facilities
| POI ID | Name | Type | Distance (m) | Citation |
|--------|------|------|-------------|----------|
| | | | | |

### Trails & Paths
| POI ID | Name | Type | Length (mi) | Distance to Access (m) | Surface | Citation |
|--------|------|------|------------|----------------------|---------|----------|
| | | | | | | |

---

## D4 — Daily Errands & Retail

### Grocery & Food Retail
| POI ID | Name | Type | Distance (m) | Hours | Citation |
|--------|------|------|-------------|-------|----------|
| | | | | | |

**Grocery summary:**
- Full-service grocery within 800m: ☐ Yes ☐ No (nearest: ___ m)
- Specialty/natural food within 1500m: ___
- Convenience/corner store within 400m: ___

### Pharmacy
| POI ID | Name | Distance (m) | Hours | Citation |
|--------|------|-------------|-------|----------|
| | | | | |

### Banking & Financial Services
| POI ID | Name | Type | Distance (m) | Citation |
|--------|------|------|-------------|----------|
| | | | | |

### Healthcare Access
| POI ID | Name | Type | Distance (m) | Citation |
|--------|------|------|-------------|----------|
| | | | | |

### General Retail & Services
| POI ID | Name | Category | Distance (m) | Citation |
|--------|------|----------|-------------|----------|
| | | | | |

---

## POI Coverage Summary

| Dimension | POIs Collected | Radius Covered | Data Source(s) | Quality |
|-----------|---------------|---------------|----------------|---------|
| D2 Food & Social | | | | |
| D3 Recreation | | | | |
| D4 Errands & Retail | | | | |
| **TOTAL** | | | | |

---

## Collection Notes

*Document any gaps, data quality issues, or analyst observations.*

```
[Enter notes here]
```

---

*LOCUS Framework · BHIL · POI data is time-sensitive — see `integration/data-currency.md` for validity windows.*
