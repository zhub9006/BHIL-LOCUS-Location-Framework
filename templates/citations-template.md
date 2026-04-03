---
template: citations
engagement_id: "{{ENGAGEMENT_ID}}"
created: "{{ISO_DATE}}"
last_updated: "{{ISO_DATE}}"
total_citations: 0
---

# Citations Log — {{ENGAGEMENT_ID}}

> **Usage:** Every factual claim in LOCUS outputs must trace to a row in this table.
> Inline reference format: `[CIT-NNN]` · Add rows chronologically as data is collected.
> Do not delete rows — mark superseded data with `status: superseded`.

---

## Active Citations

| ID | Prompt | Source Name | Publisher | URL | Access Date | Data Date | Confidence | Field(s) Referenced |
|----|--------|------------|-----------|-----|------------|-----------|-----------|---------------------|
| CIT-001 | — | — | — | — | — | — | — | Initialized |

---

## Citation Log by Prompt Phase

### P01 — Walkability & Geospatial
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P02 — Food, Drink & Social
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P03 — Recreation & Green Space
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P04 — Daily Errands & Retail
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P05 — Education
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P06 — Transportation & Commute
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P07 — Civic Infrastructure & Safety
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P08 — Demographics & Trajectory
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

### P09 — Business Environment
| ID | Source | Key Data Points |
|----|--------|----------------|
| | | |

---

## Required Attributions Checklist

Per `integration/compliance.md`, these must appear in any client-facing deliverable:

- [ ] **Walk Score®** — "Walk Score® data provided by Walk Score®. Used under license."
- [ ] **GreatSchools** — "School data © GreatSchools.org. Used for informational purposes."
- [ ] **U.S. Census Bureau** — "Data source: U.S. Census Bureau, American Community Survey."
- [ ] **FBI UCR / Crime Data Explorer** — "Crime data: FBI Crime Data Explorer. Local definitions vary."
- [ ] **EPA AirNow** — "Air quality data: U.S. EPA AirNow."
- [ ] **FEMA / MSC** — "Flood zone data: FEMA National Flood Hazard Layer."
- [ ] **OpenStreetMap** — "Map data © OpenStreetMap contributors."
- [ ] **Google Places / Maps** (if used) — per Google ToS attribution requirements

---

## Staleness Flags

*Populated by `check-citations.sh` — do not manually edit.*

| Citation ID | Field | Data Date | Validity Window | Flag |
|-------------|-------|-----------|----------------|------|
| | | | | |

---

## Superseded Citations

*Move rows here when a source is replaced by fresher data.*

| ID | Original Source | Superseded By | Reason |
|----|----------------|--------------|--------|
| | | | |

---

*Maintained per `integration/traceability.md` · Validated by `tools/scripts/check-citations.sh`*
