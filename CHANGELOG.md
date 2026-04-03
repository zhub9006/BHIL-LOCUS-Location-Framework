# Changelog

All notable changes to the BHIL LOCUS Framework are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Planned
- P11: Short-Term Rental Viability module
- Comparative multi-address scoring workflow
- Google Places API v2 integration guide
- LOCUS Score API wrapper (Node.js reference implementation)

---

## [1.0.0] — 2025-Q2

### Added
- **Core prompts (P00–P10):** Full 9-dimension scoring suite covering walkability,
  food/social, recreation, errands, education, transportation, civic infrastructure,
  demographic trajectory, and business environment
- **Scoring system:** Percentile-hybrid methodology with z-score normalization,
  MSA-relative calibration, and six persona weight matrices
- **Four SKU tiers:** Express (15 min), Full (45 min), Complete (90 min),
  Enterprise (5–8 hrs) with defined step sequences and deliverable specs
- **Data source catalog:** 9 dimension-specific source files (d1–d9) covering
  free government, freemium API, and commercial data tiers
- **Integration layer:** Companion frameworks, compliance guidance, traceability
  chain, and data currency standards
- **Claude Code configuration:** settings.json with tool permissions, 6 skill
  definitions, 3 agent configs, and 4 rules files
- **8 output templates:** Engagement metadata, address profile, POI inventory,
  scorecard, day-in-the-life narrative, citations, comparative, and final dossier
- **Shell scripts:** new-engagement.sh, validate-templates.sh, check-citations.sh
- **Example dossier:** Full sample engagement for 4th Ave E, Capitol Hill, Seattle
- **GitHub CI:** Template validation, markdown linting, and release automation

### Design Decisions
- Fair housing compliance embedded at architecture level via path-scoped rules,
  not post-hoc disclaimers
- Three-tier data architecture: government → freemium → commercial
- Traceability chain: executive summary → scorecard → prompt output → citations
- Claude Code handles ~80% of data collection via WebSearch + WebFetch + Bash

---

## Version History

| Version | Date     | Highlights                              |
|---------|----------|-----------------------------------------|
| 1.0.0   | 2025-Q2  | Initial production release              |

---

*BHIL LOCUS Framework — MIT Licensed*
