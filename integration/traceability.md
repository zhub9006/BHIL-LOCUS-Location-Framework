---
id: LOCUS-TRACEABILITY
title: "LOCUS Traceability System"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Traceability System

## Design intent

Every claim in every LOCUS dossier should be answerable with: "Where does this number come from?" Traceability is how LOCUS answers that question instantly — from a composite score in the executive summary, down through the dimension score, down to the sub-metric value, down to the source URL and retrieval date.

This matters in three practical contexts:
1. **Client questions:** "Why did this neighborhood score 6.2 on safety?" → trace to crime rate figure → trace to FBI UCR data table → link to source
2. **Fair housing defense:** "Is this score based on protected characteristics?" → trace every input and confirm none are protected-class data
3. **Dossier updates:** When a data source updates, the citation log identifies exactly which claims need refreshing

---

## ID system specification

### Three ID types

```
LOCUS-ENG-NNN    Engagement identifier — the workspace
LOCUS-DOS-NNN    Dossier identifier — the output document
LOCUS-POI-NNN    Point-of-interest record — individual place entries
```

All `NNN` values are three-digit, zero-padded, sequential integers starting at 001.

### Assignment rules

**LOCUS-ENG-NNN** — Assigned at engagement creation by `new-locus-engagement` skill or `new-engagement.sh` script. The NNN is the next unused integer in the `engagements/` directory.

```bash
# Auto-assign next ID
NEXT_ID=$(ls engagements/ | grep -oP 'LOCUS-ENG-\K\d+' | sort -n | tail -1 | xargs -I{} expr {} + 1 | xargs printf '%03d')
echo "LOCUS-ENG-${NEXT_ID}"
```

**LOCUS-DOS-NNN** — Assigned at P10 synthesis when the final dossier is assembled. Uses the same NNN as the engagement: `LOCUS-ENG-003` produces `LOCUS-DOS-003`.

**LOCUS-POI-NNN-SEQ** — Assigned during P02–P04 data collection. Format: `LOCUS-POI-{ENG_NNN}-{SEQ}` where SEQ is the sequence number of the POI within the engagement.

```
LOCUS-POI-003-001   ← First POI in engagement 003
LOCUS-POI-003-047   ← 47th POI in engagement 003
```

### Retired IDs

If an engagement is abandoned, its ENG ID is retired. The engagement directory is moved to `engagements/archive/LOCUS-ENG-NNN-ABANDONED/`. The ID is never reused. Retired IDs are documented in `engagements/ID-REGISTRY.md`.

---

## Claim-to-source tracing

Every factual claim in a LOCUS dossier must be traceable through a four-level chain:

```
Level 4: Executive Summary claim
         "The neighborhood scored 7.6 on Walkability for the Young Professional persona"
              ↓
Level 3: Scorecard dimension score
         "Walkability: 7.6 (Walk Score 87×40% + POI density 7.0×25% + ...)"
              ↓
Level 2: Prompt output data point
         "P01 output.md: Walk Score® 87 [Source: walkscore.com, retrieved 2026-04-01]"
              ↓
Level 1: Source record in citations.md
         | Walk Score 87 | Walkability | Walk Score/Redfin | walkscore.com/score/... | 2026-04-01 | 2026-07-01 | High |
```

### Inline reference system

Level 4 → Level 3 tracing uses section cross-references: `[P01-walkability]`, `[P05-education]`

Every claim in the final dossier that is not directly derived from a score must include the prompt-level reference in brackets:

```
The address is located in a Census Tract with median household income 
of $94,200 [P08-demographics, Source: Census ACS 2020-2024].
```

The `[P##-dimension]` reference tells a reader exactly which prompt section contains the supporting data and which source URL to verify.

---

## citations.md specification

The `citations.md` file is the master source log for every engagement. It is created empty at engagement initialization and populated by the web-search-agent during data collection.

### Schema

```markdown
| Claim | Dimension | Source Name | URL | Retrieved | Valid Until | Confidence |
|-------|-----------|-------------|-----|-----------|-------------|-----------|
```

**Field definitions:**

