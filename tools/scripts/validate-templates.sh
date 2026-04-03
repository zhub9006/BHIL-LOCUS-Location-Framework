#!/usr/bin/env bash
# LOCUS Framework — Template Validation Script
# Usage: bash tools/scripts/validate-templates.sh [ENGAGEMENT_ID]
# If no ID given, validates all engagements.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ENGAGEMENTS_DIR="${REPO_ROOT}/engagements"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0
PASSES=0

log_pass()    { echo -e "  ${GREEN}✅ PASS${NC}: $1"; PASSES=$((PASSES+1)); }
log_warn()    { echo -e "  ${YELLOW}⚠️  WARN${NC}: $1"; WARNINGS=$((WARNINGS+1)); }
log_fail()    { echo -e "  ${RED}❌ FAIL${NC}: $1"; ERRORS=$((ERRORS+1)); }
log_section() { echo -e "\n${BLUE}=== $1 ===${NC}"; }

# -----------------------------------------------------------
# Validate a single engagement directory
# -----------------------------------------------------------
validate_engagement() {
  local eng_dir="$1"
  local eng_id
  eng_id=$(basename "${eng_dir}")

  log_section "Validating: ${eng_id}"

  # --- Required files ---
  local required_files=(
    "engagement-metadata.md"
    "citations.md"
  )
  for f in "${required_files[@]}"; do
    if [[ -f "${eng_dir}/${f}" ]]; then
      log_pass "${f} exists"
    else
      log_fail "${f} MISSING"
    fi
  done

  # --- final-dossier.md checks ---
  local dossier="${eng_dir}/final-dossier.md"
  if [[ -f "${dossier}" ]]; then
    log_pass "final-dossier.md exists"

    # Required blocks
    local required_blocks=(
      "Fair Housing"
      "AI Disclosure"
      "FILE_COMPLETE"
      "Walk Score"
    )
    for block in "${required_blocks[@]}"; do
      if grep -q "${block}" "${dossier}" 2>/dev/null; then
        log_pass "Required block present: '${block}'"
      else
        log_fail "Required block MISSING: '${block}'"
      fi
    done

    # Prohibited terms
    local prohibited_terms=(
      "neighborhood character"
      "type of people"
      "racial composition"
      "gentrifying"
      "transitioning neighborhood"
      "good neighborhood"
      "bad neighborhood"
      "dangerous neighborhood"
      "safe neighborhood"
    )
    for term in "${prohibited_terms[@]}"; do
      if grep -qi "${term}" "${dossier}" 2>/dev/null; then
        log_fail "PROHIBITED TERM found: '${term}'"
      fi
    done

    # Minimum length
    local word_count
    word_count=$(wc -w < "${dossier}")
    if [[ "${word_count}" -ge 2000 ]]; then
      log_pass "Word count: ${word_count} (≥2000)"
    else
      log_warn "Word count: ${word_count} (target: ≥2000 for Full tier)"
    fi
  else
    log_warn "final-dossier.md not yet generated (engagement may be in-progress)"
  fi

  # --- scorecard.md checks ---
  local scorecard="${eng_dir}/scorecard.md"
  if [[ -f "${scorecard}" ]]; then
    log_pass "scorecard.md exists"
    if grep -q "COMPOSITE LOCUS SCORE" "${scorecard}"; then
      log_pass "Composite score line present"
    else
      log_fail "COMPOSITE LOCUS SCORE line missing from scorecard"
    fi
  else
    log_warn "scorecard.md not yet generated"
  fi

  # --- citations.md checks ---
  local citations="${eng_dir}/citations.md"
  if [[ -f "${citations}" ]]; then
    local cit_count
    cit_count=$(grep -c "CIT-" "${citations}" 2>/dev/null || echo "0")
    if [[ "${cit_count}" -ge 5 ]]; then
      log_pass "Citations: ${cit_count} entries"
    elif [[ "${cit_count}" -ge 1 ]]; then
      log_warn "Citations: ${cit_count} (target: ≥10 for Full, ≥15 for Complete)"
    else
      log_fail "Citations: none found (minimum required: 5)"
    fi
  fi

  # --- engagement-metadata.md status ---
  local metadata="${eng_dir}/engagement-metadata.md"
  if [[ -f "${metadata}" ]]; then
    local status
    status=$(grep "^  status:" "${metadata}" | head -1 | awk '{print $2}' | tr -d '"')
    echo -e "  ${BLUE}ℹ️  Status${NC}: ${status:-unknown}"

    if grep -q "fair_housing_review: true" "${metadata}"; then
      log_pass "Fair Housing review marked complete"
    else
      log_warn "Fair Housing review not marked complete"
    fi
  fi
}

# -----------------------------------------------------------
# Main
# -----------------------------------------------------------
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║    LOCUS Template Validator · BHIL                  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Determine scope
if [[ $# -eq 1 ]]; then
  # Single engagement
  TARGET="${ENGAGEMENTS_DIR}/$1"
  if [[ -d "${TARGET}" ]]; then
    validate_engagement "${TARGET}"
  else
    echo -e "${RED}Engagement directory not found: ${TARGET}${NC}"
    exit 1
  fi
else
  # All engagements
  found=0
  for eng_dir in "${ENGAGEMENTS_DIR}"/ENG-*/; do
    if [[ -d "${eng_dir}" ]]; then
      validate_engagement "${eng_dir}"
      found=$((found+1))
    fi
  done
  if [[ "${found}" -eq 0 ]]; then
    echo "No engagement directories found in ${ENGAGEMENTS_DIR}"
    exit 0
  fi
fi

# Summary
echo ""
echo -e "${BLUE}=== Validation Summary ===${NC}"
echo -e "  ${GREEN}✅ Passes:${NC}   ${PASSES}"
echo -e "  ${YELLOW}⚠️  Warnings:${NC} ${WARNINGS}"
echo -e "  ${RED}❌ Failures:${NC} ${ERRORS}"

if [[ "${ERRORS}" -gt 0 ]]; then
  echo -e "\n${RED}❌ Validation FAILED — resolve errors before delivery${NC}"
  exit 1
elif [[ "${WARNINGS}" -gt 0 ]]; then
  echo -e "\n${YELLOW}⚠️  Validation passed with warnings — review before delivery${NC}"
  exit 0
else
  echo -e "\n${GREEN}✅ Validation passed — engagement ready for delivery${NC}"
  exit 0
fi
