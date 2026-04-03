---
dimension: D5
title: Education Sources
---

# D5 Data Sources — Education

## Primary Sources

### GreatSchools
- **URL:** greatschools.org
- **Free:** Yes (WebFetch individual school pages)
- **API:** Deprecated public API; use WebFetch
- **Returns:** Overall rating (1–10), test score, student progress
- **Attribution required:** "School data © GreatSchools.org"
- **Validity:** 18 months (check rating year on page)

**URL pattern:**
```
https://www.greatschools.org/{state}/{city}/{school-id}-{school-name}/
```

Search: `site:greatschools.org "[SCHOOL NAME]" "[CITY]"`

### NCES Common Core of Data
- **URL:** nces.ed.gov/ccd/
- **Free:** Yes
- **Returns:** School type, enrollment, grade levels, district info
- **Validity:** 3 years (school year lag ~18 months)

### State Department of Education
- Each state publishes report cards
- WebSearch: "[STATE] department of education school report card [SCHOOL NAME]"

## Fair Housing Compliance

**Never collect or record from GreatSchools:**
- Racial/ethnic composition percentages
- Low-income student percentages (use only for data completeness check)
- Any demographic breakdown

**Collect only:**
- Overall rating number
- Test score rating number  
- Student progress rating number
- School name, type, grade levels, enrollment

## Secondary Sources

### Niche.com
- WebSearch for school rankings as secondary validation
- Do NOT use Niche neighborhood grades (demographic characterization risk)

### SchoolDigger
- Secondary validation for school ratings

