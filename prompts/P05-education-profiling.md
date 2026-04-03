---
template: prompt
id: P05
title: Education Profiling
dimension: D5
version: "1.0"
depends_on: [P01]
outputs: [p05-education-output.md, citations.md]
estimated_time: "8–12 minutes"
web_search_queries: 5–8
fair_housing_sensitivity: HIGH
---

# P05 — Education Profiling

**Dimension:** D5 · Education
**Engagement:** Load from `engagements/{{ENGAGEMENT_ID}}/engagement-metadata.md`

> ⚠️ **FAIR HOUSING — HIGH SENSITIVITY**
> School data must be presented as objective ratings only. Do NOT characterize neighborhoods, demographics, or populations based on school data. See `.claude/rules/fair-housing.md` — Section: School Ratings.

---

## Objective

Identify and score assigned public schools plus private/charter options and higher education access. School data is the highest-weight sub-metric for the **Family** persona (28%) and irrelevant for **Investor** (0% — skip this prompt for Investor SKU Full tier).

---

## Pre-Flight

1. Confirm address from engagement-metadata.md
2. Check persona — if Investor: skip this prompt, set `P05_education_profiling: skipped`
3. Confirm state + zip code for school district lookup

---

## Data Collection Steps

### Step 1 — School District Identification (WebSearch)

```
Query A: "[STREET ADDRESS, CITY STATE ZIP]" school district assigned schools
Query B: [CITY STATE] school district attendance zone [STREET ADDRESS]
```

Identify:
- School district name
- Assigned elementary school
- Assigned middle school
- Assigned high school

If attendance zone tool available via district website, use WebFetch to confirm.

---

### Step 2 — GreatSchools Ratings (WebSearch + WebFetch)

```
Query C: [ELEMENTARY SCHOOL NAME] [CITY STATE] site:greatschools.org
Query D: [MIDDLE SCHOOL NAME] [CITY STATE] site:greatschools.org
Query E: [HIGH SCHOOL NAME] [CITY STATE] site:greatschools.org
```

For each school, attempt WebFetch of GreatSchools URL.
Extract:
- Overall GreatSchools rating (1–10)
- Test score rating (1–10) if shown separately
- Student progress rating (1–10) if shown

**Fair Housing handling:**
- Record ratings as numbers only
- Do NOT record or reference demographic breakdowns shown on GreatSchools pages
- Do NOT note racial/ethnic composition
- Do NOT characterize what the ratings mean about the neighborhood

Citation: "School data © GreatSchools.org" — required attribution per compliance.md.

---

### Step 3 — NCES School Profile (Bash)

Cross-reference via NCES for enrollment size (helps contextualize rural/urban):

```bash
# NCES Common Core of Data search — use WebSearch as primary fallback
SCHOOL_NAME="[SCHOOL NAME URL-ENCODED]"
CITY="[CITY]"
STATE_ABBR="[ST]"

curl -s "https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&SchoolName=${SCHOOL_NAME}&State=${STATE_ABBR}&Zip=&Miles=&City=${CITY}&County=&SchoolType=1&SpecificSchlTypes=all&IncGrade=-1&LoGrade=-1&HiGrade=-1" \
  -o /tmp/nces_result.html 2>&1 && echo "NCES fetched" || echo "NCES unavailable — use WebSearch fallback"
```

Fallback: WebSearch `"[SCHOOL NAME]" NCES enrollment [CITY STATE]`

---

### Step 4 — Private & Charter Schools (WebSearch)

```
Query F: private schools charter schools near [STREET ADDRESS, CITY STATE]
```

Collect: Name, type (private/charter/magnet), distance, grade levels served.
Do NOT rate or rank private schools relative to public — just catalog presence.

---

### Step 5 — Higher Education (WebSearch)

```
Query G: colleges universities community college near [STREET ADDRESS, CITY STATE]
```

Collect: Institution name, type, distance.
Relevant for: Remote Worker (coworking/intellectual community), Young Professional (networking/continuing ed).
Less relevant for: Family (unless college proximity is a lifestyle factor).

---

## Output Format

Write to: `engagements/{{ENGAGEMENT_ID}}/p05-education-output.md`

```markdown
---
prompt: P05
engagement_id: {{ENGAGEMENT_ID}}
dimension: D5
completed: [ISO_DATE]
fair_housing_reviewed: true
---

# P05 Output — Education

> Fair Housing Notice: School ratings are objective publicly available scores.
> This section does not characterize neighborhood demographics or populations.

## Assigned Public Schools

| Level | School Name | District | GS Rating | Enrollment | Distance |
|-------|------------|---------|----------|-----------|---------|
| Elementary | | | /10 | | m |
| Middle | | | /10 | | m |
| High School | | | /10 | | m |

## School Data Notes
[Record any ratings methodology notes, schools not found on GreatSchools, older data, etc.]

## Private & Charter Options
[TABLE: Name | Type | Grades | Distance]

## Higher Education
[TABLE: Institution | Type | Distance]

## Scoring Inputs for D5
- Elementary quality input: [GS rating] / 10
- Middle quality input: [GS rating] / 10
- High school quality input: [GS rating] / 10
- Private/charter access input: [count within 3km]
- Higher ed input: [nearest distance]

## Data Quality Notes
[Missing ratings, outdated data, pending verification]

## Citations Added (P05)
[List new CIT-NNN entries — must include GreatSchools attribution]
```

---

## Fair Housing Self-Check (Required)

Before saving output, confirm:
- [ ] No neighborhood characterization based on school data
- [ ] No demographic data recorded from GreatSchools pages
- [ ] Ratings presented as numbers, not characterizations
- [ ] GreatSchools attribution included in citations

---

## Update engagement-metadata.md

Set `P05_education_profiling: true` (or `skipped` for Investor).

---

*P05 complete → proceed to P06 (Transportation & Commute)*
