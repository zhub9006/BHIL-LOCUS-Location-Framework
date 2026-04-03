#!/usr/bin/env bash
# =============================================================================
# BHIL LOCUS Framework — New Engagement Initialization Script
# =============================================================================
# Usage: ./tools/scripts/new-engagement.sh "ADDRESS" "PERSONA" [TIER]
#
# Examples:
#   ./tools/scripts/new-engagement.sh "1234 Pine St, Seattle WA 98101" "Young Professional"
#   ./tools/scripts/new-engagement.sh "567 Oak Ave, Portland OR 97201" "Family" "Full"
#   ./tools/scripts/new-engagement.sh "890 Main St, Denver CO 80202" "Investor" "Enterprise"
#
# Arguments:
#   ADDRESS   Full street address including city, state, ZIP (quoted)
#   PERSONA   One of: Family, Young Professional, Retiree, Investor, Remote Worker, Custom
#   TIER      One of: Express, Full, Complete, Enterprise (default: Complete)
#
# Output:
#   - Creates engagement workspace in engagements/LOCUS-ENG-NNN/
#   - Assigns next sequential engagement ID
#   - Generates engagement-metadata.md
#   - Initializes citations.md
#   - Copies address-profile.md template
#   - Registers ID in engagements/ID-REGISTRY.md
# =============================================================================

set -euo pipefail

# ─── Input validation ───────────────────────────────────────────────────────

if [ $# -lt 2 ]; then
    echo "Usage: $0 \"ADDRESS\" \"PERSONA\" [TIER]"
    echo "Example: $0 \"1234 Pine St, Seattle WA 98101\" \"Young Professional\" \"Complete\""
    exit 1
fi

ADDRESS="$1"
PERSONA="$2"
TIER="${3:-Complete}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TODAY=$(date +"%Y-%m-%d")

# Validate persona
VALID_PERSONAS=("Family" "Young Professional" "Retiree" "Investor" "Remote Worker" "Custom")
PERSONA_VALID=false
for p in "${VALID_PERSONAS[@]}"; do
    if [ "$PERSONA" = "$p" ]; then
        PERSONA_VALID=true
        break
    fi
done

if [ "$PERSONA_VALID" = false ]; then
    echo "ERROR: Invalid persona '$PERSONA'"
    echo "Valid personas: Family | Young Professional | Retiree | Investor | Remote Worker | Custom"
    exit 1
fi

# Validate tier
VALID_TIERS=("Express" "Full" "Complete" "Enterprise")
TIER_VALID=false
for t in "${VALID_TIERS[@]}"; do
    if [ "$TIER" = "$t" ]; then
        TIER_VALID=true
        break
    fi
done

if [ "$TIER_VALID" = false ]; then
    echo "ERROR: Invalid tier '$TIER'"
    echo "Valid tiers: Express | Full | Complete | Enterprise"
    exit 1
fi

# ─── Generate engagement ID ──────────────────────────────────────────────────

# Find highest existing ID
EXISTING=$(ls engagements/ 2>/dev/null | grep -oP 'LOCUS-ENG-\K\d+' | sort -n | tail -1)

if [ -z "$EXISTING" ]; then
    NEXT_NUM=1
else
    NEXT_NUM=$((EXISTING + 1))
fi

ENG_ID=$(printf "LOCUS-ENG-%03d" $NEXT_NUM)
BASE="engagements/${ENG_ID}"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  BHIL LOCUS Framework — New Engagement Initialization"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  Engagement ID: ${ENG_ID}"
echo "  Address:       ${ADDRESS}"
echo "  Persona:       ${PERSONA}"
echo "  SKU Tier:      ${TIER}"
echo "  Initialized:   ${TIMESTAMP}"
echo ""
echo "─────────────────────────────────────────────────────────────"

# ─── Set prompts by tier ─────────────────────────────────────────────────────

case "$TIER" in
    "Express")
        PROMPTS_PENDING='["P00"]'
        ;;
    "Full")
        PROMPTS_PENDING='["P00","P01","P02","P05","P06","P08","P10"]'
        ;;
    "Complete"|"Enterprise")
        PROMPTS_PENDING='["P00","P01","P02","P03","P04","P05","P06","P07","P08","P09","P10"]'
        ;;
