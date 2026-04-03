---
template: prompt
id: P07
title: Civic Infrastructure & Safety
dimension: D7
version: "1.0"
depends_on: [P01]
outputs: [p07-civic-safety-output.md, citations.md]
estimated_time: "10–15 minutes"
web_search_queries: 6–8
fair_housing_sensitivity: HIGH
---

# P07 — Civic Infrastructure & Safety

**Dimension:** D7 · Civic Infrastructure & Safety
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

> ⚠️ **FAIR HOUSING — HIGH SENSITIVITY**
> Crime data must be presented as objective statistics only. No characterization of residents, populations, or groups. No language implying safety judgments about who lives in an area. See `.claude/rules/fair-housing.md`.

---

## Objective

Collect objective, data-sourced measurements of civic and environmental conditions: crime rates, flood risk, air quality, noise exposure, and 311 service quality. These inform D7 scoring.

---

## Pre-Flight

1. Confirm address, FIPS codes (state, county, tract) from P01
2. All data must cite primary government sources

---

## Data Collection Steps

### Step 1 — Crime Data via FBI Crime Data Explorer (Bash)

```bash
# FBI Crime Data Explorer API — city-level data
CITY_ENCODED="[CITY NAME URL-ENCODED]"
STATE_ABBR="[ST]"

curl -s "https://api.usa.gov/crime/fbi/cde/estimate/city/${CITY_ENCODED}/${STATE_ABBR}?from=2019&to=2022&API_KEY=iiHnOKfno2Mgkt5AynpvPpUQTEyxE77jo1RU8PIv" \
  -o /tmp/fbi_crime.json 2>&1

# If FBI CDE API unavailable, use WebSearch fallback:
echo "Fallback: search '[CITY STATE] crime rate per capita FBI UCR 2022 2023'"
```

**WebSearch fallback (preferred for most cities):**
```
Query A: [CITY STATE] crime rate per 1000 residents property crime violent crime 2022 2023
Query B: [CITY STATE] crime statistics annual report police department
```

**Collect:**
- Property crime rate (incidents per 1,000 residents)
- Violent crime rate (incidents per 1,000 residents)
- Comparison to national average (FBI UCR national rates: property ~19.6/1k, violent ~3.7/1k as of 2022)
- Year of data

**Critical Fair Housing requirement:**
- Report as: "Property crime rate: X per 1,000 residents (city average; source: FBI UCR)"
- Do NOT use language like "dangerous," "unsafe," "high-crime neighborhood"
- Do NOT imply any connection between crime rates and any population group

---

### Step 2 — Flood Zone via FEMA NFHL (Bash + WebSearch)

```bash
# FEMA Map Service Center API
LOCUS_LAT="[LAT]"
LOCUS_LON="[LON]"

curl -s "https://msc.fema.gov/arcgis/rest/services/NFHL/7/query?geometry=${LOCUS_LON},${LOCUS_LAT}&geometryType=esriGeometryPoint&spatialRel=esriSpatialRelIntersects&outFields=FLD_ZONE,ZONE_SUBTY,SFHA_TF&f=json" \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
features = data.get('features', [])
if features:
    attrs = features[0].get('attributes', {})
    zone = attrs.get('FLD_ZONE', 'Not determined')
    sfha = attrs.get('SFHA_TF', 'N')
    print(f'FEMA Flood Zone: {zone}')
    print(f'Special Flood Hazard Area (100-yr): {sfha}')
else:
    print('No FEMA data returned — try WebSearch fallback')
"
```

**WebSearch fallback:**
```
Query C: FEMA flood zone [STREET ADDRESS, CITY STATE] flood map
```
Or direct to: `https://msc.fema.gov/portal/search#searchresultsanchor`

**Flood zone classification:**
- Zone X (shaded/unshaded): minimal to moderate risk
- Zone AE / A: 1% annual chance flood (100-year)
- Zone VE / V: coastal high-hazard
- Zone AO / AH: shallow flooding areas

Citation: FEMA National Flood Hazard Layer / FEMA MSC.

---

### Step 3 — Air Quality via EPA AirNow (Bash)

```bash
LOCUS_LAT="[LAT]"
LOCUS_LON="[LON]"
EPA_KEY="[EPA_AIRNOW_API_KEY_IF_AVAILABLE]"

# Current AQI (illustrative — for annual average use WebSearch)
curl -s "https://www.airnowapi.org/aq/observation/latLong/current/?format=application/json&latitude=${LOCUS_LAT}&longitude=${LOCUS_LON}&distance=25&API_KEY=test" \
  -o /tmp/airnow.json 2>&1

echo "Note: AirNow API requires free key from airnowapi.org"
echo "Fallback: search annual AQI for [CITY STATE]"
```

