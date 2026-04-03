---
template: prompt
id: P06
title: Transportation & Commute Analysis
dimension: D6
version: "1.0"
depends_on: [P01]
outputs: [p06-transportation-output.md, citations.md]
estimated_time: "8–10 minutes"
web_search_queries: 4–6
---

# P06 — Transportation & Commute

**Dimension:** D6 · Transportation & Commute
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

---

## Objective

Profile the full transportation stack accessible from the subject address: public transit (routes, frequency, coverage), commute time to the central business district, highway access, parking conditions, airport access, and bike infrastructure.

---

## Pre-Flight

1. Confirm lat/lon and city from P01
2. Transit Score® from P01 is the primary D6 input — confirm it was collected
3. Identify the city's primary transit agency for GTFS lookup

---

## Data Collection Steps

### Step 1 — Transit Agency & Route Identification (WebSearch)

```
Query A: "[CITY STATE]" public transit bus routes near [STREET ADDRESS]
Query B: [CITY] transit agency "[NEIGHBORHOOD]" bus routes schedule
```

Identify:
- Transit agency name (e.g., King County Metro, MARTA, CTA)
- Bus routes with stops within 400m — list route numbers
- Any rail/rapid transit within 800m (subway, light rail, commuter rail) — line name + station name
- Ferry access if applicable (Seattle, NYC, San Francisco)

---

### Step 2 — Transit Frequency & Hours (WebSearch/WebFetch)

For top 2 bus routes found in Step 1:
```
Query C: [TRANSIT AGENCY] route [ROUTE NUMBER] schedule frequency
```

Attempt WebFetch on transit agency schedule page.
Record:
- Peak frequency (minutes between buses)
- Off-peak frequency
- First/last service time (approx)
- Weekend service: yes/no

**Frequency scoring benchmark:**
- ≤10 min peak: excellent
- 11–20 min: good
- 21–30 min: adequate
- >30 min or on-demand only: limited

---

### Step 3 — CBD Commute Time (WebSearch)

```
Query D: commute time [STREET ADDRESS, CITY STATE] to [CITY] downtown by transit
Query E: drive time [STREET ADDRESS] to downtown [CITY] rush hour
```

Record:
- Transit commute time to CBD (minutes, peak)
- Drive commute time to CBD (minutes, peak)
- Note if remote-work context makes CBD commute less relevant

**CBD commute benchmarks:**
- <15 min: excellent
- 15–25 min: strong
- 26–40 min: solid
- 41–60 min: long
- >60 min: challenging

---

### Step 4 — Highway Access (WebSearch)

```
Query F: highway freeway access near [STREET ADDRESS, CITY STATE]
```

Record:
- Nearest interstate/freeway: name + distance
- On-ramp within 1.5 miles: yes/no

---

### Step 5 — Parking Context (WebSearch)

```
Query G: parking near [STREET ADDRESS, CITY STATE] street parking garage
```

Characterize:
- Street parking availability (abundant / limited / restricted)
- Nearest public garage: name, distance, approx daily rate
- Subject property parking type if determinable (off-street / on-street / none)

---

### Step 6 — Airport Access (WebSearch)

```
Query H: airport drive time [CITY STATE] nearest airport
```

Record:
- Nearest commercial airport: name, distance
- Transit option to airport: yes/no + route
- Drive time to airport (non-peak)

Benchmarks:
- <20 min: excellent
- 20–35 min: strong
- 35–50 min: solid
- >50 min: limited

---

### Step 7 — Bike Infrastructure Quality (from P01 + supplement)

Bike Score® was collected in P01. Supplement with:
```
Query I: bike lanes protected bike path near [STREET ADDRESS, CITY STATE]
```

Characterize: Protected lanes vs. painted lanes vs. no infrastructure within 800m.

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p06-transportation-output.md`

```markdown
---
prompt: P06
engagement_id: {{ENGAGEMENT_ID}}
dimension: D6
completed: [ISO_DATE]
---

# P06 Output — Transportation & Commute

## Transit Access
- Transit Score® (from P01): [X] / 100
- Transit agency: [NAME]
- Bus routes within 400m: [ROUTE NUMBERS]
- Rail/rapid transit within 800m: ☐ Yes — [LINE + STATION] ☐ No
- Peak frequency (best route): [N] min
- Off-peak frequency: [N] min
- Weekend service: ☐ Yes ☐ No

## Commute Profile
- Transit commute to CBD: [N] min (peak)
- Drive commute to CBD: [N] min (peak)
- Nearest highway on-ramp: [NAME] — [N] miles

## Parking
- Street parking: [abundant / limited / restricted]
- Public garage within 800m: ☐ Yes — [NAME, ~$X/day] ☐ No

## Airport Access
- Nearest airport: [NAME] — [N] miles
- Transit to airport: ☐ Yes — [ROUTE] ☐ No
- Drive time (non-peak): [N] min

## Bike Infrastructure
- Bike Score® (from P01): [X] / 100
- Protected bike lanes within 800m: ☐ Yes ☐ No
- Bike infrastructure characterization: [protected / painted / minimal]

## Scoring Inputs for D6
- Transit access input: [Transit Score + route count + frequency]
- Commute time input: [transit CBD time in minutes]
- Highway access input: [on-ramp distance in miles]
- Parking input: [characterization]
- Airport input: [drive time in minutes]
- Bike infrastructure input: [Bike Score + characterization]

## Data Quality Notes
[GTFS unavailable, frequency estimated, etc.]

## Citations Added (P06)
[List new CIT-NNN entries]
```

---

## Update engagement-metadata.md

Set `P06_transportation_commute: true`.

---

## Common Issues

| Issue | Resolution |
|-------|-----------|
| Transit agency website down | Use Google Maps transit directions as fallback |
| Small city — no transit | Score transit sub-metrics at floor; note car-dependent |
| Multiple airports equidistant | Record both; score on nearest with commercial service |
| Bike Score not available from P01 | Run Walk Score WebFetch with bike endpoint |

---

*P06 complete → proceed to P07 (Civic Infrastructure & Safety)*
