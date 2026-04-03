---
document: complete-workflow
version: "1.0"
sku_tier: complete
estimated_time: "80–105 minutes"
prompts_used: [P00, P01, P02, P03, P04, P05, P06, P07, P08, P09, P10]
---

# Complete Workflow — LOCUS

**Tier:** Complete · 11 prompts · ~90 minutes
**Best for:** Investment analysis, high-stakes buyer advisory, comprehensive site intelligence, any engagement where all 9 dimensions need full data

---

## When to Use Complete

| Situation | Use Complete? |
|-----------|-------------|
| Investor acquisition analysis | ✅ Yes |
| High-stakes buyer advisory ($1M+ property) | ✅ Yes |
| Commercial site selection | ✅ Yes |
| Full 9-dimension scoring required | ✅ Yes |
| Education data critical (Family persona) | ✅ Yes |
| Green space / recreation detail needed | ✅ Yes |
| Comparative analysis of multiple addresses | ❌ No — use Enterprise |

---

## Prompts Included — All 11

| Prompt | Dimension | Phase | Est. Time |
|--------|-----------|-------|----------|
| P01 | D1 Walkability | Foundation | 12 min |
| P02 | D2 Food & Social | Lifestyle | 10 min |
| P03 | D3 Recreation | Lifestyle | 8 min |
| P04 | D4 Errands & Retail | Lifestyle | 7 min |
| P05 | D5 Education | Lifestyle | 10 min |
| P06 | D6 Transportation | Infrastructure | 9 min |
| P07 | D7 Civic & Safety | Infrastructure | 12 min |
| P08 | D8 Trajectory | Market | 12 min |
| P09 | D9 Business | Market | 7 min |
| P10 | Synthesis | Output | 18 min |
| **Total** | | | **~105 min** |

*P05 skipped for Investor persona → ~95 min*

---

## Pre-Flight

```bash
bash tools/scripts/new-engagement.sh \
  --address "[FULL ADDRESS]" \
  --persona "[PERSONA]" \
  --tier complete \
  --client "[CLIENT_REF]"
```

---

## Execution Plan

### Phase 1 — Foundation (~12 min)

**P01** must run first. Outputs required by all subsequent prompts:
- Geocoded coordinates (lat/lon)
- FIPS state/county/tract codes
- Walk Score®, Transit Score®, Bike Score®
- Overpass 400m + 1500m POI baseline

```
Run: prompts/P01-walkability-geospatial.md
Output: engagements/{{ENGAGEMENT_ID}}/p01-walkability-geospatial-output.md
```

### Phase 2 — Lifestyle Data (~35 min)

Run in any order after P01. These prompts are independent of each other.

```
Run: prompts/P02-food-drink-social.md        (~10 min)
Run: prompts/P03-recreation-green-space.md   (~8 min)
Run: prompts/P04-daily-errands-retail.md     (~7 min)
Run: prompts/P05-education-profiling.md      (~10 min) [skip for Investor]
```

**Persona-specific notes for Phase 2:**
- **Family:** Prioritize P05 (Education) — highest weight dimension
- **Young Professional:** Prioritize P02 (Food & Social)
- **Retiree:** Prioritize P03 (Recreation) and P04 (Errands/Healthcare)
- **Investor:** Skip P05; all others run

### Phase 3 — Infrastructure & Market Data (~28 min)

```
Run: prompts/P06-transportation-commute.md        (~9 min)
Run: prompts/P07-civic-infrastructure.md          (~12 min)  ← Fair Housing: High
Run: prompts/P08-demographics-trajectory.md       (~12 min)  ← Fair Housing: Critical
Run: prompts/P09-business-environment.md          (~7 min)
```

**Phase 3 sequencing notes:**
- P07 requires FIPS codes from P01 for Census lookups
- P08 requires FIPS codes from P01 for ACS API calls
- P06 and P09 can run in parallel if multiple sessions available

### Phase 4 — Synthesis (~18 min)

Confirm all Phase 1–3 prompts complete before running P10.

```
Run: prompts/P10-synthesis-dossier.md
```

P10 will:
1. Load all prompt outputs
2. Delegate to scoring-agent (dimension scores + composite)
3. Run Fair Housing compliance check
4. Delegate to narrative-agent (dossier + day-in-the-life)
5. Assemble final-dossier.md
6. Run final validation script

---

## Complete Tier Output Files

```
engagements/{{ENGAGEMENT_ID}}/
├── engagement-metadata.md          ← status: complete
├── address-profile.md
├── citations.md                    ← 15–25 sources
├── p01-walkability-geospatial-output.md
├── p02-food-social-output.md
├── p03-recreation-output.md
├── p04-errands-retail-output.md
├── p05-education-output.md
├── p06-transportation-output.md
├── p07-civic-safety-output.md
├── p08-demographics-trajectory-output.md
├── p09-business-environment-output.md
├── scorecard.md                    ← full 9D scoring
├── day-in-the-life.md              ← persona narrative
└── final-dossier.md                ← primary deliverable (~4,000–6,000 words)
```

---

## Data Quality Targets for Complete Tier

| Dimension | Target Confidence | Minimum Sources |
|-----------|-----------------|----------------|
| D1 Walkability | High | Walk Score + OSM + Census |
| D2 Food & Social | High | Overpass + WebSearch |
| D3 Recreation | High | Overpass + TPL ParkServe |
| D4 Errands | High | Overpass + WebSearch |
| D5 Education | High | GreatSchools + NCES |
| D6 Transportation | Medium-High | Transit agency + Walk Score |
| D7 Civic & Safety | High | FBI UCR + FEMA + EPA |
| D8 Trajectory | High | ACS API + permits |
| D9 Business | Medium | Overpass + WebSearch |

If any dimension falls below "Medium" confidence, note in scorecard and flag for analyst review.

---

## Pre-Delivery Checklist

- [ ] All 10 prompt outputs present in engagement directory
- [ ] `final-dossier.md` ≥ 3,500 words
- [ ] `scorecard.md` contains all 9 dimension scores with confidence levels
- [ ] `citations.md` contains ≥ 15 citations with access dates
- [ ] `validate-templates.sh` passes
- [ ] `check-citations.sh` passes (no staleness flags)
- [ ] Fair Housing review complete (`engagement-metadata.md: fair_housing_review: true`)
- [ ] AI disclosure block in `final-dossier.md`
- [ ] Walk Score® attribution in `final-dossier.md`
- [ ] GreatSchools attribution in `final-dossier.md` (if P05 run)
- [ ] Analyst sign-off before delivery

---

*Complete Workflow · LOCUS Framework · BHIL · Human-Directed. AI-Enabled. Commercially Tested.*
