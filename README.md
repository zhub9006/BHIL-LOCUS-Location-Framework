# BHIL LOCUS Framework

**Human-Directed. AI-Enabled. Commercially Tested.**

> *"Location intelligence is fragmented across dozens of public and private data sources with no unified framework for synthesizing them into a defensible, persona-adjusted composite score. LOCUS fills this gap."*

**LOCUS** — **L**ifestyle, **O**pportunity, **C**ommunity & **U**rban **S**coring — is a production-grade location intelligence framework that transforms a single address into a comprehensive, traceable, persona-adjusted dossier using 11 structured prompts, Claude Code automation, and a layered data architecture combining free government sources with commercial APIs.

**Optimized for:** Claude Code · Solo practitioners · Residential advisory · Commercial site selection · Corporate relocation intelligence

---

## What this framework delivers

A LOCUS dossier answers the question every relocating family, site selection team, and real estate investor asks: *"What is it actually like to live, work, and invest here?"*

It does this by systematically collecting and scoring data across 9 dimensions, synthesizing them into a persona-weighted composite score, and generating a "Day in the Life" narrative that no static data tool produces — grounded in every claim being traceable to a specific source.

```
Address Input
     ↓
P00: Master Orchestration (Express SKU stops here)
     ↓
P01: Walkability & Geospatial Baseline
P02: Food, Drink & Social Scene
P03: Recreation & Green Space          ← Full & Complete SKUs
P04: Daily Errands & Retail
P05: Education Profiling
P06: Transportation & Commute
P07: Civic Infrastructure & Safety
P08: Demographic Character & Trajectory
P09: Business Environment
     ↓
P10: Synthesis & Final Dossier
     ↓
LOCUS Score + Day-in-the-Life Narrative + Citations
```

---

## Repository structure

```
BHIL-LOCUS-Framework/
├── README.md                          ← You are here
├── CLAUDE.md                          ← Claude Code project configuration
├── LICENSE                            ← MIT License
├── CONTRIBUTING.md                    ← Contribution guidelines
├── CHANGELOG.md                       ← Version history
│
├── .github/
│   ├── workflows/
│   │   ├── validate-templates.yml     ← Frontmatter schema validation
│   │   ├── lint-markdown.yml          ← markdownlint + dead link checking
│   │   └── release.yml                ← Semantic versioning + tagging
│   └── PULL_REQUEST_TEMPLATE.md
│
├── .claude/
│   ├── settings.json                  ← Tool permissions, model routing
│   ├── rules/
│   │   ├── locus-conventions.md       ← Global naming and ID format rules
│   │   ├── engagement-output.md       ← Path-scoped: engagements/**/*.md
│   │   ├── scoring-rules.md           ← Path-scoped: **/scoring*.md
│   │   └── fair-housing.md            ← Demographic data handling rules
│   ├── skills/
│   │   ├── new-locus-engagement/SKILL.md
│   │   ├── run-geospatial-baseline/SKILL.md
│   │   ├── run-poi-collection/SKILL.md
│   │   ├── run-education-profile/SKILL.md
│   │   ├── run-transit-analysis/SKILL.md
│   │   └── run-synthesis/SKILL.md
│   └── agents/
│       ├── web-search-agent.md
│       ├── scoring-agent.md
│       └── narrative-agent.md
│
├── prompts/                           ← 11 structured prompt templates
│   ├── P00-master-locus.md
│   ├── P01-walkability-geospatial.md
│   ├── P02-food-drink-social.md
│   ├── P03-recreation-green-space.md
│   ├── P04-daily-errands-retail.md
│   ├── P05-education-profiling.md
│   ├── P06-transportation-commute.md
│   ├── P07-civic-infrastructure.md
│   ├── P08-demographics-trajectory.md
│   ├── P09-business-environment.md
│   └── P10-synthesis-dossier.md
│
├── templates/                         ← Copy-and-fill output templates
│   ├── address-profile.md
│   ├── dossier-template.md
│   ├── scorecard-template.md
│   ├── poi-inventory-template.md
│   ├── day-in-the-life-template.md
│   ├── engagement-metadata.md
│   ├── citations-template.md
│   └── comparative-template.md
│
├── scoring/                           ← Scoring system documentation
│   ├── scoring-methodology.md
│   ├── scoring-rubric.md
│   ├── persona-profiles.md
│   └── trajectory-methodology.md
│
├── data-sources/                      ← Per-domain source guides (9 files)
│   ├── walkability-geospatial.md
│   ├── food-drink-social.md
│   ├── recreation-green-space.md
│   ├── daily-errands-retail.md
│   ├── education-profiling.md
│   ├── transportation-commute.md
│   ├── civic-infrastructure.md
│   ├── demographics-trajectory.md
│   └── business-environment.md
│
├── workflows/                         ← SKU-tier workflow guides
│   ├── sku-tiers.md
│   ├── express-workflow.md
│   ├── full-workflow.md
│   ├── complete-workflow.md
│   └── enterprise-workflow.md
│
├── integration/                       ← Ecosystem integration guides
│   ├── companion-frameworks.md
│   ├── traceability.md
│   ├── data-currency.md
│   └── compliance.md
│
├── tools/scripts/                     ← Automation scripts
│   ├── new-engagement.sh
│   ├── validate-templates.sh
│   └── check-citations.sh
│
├── engagements/                       ← Active engagement workspaces (gitignored)
│   └── .gitkeep
│
└── examples/sample-dossier/          ← Complete worked example
    ├── engagement-metadata.md
    ├── p01-baseline.md
    ├── p02-food-drink.md
    ├── p10-synthesis.md
    ├── final-dossier.md
    └── citations.md
```