| Field | Content | Example |
|-------|---------|---------|
| Claim | Brief description of the data point | "Walk Score® 87" |
| Dimension | Which of the 9 LOCUS dimensions | "Walkability" |
| Source Name | Official name of the data source | "Walk Score / Redfin Corporation" |
| URL | Direct URL to the source page or API endpoint | "walkscore.com/score/1234-pine-..." |
| Retrieved | ISO date of retrieval | "2026-04-01" |
| Valid Until | Calculated expiry based on data currency standards | "2026-07-01" |
| Confidence | High / Medium / Low | "High" |

### Data currency validity windows

The `Valid Until` date is calculated at retrieval time:

| Source type | Validity window | Calculation |
|------------|----------------|-------------|
| Walk Score | 90 days | Retrieved + 90 days |
| Census ACS 5-year | 12 months from vintage | Vintage year + 12 months |
| Zillow ZHVI/ZORI | 30 days | Retrieved + 30 days |
| Redfin market data | 30 days | Retrieved + 30 days |
| GreatSchools ratings | 12 months | Retrieved + 12 months |
| POI listings (P02–P04) | 60 days | Retrieved + 60 days |
| FEMA flood zone | 6 months | Retrieved + 6 months |
| EPA AirNow AQI | 24 hours | Retrieved + 1 day |
| FBI UCR crime data | 12 months | Retrieved + 12 months |
| Census TIGER/FIPS | Permanent | N/A (geographic boundaries) |
| GTFS transit feeds | 30 days | Retrieved + 30 days |

### Staleness flags

The `check-citations.sh` script scans `citations.md` for expired entries and outputs:

```
Engagement: LOCUS-ENG-003
Address: 1234 Pine St, Seattle WA

DATA CURRENCY REPORT (as of 2026-07-01):
✅ Walk Score® — retrieved 2026-04-01, valid until 2026-07-01 — expires today
✅ Census ACS — retrieved 2026-04-01, valid until 2027-04-01 — 275 days remaining
⚠️ Zillow ZHVI — retrieved 2026-04-01, valid until 2026-05-01 — EXPIRED (91 days ago)
⚠️ POI inventory — retrieved 2026-04-01, valid until 2026-06-01 — EXPIRED (30 days ago)

2 data sources require refresh before dossier re-delivery.
```

Any expired source must be flagged in the dossier with: `⚠️ DATA MAY BE STALE — [source] retrieved [DATE], validity period exceeded`

---

## Cross-framework traceability

When a LOCUS engagement feeds a downstream BHIL framework (SENTINEL, CODEX, VANTAGE, VERDICT), the handoff chain is recorded in both engagement files.

### In LOCUS engagement-metadata.md:

```yaml
downstream_references:
  - framework: SENTINEL
    id: SENTINEL-PROP-012
    fields_provided: [walkability_score, school_score, safety_score, trajectory_score]
    handoff_date: "2026-04-15"
  - framework: CODEX
    id: CODEX-ENT-007
    fields_provided: [full_dossier_reference]
    handoff_date: "2026-04-15"
```

### In the downstream framework's document:

```
community_intelligence_source: LOCUS-ENG-003 (LOCUS-DOS-003)
locus_score: 7.6 (Young Professional persona)
locus_retrieved: 2026-04-01
locus_valid_until: 2026-07-01  # Per Walk Score validity (shortest window)
```

The downstream framework's validity is constrained by the shortest validity window in the LOCUS dossier's citations. If any LOCUS source has expired, the downstream framework must note: "Community intelligence data from LOCUS-ENG-003 may require refresh — see locus_valid_until."

---

## ID registry

Maintain a running registry of all engagement IDs:

**File:** `engagements/ID-REGISTRY.md`

```markdown
# LOCUS Engagement ID Registry

| ENG ID | Address | Persona | Tier | Status | DOS ID | Date |
|--------|---------|---------|------|--------|--------|------|
| LOCUS-ENG-001 | 1234 Pine St, Seattle WA 98101 | Young Professional | Complete | Delivered | LOCUS-DOS-001 | 2026-04-01 |
| LOCUS-ENG-002 | 567 Oak Ave, Portland OR 97201 | Family | Full | In Progress | — | 2026-04-03 |
| LOCUS-ENG-003 | [ABANDONED] | — | — | Retired | — | 2026-04-05 |
```

---

*LOCUS Traceability System — BHIL LOCUS Framework v1.0*
