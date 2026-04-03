---
template: prompt
id: P10
title: Synthesis & Final Dossier Generation
dimension: ALL
version: "1.0"
depends_on: [P01, P02, P03, P04, P05, P06, P07, P08, P09]
outputs: [final-dossier.md, scorecard.md, day-in-the-life.md, citations.md]
estimated_time: "15–20 minutes"
agents: [scoring-agent, narrative-agent]
---

# P10 — Synthesis & Final Dossier

**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Integrate all collected data from P01–P09 into a scored, compliant, client-ready LOCUS Intelligence Dossier. This prompt delegates scoring to the **scoring-agent** and narrative generation to the **narrative-agent**.

---

## Pre-Flight Checklist

Before running P10, verify all required prompts are complete for this SKU tier:

**Full SKU minimum (required):**
- [ ] P01 — Walkability & Geospatial
- [ ] P02 — Food, Drink & Social
- [ ] P04 — Daily Errands & Retail
- [ ] P06 — Transportation & Commute
- [ ] P07 — Civic Infrastructure & Safety
- [ ] P08 — Demographics & Trajectory

**Complete/Enterprise additional:**
- [ ] P03 — Recreation & Green Space
- [ ] P05 — Education (skip for Investor)
- [ ] P09 — Business Environment

If any required prompt is incomplete: STOP. Run missing prompts first.

**Citations check:**
```bash
ENGAGEMENT_DIR="engagements/{{ENGAGEMENT_ID}}"
echo "=== Citation count ==="
grep -c "CIT-" ${ENGAGEMENT_DIR}/citations.md || echo "0"
echo "=== Prompt outputs present ==="
ls ${ENGAGEMENT_DIR}/p*.md 2>/dev/null | wc -l
```

Minimum citations required: 10 (Full SKU), 15 (Complete), 20 (Enterprise).

---

## Step 1 — Load All Data

Read all prompt output files in sequence:
1. `engagements/{{ENGAGEMENT_ID}}/p01-walkability-geospatial-output.md`
2. `engagements/{{ENGAGEMENT_ID}}/p02-food-social-output.md` (if present)
3. `engagements/{{ENGAGEMENT_ID}}/p03-recreation-output.md` (if present)
4. `engagements/{{ENGAGEMENT_ID}}/p04-errands-retail-output.md` (if present)
5. `engagements/{{ENGAGEMENT_ID}}/p05-education-output.md` (if present)
6. `engagements/{{ENGAGEMENT_ID}}/p06-transportation-output.md` (if present)
7. `engagements/{{ENGAGEMENT_ID}}/p07-civic-safety-output.md` (if present)
8. `engagements/{{ENGAGEMENT_ID}}/p08-demographics-trajectory-output.md` (if present)
9. `engagements/{{ENGAGEMENT_ID}}/p09-business-environment-output.md` (if present)
10. `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md` (for persona + config)

---

## Step 2 — Delegate to Scoring Agent

**Instruction to scoring-agent:**

```
You are the LOCUS scoring-agent. Using the data loaded from all P01–P09 outputs above,
calculate dimension scores (D1–D9) and a persona-weighted composite score.

Required inputs from loaded data:
- Persona: {{PERSONA}} (load weights from scoring/persona-profiles.md)
- All scoring inputs labeled "Scoring Inputs" in each prompt output
- Missing data handling: per scoring/scoring-methodology.md Section 5
- Output format: per templates/scorecard-template.md

Rules:
- Apply percentile-to-score mapping per scoring/scoring-rubric.md
- Apply persona weights per scoring/persona-profiles.md
- Flag balance alert if 2+ dimensions score below 4.0
- Do not characterize neighborhoods — output numbers only
- Annotate confidence level per dimension (high/medium/low)
```

Write scorecard to: `engagements/{{ENGAGEMENT_ID}}/scorecard.md`

---

## Step 3 — Fair Housing Compliance Review

Before narrative generation, run compliance check:

```bash
ENGAGEMENT_DIR="engagements/{{ENGAGEMENT_ID}}"

echo "=== Fair Housing Compliance Check ==="
echo "Checking for prohibited terms..."

PROHIBITED_TERMS=(
  "neighborhood character"
  "type of people"
  "residents are"
  "demographic"
  "racial"
  "ethnic composition"
  "good neighborhood"
  "bad neighborhood"
  "safe neighborhood"
  "dangerous neighborhood"
  "changing neighborhood"
  "transitioning"
  "gentrifying"
)

VIOLATIONS=0
for term in "${PROHIBITED_TERMS[@]}"; do
  count=$(grep -ri "$term" ${ENGAGEMENT_DIR}/ 2>/dev/null | grep -v "fair-housing" | grep -v "compliance" | wc -l)
  if [ "$count" -gt "0" ]; then
    echo "  ⚠️  VIOLATION: '$term' found $count time(s)"
    VIOLATIONS=$((VIOLATIONS+1))
  fi
done

if [ "$VIOLATIONS" -eq "0" ]; then
  echo "  ✅ No prohibited terms found"
else
  echo "  ❌ $VIOLATIONS violation type(s) found — review before proceeding"
fi
```