esac

# ─── Create directory structure ──────────────────────────────────────────────

echo "  Creating directory structure..."

if [ "$TIER" != "Express" ]; then
    mkdir -p "${BASE}/p01-geospatial-baseline/raw-data"
    mkdir -p "${BASE}/p02-food-drink/raw-data"
    mkdir -p "${BASE}/p03-recreation/raw-data"
    mkdir -p "${BASE}/p04-errands-retail/raw-data"
    mkdir -p "${BASE}/p05-education/raw-data"
    mkdir -p "${BASE}/p06-transportation/raw-data"
    mkdir -p "${BASE}/p07-civic/raw-data"
    mkdir -p "${BASE}/p08-demographics/raw-data"
    mkdir -p "${BASE}/p09-business/raw-data"
    mkdir -p "${BASE}/p10-synthesis"
fi

echo "  ✅ Directories created"

# ─── Create engagement-metadata.md ───────────────────────────────────────────

cat > "${BASE}/engagement-metadata.md" << METADATA
---
engagement_id: ${ENG_ID}
address: "${ADDRESS}"
coordinates:
  lat: null
  lon: null
fips:
  state: null
  county: null
  tract: null
  block_group: null
persona: "${PERSONA}"
sku_tier: ${TIER}
analysis_subject: Residential
initiated_at: "${TIMESTAMP}"
initiated_by: "BHIL LOCUS Framework v1.0"
status: in-progress
prompts_completed: []
prompts_pending: ${PROMPTS_PENDING}
downstream_references: []
human_review:
  reviewer: null
  reviewed_at: null
  fair_housing_confirmed: false
  prohibited_phrases_checked: false
  ai_disclosure_present: false
  attribution_verified: false
  citations_complete: false
  delivery_gate_passed: false
notes: ""
---

# Engagement Metadata — ${ENG_ID}

**Address:** ${ADDRESS}  
**Persona:** ${PERSONA}  
**SKU Tier:** ${TIER}  
**Initiated:** ${TIMESTAMP}

## Status

Current status: **in-progress**

