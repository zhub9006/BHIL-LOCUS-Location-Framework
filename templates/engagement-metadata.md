---
# LOCUS Engagement Metadata
# Auto-populated by new-engagement.sh — edit with care.
# This file is the authoritative record for this engagement.

engagement:
  id: "{{ENGAGEMENT_ID}}"                  # e.g. ENG-2024-0042
  created: "{{ISO_DATE}}"                  # YYYY-MM-DD
  last_updated: "{{ISO_DATE}}"
  status: "in-progress"                    # in-progress | review | complete | archived
  sku_tier: "{{SKU_TIER}}"               # express | full | complete | enterprise

address:
  raw: "{{RAW_ADDRESS}}"
  street: "{{STREET}}"
  city: "{{CITY}}"
  state: "{{STATE}}"
  zip: "{{ZIP}}"
  lat: null
  lon: null
  fips_state: null
  fips_county: null
  fips_tract: null
  geocode_source: null                     # census-geocoder | google | manual
  geocode_confidence: null                 # high | medium | low

engagement_config:
  persona: "{{PERSONA}}"                  # family | young-professional | retiree | investor | remote-worker | custom
  persona_weights_override: {}            # empty unless custom persona
  comparison_addresses: []               # populated for Enterprise tier
  report_format: "markdown"              # markdown | pdf | both
  client_reference: "{{CLIENT_REF}}"    # internal client/matter reference

progress:
  # Prompts completed — update as each phase runs
  P00_master: false
  P01_walkability_geospatial: false
  P02_food_drink_social: false
  P03_recreation_green_space: false
  P04_daily_errands_retail: false
  P05_education_profiling: false
  P06_transportation_commute: false
  P07_civic_infrastructure: false
  P08_demographics_trajectory: false
  P09_business_environment: false
  P10_synthesis_dossier: false

  # File artifacts generated
  files_created: []

data_quality:
  # Populated by scoring-agent during P10 synthesis
  overall_confidence: null               # high | medium | low
  dimensions_with_missing_data: []
  staleness_flags: []
  web_search_queries_run: 0
  citations_collected: 0

scoring:
  # Populated by scoring-agent — do not manually edit
  composite_score: null
  composite_percentile: null
  dimension_scores: {}
  balance_alert: false
  balance_alert_detail: null

compliance:
  fair_housing_review: false
  fair_housing_reviewer: null
  ai_disclosure_included: false
  citations_verified: false
  delivery_checklist_complete: false

notes: ""
---

# Engagement: {{ENGAGEMENT_ID}}

**Address:** {{RAW_ADDRESS}}
**Persona:** {{PERSONA}}
**SKU Tier:** {{SKU_TIER}}
**Created:** {{ISO_DATE}}

## Progress Log

| Timestamp | Phase | Action | Operator |
|-----------|-------|--------|----------|
| {{ISO_DATE}} | Setup | Engagement initialized | new-engagement.sh |

## Data Notes

*Record any data anomalies, fallback sources used, or analyst observations here.*

---
*This file is auto-managed by LOCUS skills. Update `progress` and `data_quality` fields as phases complete.*
