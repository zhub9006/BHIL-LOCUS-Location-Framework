#!/usr/bin/env bash
# LOCUS Framework — Citation Currency Checker
# Usage: bash tools/scripts/check-citations.sh [ENGAGEMENT_ID]
# Reads citations.md and flags stale or missing-date entries.

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

TODAY=$(date +%Y-%m-%d)
TODAY_EPOCH=$(date -d "${TODAY}" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "${TODAY}" +%s)

STALE=0
WARNINGS=0
CURRENT=0
UNKNOWN=0

# -----------------------------------------------------------
# Validity windows in days (from data-currency.md)
# -----------------------------------------------------------
declare -A VALIDITY_DAYS=(
  ["walk-score"]=365
  ["walkscore"]=365
  ["transit-score"]=365
  ["acs"]=1095
  ["census-acs"]=1095
  ["census"]=1095
  ["fbi-ucr"]=730
  ["fbi"]=730
  ["crime-data"]=730
  ["fema"]=1825
  ["flood"]=1825
  ["epa-airnow"]=730
  ["epa"]=730
  ["airnow"]=730
  ["greatschools"]=548
  ["nces"]=1095
  ["zillow"]=180
  ["redfin"]=180
  ["yelp"]=180
  ["google-places"]=90
  ["google"]=90
  ["overpass"]=180
  ["openstreetmap"]=180
  ["osm"]=180
  ["alltrails"]=365
  ["tpl"]=730
  ["parkserve"]=730
  ["gtfs"]=90
  ["transit-agency"]=90
  ["bps"]=548
  ["building-permits"]=548
  ["bds"]=730
)

DEFAULT_VALIDITY_DAYS=365

# -----------------------------------------------------------
# Get validity window for a source name
# -----------------------------------------------------------
get_validity() {
  local source_lower
  source_lower=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  
  for key in "${!VALIDITY_DAYS[@]}"; do
    if [[ "${source_lower}" == *"${key}"* ]]; then
      echo "${VALIDITY_DAYS[$key]}"
      return
    fi
  done
  echo "${DEFAULT_VALIDITY_DAYS}"
}

# -----------------------------------------------------------
# Days between two ISO dates
# -----------------------------------------------------------
days_since() {
  local access_date="$1"
  local access_epoch
  access_epoch=$(date -d "${access_date}" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "${access_date}" +%s 2>/dev/null || echo "0")
  
  if [[ "${access_epoch}" -eq 0 ]]; then
    echo "-1"
    return
  fi
  
  echo $(( (TODAY_EPOCH - access_epoch) / 86400 ))
}

# -----------------------------------------------------------
# Check citations.md for one engagement
# -----------------------------------------------------------
check_citations() {
  local eng_dir="$1"
  local eng_id
  eng_id=$(basename "${eng_dir}")
  local citations_file="${eng_dir}/citations.md"

  echo -e "\n${BLUE}=== Citation Currency Report: ${eng_id} ===${NC}"
  echo "Run date: ${TODAY}"
  echo ""

  if [[ ! -f "${citations_file}" ]]; then
    echo -e "${RED}citations.md not found${NC}"
    return
  fi

  # Parse table rows — look for lines with | CIT- pattern
  local total_cits=0
  local stale_list=()
  local warn_list=()

  while IFS= read -r line; do
    # Match table rows containing CIT-NNN
    if [[ "${line}" =~ \|[[:space:]]*(CIT-[0-9]+)[[:space:]]*\| ]]; then
      local cit_id="${BASH_REMATCH[1]}"
      total_cits=$((total_cits+1))

      # Try to extract access date (YYYY-MM-DD pattern)
      local access_date=""
      if [[ "${line}" =~ ([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
        access_date="${BASH_REMATCH[1]}"
      fi

      # Try to extract source name (2nd column after CIT-ID)
      local source_name=""
      source_name=$(echo "${line}" | awk -F'|' '{print $3}' | tr -d ' ')

      if [[ -z "${access_date}" ]]; then
        echo -e "  ${YELLOW}⬜ UNKNOWN${NC}: ${cit_id} (${source_name:-unknown source}) — no access date"
        UNKNOWN=$((UNKNOWN+1))
        continue
      fi

      local age
      age=$(days_since "${access_date}")
      
      if [[ "${age}" -eq -1 ]]; then
        echo -e "  ${YELLOW}⬜ UNKNOWN${NC}: ${cit_id} — unparseable date: ${access_date}"
        UNKNOWN=$((UNKNOWN+1))
        continue
      fi

      local validity
      validity=$(get_validity "${source_name}")
      local warn_threshold=$(( validity * 75 / 100 ))

      if [[ "${age}" -gt "${validity}" ]]; then
        echo -e "  ${RED}🔴 STALE${NC}: ${cit_id} (${source_name}) — ${age} days old, window ${validity} days"
        STALE=$((STALE+1))
        stale_list+=("${cit_id}")
      elif [[ "${age}" -gt "${warn_threshold}" ]]; then
        echo -e "  ${YELLOW}🟡 WARN${NC}: ${cit_id} (${source_name}) — ${age} days old, approaching ${validity}-day limit"
        WARNINGS=$((WARNINGS+1))
        warn_list+=("${cit_id}")
      else
        CURRENT=$((CURRENT+1))
      fi
    fi
  done < "${citations_file}"

  echo ""
  echo "─────────────────────────────────────────"
  echo -e "  Total citations:   ${total_cits}"
  echo -e "  ${GREEN}🟢 Current:${NC}        ${CURRENT}"
  echo -e "  ${YELLOW}🟡 Warnings:${NC}       ${WARNINGS}"
  echo -e "  ${RED}🔴 Stale:${NC}          ${STALE}"
  echo -e "  ${YELLOW}⬜ Unknown date:${NC}   ${UNKNOWN}"

  if [[ ${#stale_list[@]} -gt 0 ]]; then
    echo ""
    echo -e "${RED}Stale citations requiring refresh:${NC}"
    for c in "${stale_list[@]}"; do
      echo "  - ${c}"
    done
  fi
}

# -----------------------------------------------------------
# Main
# -----------------------------------------------------------
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║    LOCUS Citation Currency Checker · BHIL           ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [[ $# -eq 1 ]]; then
  TARGET="${ENGAGEMENTS_DIR}/$1"
  if [[ -d "${TARGET}" ]]; then
    check_citations "${TARGET}"
  else
    echo -e "${RED}Engagement not found: $1${NC}"
    exit 1
  fi
else
  found=0
  for eng_dir in "${ENGAGEMENTS_DIR}"/ENG-*/; do
    if [[ -d "${eng_dir}" ]]; then
      check_citations "${eng_dir}"
      found=$((found+1))
    fi
  done
  if [[ "${found}" -eq 0 ]]; then
    echo "No engagements found."
  fi
fi

echo ""
echo -e "${BLUE}=== Overall Summary ===${NC}"
echo -e "  ${GREEN}🟢 Current:${NC}    ${CURRENT}"
echo -e "  ${YELLOW}🟡 Warnings:${NC}   ${WARNINGS}"
echo -e "  ${RED}🔴 Stale:${NC}      ${STALE}"

if [[ "${STALE}" -gt 0 ]]; then
  echo -e "\n${RED}❌ Stale data found — refresh before delivery${NC}"
  exit 1
fi
exit 0