---

## Quick start (5 minutes)

**Step 1 — Clone or use as template**

```bash
git clone https://github.com/camalus/BHIL-LOCUS-Framework.git
cd BHIL-LOCUS-Framework
chmod +x tools/scripts/*.sh
```

**Step 2 — Load into Claude Code**

```bash
claude  # Opens Claude Code in project root
# Claude reads CLAUDE.md, loads all skills and agents automatically
```

**Step 3 — Start your first engagement**

In Claude Code:
```
Use the new-locus-engagement skill for 1234 Pine Street, Seattle WA 98101, persona: Young Professional
```

Claude Code will:
- Generate engagement ID `LOCUS-ENG-001`
- Create the directory structure under `engagements/LOCUS-ENG-001/`
- Copy all relevant prompt templates
- Record address, persona, and initiation timestamp

**Step 4 — Run the analysis**

```
Run the geospatial baseline for LOCUS-ENG-001
Run POI collection for LOCUS-ENG-001
Run education profile for LOCUS-ENG-001
Run synthesis for LOCUS-ENG-001
```

**Step 5 — Review and deliver**

The engagement workspace contains:
- `scorecard.md` — Dimension scores and composite LOCUS Score
- `day-in-the-life.md` — Second-person narrative synthesis
- `final-dossier.md` — Complete formatted dossier
- `citations.md` — Every source with retrieval date and currency status

---

## SKU tiers

| Tier | Prompts | Turnaround | Use Case |
|------|---------|-----------|----------|
| **Express** | P00 only | ~15 min | Quick screening, early filtering |
| **Full** | P00 + P01, P02, P05, P06, P08, P10 | ~45 min | Standard residential advisory |
| **Complete** | All 11 prompts | ~90 min | Comprehensive residential or commercial |
| **Enterprise** | Complete × N + comparative | ~4 hours | Corporate relocation, portfolio intelligence |

See `workflows/sku-tiers.md` for full tier definitions and decision criteria.

---

## The LOCUS Score

The composite LOCUS Score is a persona-weighted arithmetic mean across 9 dimensions, each scored 1–10 using a percentile-hybrid methodology anchored in validated third-party data:

| Dimension | Default Weight | Primary Source |
|-----------|---------------|----------------|
| Walkability & Accessibility | 12% | Walk Score API |
| Food, Drink & Social | 10% | Google Places, Yelp |
| Recreation & Green Space | 10% | Trust for Public Land, EPA EnviroAtlas |
| Daily Errands & Retail | 10% | Overpass API, Google Places |
| Education Quality | 15% | GreatSchools, NCES CCD |
| Transit & Commute | 10% | GTFS feeds, Transit Score |
| Civic Infrastructure & Safety | 15% | FBI UCR, FEMA, EPA AirNow |
| Demographic Trajectory | 10% | Census ACS, Zillow ZHVI |
| Business Environment | 8% | Census CBP, BLS QCEW |

