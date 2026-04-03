---
document: enterprise-workflow
version: "1.0"
sku_tier: enterprise
estimated_time: "5–8 hours (N addresses)"
prompts_used: [P00, P01-P10 per address, comparative synthesis]
---

# Enterprise Workflow — LOCUS

**Tier:** Enterprise · Multi-address · 5–8 hours
**Best for:** Portfolio analysis, market survey, competitive positioning, site selection across multiple candidates

---

## When to Use Enterprise

| Situation | Use Enterprise? |
|-----------|---------------|
| 3+ address comparison | ✅ Yes |
| Fund-level portfolio analysis | ✅ Yes |
| Franchise site selection (2+ candidates) | ✅ Yes |
| Relocation advisory (city-to-city) | ✅ Yes |
| Market survey (MSA-level scan) | ✅ Yes |
| Single address, full analysis | ❌ No — use Complete |

---

## Enterprise Structure

Enterprise = **N × Complete engagements** + **Comparative Synthesis**

```
Enterprise Engagement (ENG-YYYY-NNNN)
├── Address 1 engagement → Complete workflow → final-dossier.md
├── Address 2 engagement → Complete workflow → final-dossier.md
├── Address 3 engagement → Complete workflow → final-dossier.md
│   ... (N addresses)
└── Comparative Synthesis → comparative-analysis.md
```

Each address is a full engagement with its own ID. The Enterprise engagement wraps them.

---

## Pre-Flight

### Step 1 — Create Enterprise Master Workspace

```bash
# Create Enterprise master engagement
bash tools/scripts/new-engagement.sh \
  --address "ENTERPRISE-MULTI" \
  --persona "[PERSONA]" \
  --tier enterprise \
  --client "[CLIENT_REF]"

# Record the Enterprise master ID (e.g., ENG-2024-0055)
ENTERPRISE_ID="ENG-[YYYY]-[NNNN]"
```

### Step 2 — Create Individual Address Engagements

For each address (N addresses), create a separate engagement:

```bash
for addr in "ADDRESS_1" "ADDRESS_2" "ADDRESS_3"; do
  bash tools/scripts/new-engagement.sh \
    --address "$addr" \
    --persona "[PERSONA]" \
    --tier complete \
    --client "[CLIENT_REF]-[N]" \
    --parent "${ENTERPRISE_ID}"
done
```

### Step 3 — Record in Enterprise Metadata

In `engagements/${ENTERPRISE_ID}/engagement-metadata.md`:
```yaml
comparison_addresses:
  - id: "ENG-[YYYY]-[NNNN+1]"
    address: "ADDRESS_1"
    role: "[baseline | candidate | competitor | portfolio]"
  - id: "ENG-[YYYY]-[NNNN+2]"
    address: "ADDRESS_2"
    role: "[role]"
```

---

## Execution Plan

### Phase 1 — Individual Engagements (parallel where possible)

Run Complete workflow for each address. For N addresses:

| Time Budget | N Addresses | Strategy |
|------------|------------|---------|
| 3–4 hours | 2 addresses | Sequential, one analyst |
| 4–5 hours | 3 addresses | Sequential or 2 parallel sessions |
| 5–6 hours | 4 addresses | 2 parallel sessions |
| 6–8 hours | 5–6 addresses | 2–3 parallel sessions |

**Parallelization rule:** P01 must complete before Phase 2 prompts for that address. Multiple addresses can run simultaneously in separate Claude Code sessions.

**Priority sequencing for tight deadlines:**
1. Run all P01s first (establishes geocodes for all addresses)
2. Run all P07s and P08s (most time-sensitive due to API calls)
3. Run remaining prompts in batches
4. Run all P10s last

---

### Phase 2 — Quality Verification (~30 min)

Before comparative synthesis, verify each address engagement:

```bash
ENTERPRISE_ID="[ENTERPRISE_ID]"

echo "=== Enterprise Quality Check ==="
# List all child engagements from ID-REGISTRY
grep "${ENTERPRISE_ID}" engagements/ID-REGISTRY.md

# For each child engagement, verify final-dossier exists
for child_dir in engagements/ENG-*/; do
  engagement_id=$(basename ${child_dir})
  if [ -f "${child_dir}/final-dossier.md" ]; then
    score=$(grep "COMPOSITE LOCUS SCORE" "${child_dir}/scorecard.md" 2>/dev/null | head -1)
    echo "  ✅ ${engagement_id}: ${score}"
  else
    echo "  ❌ ${engagement_id}: final-dossier.md MISSING"
  fi
done
```

Resolve any missing outputs before proceeding to comparative synthesis.

---

### Phase 3 — Comparative Synthesis (~45–60 min)

**Load all child scorecard.md files.**

Instruct scoring-agent:

```
You are the LOCUS scoring-agent performing Enterprise comparative synthesis.
Load scorecard.md from each child engagement listed in the Enterprise metadata.

Produce comparative-analysis.md using templates/comparative-template.md:
1. Composite score rankings table (all N addresses, sorted descending)
2. Dimension-by-dimension matrix (N addresses × 9 dimensions)
3. Comparative strengths section (one block per address)
4. Decision framework by persona sub-type
5. Market positioning analysis (if portfolio/competitive type)

Rules:
- Use raw (unweighted) dimension scores in the comparison matrix for cross-address comparability
- Apply persona weights only to composite rankings
- Flag any dimension with >2.0 point variance across addresses as a "key differentiator"
- All scores sourced from individual scorecard.md files — do not re-score
```

Write to: `engagements/{{ENTERPRISE_ID}}/comparative-analysis.md`

---

### Phase 4 — Enterprise Deliverable Assembly (~30 min)

Assemble the Enterprise deliverable package:

```
Enterprise Deliverable Package:
├── comparative-analysis.md          ← primary comparative output
├── executive-summary.md             ← 1-page summary of all addresses + recommendation context
├── [ENG-NNNN-1]/final-dossier.md   ← full dossier: Address 1
├── [ENG-NNNN-2]/final-dossier.md   ← full dossier: Address 2
│   ...
└── citations-master.md             ← aggregated citations across all engagements
```

**Executive summary format:**

```markdown
# LOCUS Enterprise Analysis — Executive Summary

## Engagement: {{ENTERPRISE_ID}}
**Client:** [CLIENT]
**Addresses Analyzed:** [N]
**Persona:** [PERSONA]
**Analysis Date:** [DATE]

## Rankings Overview
[Paste composite rankings table from comparative-analysis.md]

## Key Finding
[2–3 sentences: what does this comparative analysis reveal? Which address leads and why?]

## Dimension Leaders
[Table: which address scored highest in each dimension]

## Analyst Notes
[Any data quality flags, caveats, or factors not captured in scores]

---
[Fair Housing Notice]
[AI Disclosure]
```

---

## Enterprise Turnaround Estimates

| N Addresses | Single Session | Two Parallel Sessions |
|------------|---------------|----------------------|
| 2 | 3–4 hrs | 2.5 hrs |
| 3 | 4.5–6 hrs | 3.5 hrs |
| 4 | 6–8 hrs | 4.5 hrs |
| 5 | 8–10 hrs | 5.5 hrs |
| 6+ | Requires planning | Multi-day recommended |

---

## Enterprise Compliance Notes

- Each individual engagement must pass Fair Housing review before comparative synthesis
- Comparative analysis must not rank or characterize addresses using protected-class data
- comparative-analysis.md must include Fair Housing Notice and AI Disclosure
- Enterprise deliverable package citation count: minimum 20 total sources across all engagements

---

*Enterprise Workflow · LOCUS Framework · BHIL · Human-Directed. AI-Enabled. Commercially Tested.*