Update this file as prompts complete. The scoring-agent reads \`prompts_completed\` 
to verify all required data is available before synthesis.

## Prompts

**Pending:** See YAML frontmatter \`prompts_pending\`

Mark complete by moving from pending to completed as each prompt finishes.

## Human Review Gate

**Required before delivery.** Update \`human_review\` block with reviewer attestation.
See \`integration/compliance.md\` for the complete delivery checklist.
METADATA

echo "  ✅ engagement-metadata.md created"

# ─── Create citations.md ─────────────────────────────────────────────────────

cat > "${BASE}/citations.md" << CITATIONS
---
engagement_id: ${ENG_ID}
address: "${ADDRESS}"
created: "${TODAY}"
last_updated: "${TODAY}"
---

# Citations — ${ENG_ID}

All data sources used in this engagement are documented in the table below.
Every row must be added by the web-search-agent during data collection.
No claim in the final dossier is valid without a corresponding row in this table.

See \`integration/traceability.md\` for full citation standards and validity windows.

---

| Claim | Dimension | Source Name | URL | Retrieved | Valid Until | Confidence |
|-------|-----------|-------------|-----|-----------|-------------|-----------|
CITATIONS

echo "  ✅ citations.md initialized"

# ─── Copy address profile template ───────────────────────────────────────────

if [ -f "templates/address-profile.md" ]; then
    cp "templates/address-profile.md" "${BASE}/address-profile.md"
    # Fill in the address and persona
    sed -i "s/\[\[address\]\]/${ADDRESS}/g" "${BASE}/address-profile.md" 2>/dev/null || \
    sed -i '' "s/\[\[address\]\]/${ADDRESS}/g" "${BASE}/address-profile.md"
    sed -i "s/\[\[persona\]\]/${PERSONA}/g" "${BASE}/address-profile.md" 2>/dev/null || \
    sed -i '' "s/\[\[persona\]\]/${PERSONA}/g" "${BASE}/address-profile.md"
    sed -i "s/\[\[sku_tier\]\]/${TIER}/g" "${BASE}/address-profile.md" 2>/dev/null || \
    sed -i '' "s/\[\[sku_tier\]\]/${TIER}/g" "${BASE}/address-profile.md"
    echo "  ✅ address-profile.md copied and populated"
else
    echo "  ⚠️ templates/address-profile.md not found — create address-profile.md manually"
fi

# ─── Register in ID registry ─────────────────────────────────────────────────

REGISTRY="engagements/ID-REGISTRY.md"

if [ ! -f "$REGISTRY" ]; then
    cat > "$REGISTRY" << REGISTRY_HEADER
# LOCUS Engagement ID Registry

| ENG ID | Address | Persona | Tier | Status | DOS ID | Date |
|--------|---------|---------|------|--------|--------|------|
REGISTRY_HEADER
fi

echo "| ${ENG_ID} | ${ADDRESS} | ${PERSONA} | ${TIER} | in-progress | — | ${TODAY} |" >> "$REGISTRY"
echo "  ✅ ID registered in engagements/ID-REGISTRY.md"

# ─── Final report ─────────────────────────────────────────────────────────────

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Engagement workspace ready: ${BASE}/"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  Files created:"
echo "  ├── engagement-metadata.md"
echo "  ├── citations.md"
echo "  ├── address-profile.md"
if [ "$TIER" != "Express" ]; then
echo "  ├── p01-geospatial-baseline/"
echo "  ├── p02-food-drink/"
echo "  ├── p03-recreation/"
echo "  ├── p04-errands-retail/"
echo "  ├── p05-education/"
echo "  ├── p06-transportation/"
echo "  ├── p07-civic/"
echo "  ├── p08-demographics/"
echo "  ├── p09-business/"
echo "  └── p10-synthesis/"
fi
echo ""
echo "  Next steps:"
echo ""

case "$TIER" in
    "Express")
        echo "  Run in Claude Code:"
        echo "    \"Run Express LOCUS for ${ENG_ID}\""
        echo "    Time estimate: ~15 minutes"
        ;;
    "Full")
        echo "  Run in Claude Code:"
        echo "    \"Run Full tier for ${ENG_ID}\""
        echo "    Time estimate: ~45 minutes"
        echo ""
        echo "  Or run prompts individually:"
        echo "    \"Run geospatial baseline for ${ENG_ID}\"  → P01"
        echo "    \"Run POI collection for ${ENG_ID}\"       → P02"
        echo "    \"Run education profile for ${ENG_ID}\"    → P05"
        echo "    \"Run transit analysis for ${ENG_ID}\"     → P06"
        echo "    \"Run demographics for ${ENG_ID}\"         → P08"
        echo "    \"Run synthesis for ${ENG_ID}\"            → P10"
        ;;
    "Complete"|"Enterprise")
        echo "  Run in Claude Code:"
        echo "    \"Run Complete tier for ${ENG_ID}\""
        echo "    Time estimate: ~90 minutes"
        echo ""
        echo "  Or run prompts individually (P01 first, then any order):"
        echo "    \"Run geospatial baseline for ${ENG_ID}\"  → P01 (required first)"
        echo "    \"Run POI collection for ${ENG_ID}\"       → P02, P03, P04"
        echo "    \"Run education profile for ${ENG_ID}\"    → P05"
        echo "    \"Run transit analysis for ${ENG_ID}\"     → P06"
        echo "    \"Run civic infrastructure for ${ENG_ID}\" → P07"
        echo "    \"Run demographics for ${ENG_ID}\"         → P08"
        echo "    \"Run business environment for ${ENG_ID}\" → P09"
        echo "    \"Run synthesis for ${ENG_ID}\"            → P10 (required last)"
        ;;
esac

echo ""
echo "  ⚠️  REMINDER: Review .claude/rules/fair-housing.md before any output review"
echo ""