Six persona profiles (Family, Young Professional, Retiree, Investor, Remote Worker, Custom) shift weights dramatically. See `scoring/persona-profiles.md`.

---

## Data architecture

LOCUS uses a three-tier data architecture:

**Tier 1 — Free government/open data (always available)**
Census Bureau APIs, FEMA NFHL, EPA AirNow, FBI UCR, GTFS feeds, OpenStreetMap, BLS, USDA Food Atlas

**Tier 2 — Freemium APIs (Express and Full tiers)**
Walk Score (5,000 calls/day free), Google Places (10,000 free/month), GreatSchools NearbySchools API

**Tier 3 — Commercial APIs (Enterprise tier)**
Yelp Fusion ($7.99/1,000 after trial), Foursquare Premium, Esri ArcGIS Online, Placer.ai foot traffic

**Claude Code handles ~80% of LOCUS data collection** via WebSearch + WebFetch + Bash API calls — no paid API keys required for Express and Full tiers.

---

## Traceability system

Every claim in every LOCUS dossier traces back to a specific source:

| ID Type | Format | Purpose |
|---------|--------|---------|
| Engagement | `LOCUS-ENG-NNN` | Workspace-level identifier |
| Dossier | `LOCUS-DOS-NNN` | Output document identifier |
| POI Record | `LOCUS-POI-NNN` | Individual place record |

Every dossier claim uses inline references: `[P01-walkability]`, `[P05-education]`. The `citations.md` file maps every data point to its source URL and retrieval date.

See `integration/traceability.md` for the full system specification.

---

## Fair Housing compliance

LOCUS embeds Fair Housing Act compliance into its architecture, not as a disclaimer:

- Path-scoped rules in `.claude/rules/fair-housing.md` govern every agent
- Demographic data is presented as objective statistics, never qualitative characterizations
- Racial/ethnic composition data is omitted from residential reports by default
- Every dossier includes AI disclosure and data attribution
- Identical data is presented to all users regardless of user characteristics

See `integration/compliance.md` for the complete compliance framework.

---

## BHIL ecosystem integration

LOCUS integrates with companion BHIL intelligence frameworks:

- **→ SENTINEL** (property asset intelligence): LOCUS provides community context; SENTINEL analyzes the property
- **→ VANTAGE** (digital audit): LOCUS P09 commercial corridor data feeds VANTAGE's physical-digital gap analysis
- **→ CODEX** (corporate dossier): Enterprise LOCUS feeds CODEX's operating environment section
- **→ VERDICT** (fund due diligence): LOCUS P08-P09 feeds neighborhood-level underwriting

Cross-toolkit traceability chain: `LOCUS-ENG-NNN → SENTINEL-PROP-NNN`

See `integration/companion-frameworks.md` for integration specifications.

---

## Legal notices

**Walk Score®** is a registered trademark of Redfin Corporation. All Walk Score display requires the ® symbol on first reference, a link to the address's walkscore.com page, and attribution to "Redfin Real Estate."

**GreatSchools** ratings require attribution with logo and school profile links per their terms of service. Numeric 1–10 ratings require an Enterprise Data License. This framework uses publicly visible rating bands only by default.

**Fair Housing Act (42 U.S.C. §§ 3601–3619)** prohibits steering based on protected characteristics. LOCUS is designed as an objective information tool, not a recommendation engine.

---

## About

**Author:** Barry Hurd  
**Organization:** Barry Hurd Intelligence Lab (BHIL)  
**Tagline:** Human-Directed. AI-Enabled. Commercially Tested.  
**Website:** [barryhurd.com](https://barryhurd.com)

---

## License

[MIT License](LICENSE)

This framework is open-source. Attribution appreciated: *BHIL LOCUS Framework by Barry Hurd (barryhurd.com)*