**WebSearch fallback (preferred):**
```
Query D: [CITY STATE] annual air quality index AQI average EPA 2022 2023
Query E: [COUNTY] [STATE] air quality ozone particulate matter PM2.5
```

**Collect:** Annual median AQI and primary pollutant concern.

**AQI benchmarks:**
- 0–50: Good
- 51–100: Moderate
- 101–150: Unhealthy for sensitive groups
- 151+: Unhealthy

Citation: U.S. EPA AirNow.

---

### Step 4 — Noise Exposure (WebSearch)

```
Query F: [STREET ADDRESS, CITY STATE] noise exposure transportation noise map
```

Try: `https://maps.dot.gov/BTS/NationalTransportationNoiseMap/`

Record:
- Road traffic noise level (if available, in dBA)
- Proximity to flight paths / airport noise contours
- Rail/industrial noise if applicable

**Characterization tiers:**
- <50 dBA: Very quiet
- 50–60 dBA: Moderate (typical residential)
- 60–70 dBA: Elevated (busy street)
- >70 dBA: High noise exposure

---

### Step 5 — 311 Service Quality (WebSearch)

```
Query G: [CITY] 311 service response time open data infrastructure requests
```

Many cities publish 311 open data. Check if available.
If not available: mark as "data unavailable" — use city infrastructure investment as proxy.

Record:
- 311 system: present/absent
- Response time data: available/unavailable
- If available: median days to close infrastructure requests

---

### Step 6 — Emergency Services Proximity (WebSearch)

```
Query H: fire station police station near [STREET ADDRESS, CITY STATE]
```

Record:
- Nearest fire station: name, distance
- Nearest police/sheriff substation: distance
- Note only for reporting — do not use as safety characterization

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p07-civic-safety-output.md`

```markdown
---
prompt: P07
engagement_id: {{ENGAGEMENT_ID}}
dimension: D7
completed: [ISO_DATE]
fair_housing_reviewed: true
---

# P07 Output — Civic Infrastructure & Safety

> Fair Housing Notice: All statistics are objective, publicly available data.
> No characterization of residents, populations, or groups is made or implied.

## Crime Data (Objective Statistics)
- Property crime rate: [X] per 1,000 residents ([CITY] average, [YEAR])
- Violent crime rate: [X] per 1,000 residents ([CITY] average, [YEAR])
- National average reference: Property ~19.6/1k, Violent ~3.7/1k (FBI UCR 2022)
- Data source: [FBI UCR / City Police Dept / Other]

## Flood Risk
- FEMA Flood Zone: [ZONE]
- Special Flood Hazard Area: [Yes / No]
- Flood risk characterization: [Minimal / Moderate / High — per zone definition only]

## Air Quality
- Annual median AQI: [X] ([CITY / COUNTY], [YEAR])
- Primary pollutant: [POLLUTANT]
- AQI tier: [Good / Moderate / USG / Unhealthy]

## Noise Exposure
- Road traffic noise: [X dBA / unavailable]
- Airport noise contour: [Yes — Zone X / No]
- Noise tier: [Very quiet / Moderate / Elevated / High]

## 311 & Infrastructure Services
- 311 system: [Present / Absent]
- Response time data: [Available — X days median / Unavailable]

## Emergency Services
- Nearest fire station: [NAME] — [N] m
- Nearest police station: [NAME] — [N] m

## Scoring Inputs for D7
- Crime property input: [rate per 1k]
- Crime violent input: [rate per 1k]
- Flood zone input: [zone code]
- AQI input: [annual median]
- Noise input: [dBA or tier]
- 311 input: [score or unavailable]

## Data Quality Notes
[Year of crime data, city vs. neighborhood limitation, API fallbacks]

## Citations Added (P07)
[List new CIT-NNN entries — must include FBI UCR and FEMA attributions]
```

---

## Fair Housing Self-Check (Required)

- [ ] Crime data presented as rates/statistics only, no characterizations
- [ ] No language connecting crime data to any population or group
- [ ] No "dangerous," "unsafe," or similar qualitative crime language
- [ ] Flood, AQI, noise data presented as objective measurements
- [ ] All data sources cited

---

## Update engagement-metadata.md

Set `P07_civic_infrastructure: true`.

---

*P07 complete → proceed to P08 (Demographics & Trajectory)*
