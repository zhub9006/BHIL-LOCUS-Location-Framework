# BHIL LOCUS Framework — Claude Code Configuration

## Project identity

This is the **BHIL LOCUS Framework** — a production-grade location intelligence system that transforms a single address into a persona-adjusted, 9-dimension scored dossier. LOCUS stands for **Lifestyle, Opportunity, Community & Urban Scoring**.

**Framework:** LOCUS v1.0  
**Organization:** Barry Hurd Intelligence Lab (BHIL)  
**Stack:** Markdown, shell scripts, YAML, Claude Code skills + agents  
**Agent toolchain:** Claude Code primary, web-search-agent, scoring-agent, narrative-agent

---

## CRITICAL: Read this before doing anything

This is an **intelligence methodology repository**, not an application codebase. Every file is a prompt template, workflow guide, scoring rubric, or data-source specification.

**Before starting any engagement:**
1. Read `workflows/sku-tiers.md` to select the correct tier
2. Read `integration/compliance.md` — Fair Housing rules apply to all output
3. Use the `new-locus-engagement` skill to initialize the workspace
4. Never skip the engagement ID step — traceability is non-negotiable

**Before writing any dossier content:**
1. Read `.claude/rules/fair-housing.md` — applies to ALL agents
2. Read `.claude/rules/engagement-output.md` — governs output format
3. Every claim must have a source. Uncited claims are not permitted.

---

## Commands

```bash
# Initialize a new engagement workspace
./tools/scripts/new-engagement.sh "1234 Pine St, Seattle WA 98101" "Young Professional"

# Validate all prompt frontmatter
./tools/scripts/validate-templates.sh

# Check all citations in an engagement
./tools/scripts/check-citations.sh LOCUS-ENG-001
```

---

## Skills available

Use these via natural language in Claude Code — they load on demand:

| Skill | Trigger phrase | What it does |
|-------|---------------|--------------|
| `new-locus-engagement` | "new engagement for [address]" | Creates workspace, generates ENG ID, copies templates |
| `run-geospatial-baseline` | "run geospatial baseline" or "run P01" | Geocodes address, collects Walk Score + POI data |
| `run-poi-collection` | "run POI collection" or "run P02-P04" | Food, recreation, retail POI collection |
| `run-education-profile` | "run education profile" or "run P05" | School data collection via GreatSchools + NCES |
| `run-transit-analysis` | "run transit analysis" or "run P06" | GTFS + commute time data collection |
| `run-synthesis` | "run synthesis" or "synthesize" | Scoring + narrative + final dossier assembly |

---

## Agents

Three specialized agents handle different phases:

- **web-search-agent** — Data collection via WebSearch + WebFetch + Bash API calls
- **scoring-agent** — Applies fixed rubric to collected data (no web access)
- **narrative-agent** — Writes "Day in the Life" synthesis (strict accuracy constraints)

Agents are defined in `.claude/agents/`. Never invoke the scoring-agent or narrative-agent before data collection is complete.

---

## SKU tiers at a glance

| Tier | Run command | Prompts used | Approx time |
|------|------------|--------------|-------------|
| Express | `Run P00 only` | P00 | 15 min |
| Full | `Run Full tier` | P00+P01+P02+P05+P06+P08+P10 | 45 min |
| Complete | `Run Complete tier` | All 11 prompts | 90 min |
| Enterprise | `Run Enterprise tier for [N] addresses` | Complete × N + comparative | 4 hrs |

---

## Engagement ID conventions

```
LOCUS-ENG-001    ← Engagement (workspace)
LOCUS-DOS-001    ← Dossier output document
LOCUS-POI-001    ← Individual POI record
```

IDs are three-digit, zero-padded, sequential. Scripts auto-generate. Never reuse an ID.

---

## Scoring reference

**Percentile-to-score mapping:**

| Percentile | Score | Label |
|-----------|-------|-------|
| 95–100th | 10 | Exceptional |
| 85–95th | 9 | Outstanding |
| 75–85th | 8 | Excellent |
| 65–75th | 7 | Very Good |
| 50–65th | 6 | Good |
| 35–50th | 5 | Average |
| 25–35th | 4 | Below Average |
| 15–25th | 3 | Fair |
| 5–15th | 2 | Poor |
| 0–5th | 1 | Very Poor |

See `scoring/scoring-rubric.md` for dimension-level rubric tables.

---

## File naming conventions

```
Prompt templates:      P##-kebab-name.md           (e.g., P01-walkability-geospatial.md)
Output documents:      LOCUS-DOS-NNN-short-name.md  (e.g., LOCUS-DOS-001-final-dossier.md)
Engagement workspaces: engagements/LOCUS-ENG-NNN/
Scored outputs:        scorecard-LOCUS-ENG-NNN.md
```

---

## Rules reference

| Rule file | Scope | Governs |
|-----------|-------|---------|
| `locus-conventions.md` | Global | Naming, IDs, frontmatter format |
| `engagement-output.md` | `engagements/**/*.md` | Output citation requirements |
| `scoring-rules.md` | `**/scoring*.md`, `**/scorecard*.md` | Rubric application, no improvisation |
| `fair-housing.md` | All agents, all output | Demographic data handling, prohibited phrases |

---

## Context management

When working on this framework, keep sessions focused:

- **New engagement setup:** One session per engagement
- **Data collection (P01–P09):** Group by tier (run Full tier dimensions together)
- **Synthesis (P10):** Dedicated session; load all P01–P09 outputs before starting
- **Enterprise multi-address:** One address per sub-session; comparative in final session

If context reaches 60%, compact with:
```
/compact "Preserve engagement ID, address, persona, collected data points, and all source URLs"
```

**Never compact during scoring.** The full rubric must remain in context.

---

## Web search accessibility by source

| Source | Access Method | Notes |
|--------|--------------|-------|
| Walk Score | WebSearch `"[address] walk score"` | Score often in snippet; also WebFetch walkscore.com |
| GreatSchools | WebFetch greatschools.org profile pages | Rating bands visible; numeric requires Enterprise license |
| Census API | Bash `curl` to api.census.gov | FIPS-first pipeline; free, no rate limit concern |
| Overpass API | Bash `curl` to overpass-api.de | POI data; no key required |
| FEMA NFHL | WebSearch + ArcGIS REST service | Flood zone by coordinates |
| EPA AirNow | Bash `curl` to airnow.gov API | Free registration; AQI by ZIP |
| Yelp | WebFetch yelp.com business pages | Server-rendered; extractable |
| Zillow/Redfin | WebSearch snippets only | JS-heavy SPAs; WebFetch won't render |

---

*BHIL LOCUS Framework v1.0 — Human-Directed. AI-Enabled. Commercially Tested.*  
*[barryhurd.com](https://barryhurd.com)*
