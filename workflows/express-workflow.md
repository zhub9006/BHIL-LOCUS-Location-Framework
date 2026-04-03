---
document: express-workflow
version: "1.0"
sku_tier: express
estimated_time: "10–20 minutes"
prompts_used: [P00]
---

# Express Workflow — LOCUS

**Tier:** Express · Single-prompt · ~15 minutes
**Best for:** Quick qualification, client previews, portfolio screening, initial triage

---

## When to Use Express

| Situation | Use Express? |
|-----------|-------------|
| Initial client qualification | ✅ Yes |
| Pre-listing competitive scan | ✅ Yes |
| Portfolio screening (10+ addresses) | ✅ Yes |
| Client wants a preview before committing to Full | ✅ Yes |
| Client needs a deliverable dossier | ❌ No — use Full or Complete |
| Fair Housing compliance documentation required | ❌ No — use Full+ |
| Investment decision support | ❌ No — use Complete or Enterprise |

---

## Execution Steps

### Step 1 — Prepare Inputs (2 min)

Gather:
- Full street address with city, state, ZIP
- Persona (or default to "general" if unknown)
- Client reference code (optional)

No engagement ID required for Express — skip `new-engagement.sh`.

---

### Step 2 — Run P00 Master Prompt (10–15 min)

Open Claude Code in this repository. Run:

```
/skill new-locus-engagement [skip — Express tier does not require full workspace]

Load prompt: prompts/P00-master-locus.md
Select: Express SKU section
```

Input to P00:
```
Address: [FULL ADDRESS]
Persona: [PERSONA or general]
Tier: Express
```

P00 Express will run approximately 9 web search queries covering all 9 dimensions at a surface level and return a Quick LOCUS Score table.

---

### Step 3 — Review Output

P00 Express returns:

```
Quick LOCUS Score — [ADDRESS]
Persona: [PERSONA]

D1 Walkability:          [X.X] / 10
D2 Food & Social:        [X.X] / 10
D3 Recreation:           [X.X] / 10
D4 Errands & Retail:     [X.X] / 10
D5 Education:            [X.X] / 10
D6 Transportation:       [X.X] / 10
D7 Civic & Safety:       [X.X] / 10
D8 Trajectory:           [X.X] / 10
D9 Business:             [X.X] / 10

COMPOSITE LOCUS SCORE:   [X.X] / 10
(Unweighted — persona weights require Full tier)

Note: Express scores are directional estimates.
Full scoring methodology: prompts/P01–P10
```

---

### Step 4 — Express Limitations Disclosure

**Always communicate to client:**

> This Express LOCUS Score is a directional estimate based on a rapid AI search analysis. It uses unweighted averages across all 9 dimensions — persona weights, sub-metric scoring, and full data verification are available with the Full or Complete tier. Express scores should not be used as standalone deliverables for commercial transactions, investment decisions, or client-facing reports without analyst review.

---

### Step 5 — Decide Next Step

| Express Result | Recommended Next Step |
|---------------|----------------------|
| Composite >7.5 | Proceed with Full tier for client dossier |
| Composite 5.5–7.5 | Full tier recommended; flag low dimensions |
| Composite <5.5 | Discuss with client before committing to full engagement |
| One dimension unexpectedly low | Full tier to validate that dimension specifically |

---

## Express Deliverable Format

Express does not produce a formal dossier. Acceptable outputs:
- Inline score table (shared via message/email)
- Screenshot of Claude Code output
- Brief analyst email summary of Quick LOCUS Score

**Not acceptable for client delivery:**
- Express output presented as a LOCUS Dossier
- Express scores without the limitations disclosure

---

## Upgrade Path

To upgrade an Express engagement to Full or Complete:

1. Run `new-engagement.sh` to create formal workspace
2. Run P01 first (geocoding + Walk Score establishes the foundation)
3. Run remaining prompts per tier (see `workflows/full-workflow.md`)
4. Express score can be referenced in engagement notes but is superseded by Full scores

---

*Express Workflow · LOCUS Framework · BHIL*
*Full methodology: `scoring/scoring-methodology.md` · Compliance: `integration/compliance.md`*