If violations found: STOP. Review and remediate before proceeding to narrative generation.

---

## Step 4 — Delegate to Narrative Agent

**Instruction to narrative-agent:**

```
You are the LOCUS narrative-agent. Generate the final dossier narrative and day-in-the-life
section for engagement {{ENGAGEMENT_ID}}.

Inputs:
- Scorecard: [load from scorecard.md]
- All P01–P09 outputs: [loaded above]
- Persona: {{PERSONA}}
- Template: templates/dossier-template.md
- Day-in-the-life template: templates/day-in-the-life-template.md

Rules:
- Use specific named amenities from POI inventory — no generic references
- Temporal structure: Morning → Midday → Afternoon → Evening → Weekend
- Calibrate tone to persona: Investor=analytical, Family=warmth+safety, Retiree=ease+access
- Required blocks: AI disclosure, Fair Housing notice, attribution list
- Target length: Executive summary 150–200 words; each section 100–250 words
- Do not reproduce any prohibited phrases from fair-housing.md
- End every section with a citation count check
```

Write:
- `engagements/{{ENGAGEMENT_ID}}/final-dossier.md`
- `engagements/{{ENGAGEMENT_ID}}/day-in-the-life.md`

---

## Step 5 — Assemble Final Dossier

Merge into `final-dossier.md` following `templates/dossier-template.md` structure:

```
Executive Summary (with Quick LOCUS Scorecard table)
↓
Section 1: Location & Geospatial (from P01)
↓
Section 2: Food, Drink & Social (from P02)
↓
Section 3: Recreation & Green Space (from P03)
↓
Section 4: Daily Errands & Retail (from P04)
↓
Section 5: Education (from P05)
↓
Section 6: Transportation & Commute (from P06)
↓
Section 7: Civic Infrastructure & Safety (from P07)
↓
Section 8: Neighborhood Trajectory (from P08)
↓
Section 9: Business Environment (from P09)
↓
Section 10: Persona Fit Analysis
↓
Section 11: Day in the Life
↓
Methodology & Sources (citations summary)
↓
Required Attributions
↓
Fair Housing Notice
↓
AI Disclosure
```

---

## Step 6 — Final Validation

```bash
ENGAGEMENT_DIR="engagements/{{ENGAGEMENT_ID}}"

echo "=== P10 Final Validation ==="

# File existence checks
FILES=(
  "final-dossier.md"
  "scorecard.md"
  "day-in-the-life.md"
  "citations.md"
)

for f in "${FILES[@]}"; do
  if [ -f "${ENGAGEMENT_DIR}/${f}" ]; then
    lines=$(wc -l < "${ENGAGEMENT_DIR}/${f}")
    echo "  ✅ ${f} (${lines} lines)"
  else
    echo "  ❌ MISSING: ${f}"
  fi
done

# Required blocks
echo "--- Required Blocks Check ---"
for block in "Fair Housing" "AI Disclosure" "FILE_COMPLETE"; do
  if grep -q "$block" "${ENGAGEMENT_DIR}/final-dossier.md" 2>/dev/null; then
    echo "  ✅ $block block present"
  else
    echo "  ❌ $block block MISSING"
  fi
done

# Citation count
CIT_COUNT=$(grep -c "CIT-" "${ENGAGEMENT_DIR}/citations.md" 2>/dev/null || echo "0")
echo "--- Citations: ${CIT_COUNT} total ---"
```

---

## Step 7 — Update Metadata & Report

Update `engagement-metadata.md`:
- Set `P10_synthesis_dossier: true`
- Set `status: complete`
- Set `composite_score` and `composite_percentile`
- Set `fair_housing_review: true`
- Set `ai_disclosure_included: true`
- Set `last_updated` to today

**Completion report:**

```
╔══════════════════════════════════════════════════════════╗
║        LOCUS ENGAGEMENT COMPLETE — {{ENGAGEMENT_ID}}     ║
╠══════════════════════════════════════════════════════════╣
║  Address:    {{RAW_ADDRESS}}                             ║
║  Persona:    {{PERSONA}}                                 ║
║  Composite:  [X.X] / 10.0  ([XX]th percentile)          ║
║  SKU Tier:   {{SKU_TIER}}                                ║
╠══════════════════════════════════════════════════════════╣
║  Outputs:                                                ║
║    ✅ final-dossier.md ([N] lines)                       ║
║    ✅ scorecard.md                                       ║
║    ✅ day-in-the-life.md                                 ║
║    ✅ citations.md ([N] sources)                         ║
╠══════════════════════════════════════════════════════════╣
║  Compliance:                                             ║
║    ✅ Fair Housing review passed                         ║
║    ✅ AI disclosure included                             ║
║    ✅ Required attributions included                     ║
╠══════════════════════════════════════════════════════════╣
║  Files: engagements/{{ENGAGEMENT_ID}}/                   ║
╚══════════════════════════════════════════════════════════╝
```

---

*P10 complete — LOCUS engagement {{ENGAGEMENT_ID}} is ready for analyst review and delivery.*
