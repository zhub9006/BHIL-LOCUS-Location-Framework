---
id: LOCUS-COMPLIANCE
title: "LOCUS Compliance Framework"
version: 1.0.0
framework: LOCUS
author: BHIL
license: MIT
last_updated: 2026-04-01
---

# LOCUS Compliance Framework

## Overview

LOCUS operates at the intersection of location data, AI generation, and real estate advisory — a space with significant legal and ethical obligations. This document defines the compliance architecture, required disclosures, and attribution obligations that apply to every LOCUS engagement.

Compliance is **structural** in LOCUS, not cosmetic. The Fair Housing rules embedded in `.claude/rules/fair-housing.md` are enforced at the agent level before any content is written. Disclosures are required fields in the output templates, not optional additions.

---

## Fair Housing Act compliance

### Statutory foundation

The Fair Housing Act (42 U.S.C. §§ 3601–3619) prohibits discrimination in the sale, rental, financing, or provision of brokerage services for housing based on:
- Race
- Color
- Religion
- Sex
- National origin
- Disability (physical or mental)
- Familial status (having children under 18)

Many states and localities add additional protected classes: source of income, marital status, sexual orientation, gender identity, age, and others.

### Steering risk

**Steering** is the most significant FHA risk for location intelligence. Steering occurs when a real estate professional (or AI tool used by one) influences a client's housing choice based on protected characteristics — including by:
- Characterizing neighborhoods in racially coded language ("transitioning," "urban," "diverse")
- Showing different information to different clients based on their demographics
- Using school ratings or crime statistics in ways that function as race proxies
- Making recommendations rather than providing objective information

The 2019 Newsday investigation documented steering evidence in 24% of tested encounters. NFHA found agents using school quality as a proxy for racial composition. LOCUS's design avoids both patterns.

### HUD guidance and current regulatory landscape

HUD's May 2024 guidance stated that providers will be held accountable for discriminatory outcomes even from third-party algorithms. The 2025–2026 federal environment saw proposed elimination of disparate-impact regulations and DOJ rescission of disparate-impact provisions. This reduced, but did not eliminate, federal enforcement risk.

**LOCUS assumes full FHA compliance posture regardless of regulatory environment.** The underlying statute prohibits discrimination, state laws often provide stronger protections, and private civil rights litigation remains fully viable.

### LOCUS compliance architecture

Four structural mechanisms enforce Fair Housing compliance:

**1. Agent-level rules** (`.claude/rules/fair-housing.md`)
Path-scoped rules that apply to all agents in all engagements. Prohibit specific phrases, require objective framing, prevent qualitative characterization.

**2. Prohibited phrase validation script** (`tools/scripts/validate-fair-housing.sh`)
Automated scan of all output files for prohibited language before delivery.

**3. Human review requirement**
Every dossier requires human reviewer attestation before client delivery. The `engagement-metadata.md` human_review block is a delivery gate.

**4. Consistent data presentation**
LOCUS presents identical data to all users regardless of user demographics. Persona profiles adjust analytical weights, not data access.

### Required Fair Housing notice

Every `final-dossier.md` must include this exact text in the footer:

```
---
**Fair Housing Notice**

LOCUS dossiers present objective, publicly available data across all locations 
using consistent methodology. This framework is designed as an information tool, 
not a recommendation engine. Scores reflect measurable data patterns relative to 
comparable locations, not subjective quality judgments.

LOCUS does not discriminate or facilitate discrimination based on race, color, 
religion, sex, national origin, disability, familial status, or any other protected 
characteristic under applicable federal, state, or local law. The LOCUS Framework 
is provided for informational purposes only. Users are encouraged to evaluate 
locations independently and consult qualified real estate, legal, and financial 
professionals for advice specific to their circumstances.
```

---

## AI disclosure requirements

### Federal landscape

As of 2026, AI disclosure requirements are active at multiple levels:
- **California AB 723** (effective January 2026): Undisclosed AI-altered listing photos = misdemeanor
- **Colorado AI Act** (effective June 2026): Impact assessments required for AI in "consequential decisions"
- **NAR Code of Ethics**: Requires honest representation of all content including AI-generated material
- **FTC guidance**: AI-generated content that deceives consumers may constitute an unfair or deceptive practice

### Required AI disclosure block

Every LOCUS output file delivered to a client must include:

```
> **AI Assistance Disclosure**
> 
> This LOCUS dossier was prepared with AI assistance using Claude (Anthropic) 
> and the BHIL LOCUS Framework. Data was collected from publicly available sources 
> documented in the accompanying citations file. Collection dates are recorded for 
> each data point.
>
> AI-generated content reflects patterns in the collected data and does not 
> constitute independent verification. All information should be independently 
> verified before making housing, investment, or business decisions. This analysis 
> does not constitute real estate, legal, financial, or other professional advice.
>
> Human review was performed before delivery — see engagement metadata for reviewer 
> attestation.
```

### What requires disclosure

| Content type | Disclosure required? |
|-------------|---------------------|
| Data collected from third-party sources | Source attribution (not AI disclosure) |
| Scores calculated by scoring-agent | Yes — AI-calculated |
| "Day in the Life" narrative by narrative-agent | Yes — AI-generated |
| Dimension analysis summaries | Yes — AI-synthesized |
| Executive summary | Yes — AI-generated |

---

## Attribution obligations

### Walk Score®

Walk Score is a registered trademark of Redfin Corporation.

**Required on every use:**
1. First reference uses ® symbol: "Walk Score®"
2. Link to the address's Walk Score page: `https://www.walkscore.com/score/[address-slug]`
3. Attribution text: "Walk Score® provided by Redfin Real Estate"

**Prohibited:**
- Modifying or paraphrasing Walk Score® methodology claims
- Using Walk Score data without attribution
- Displaying Walk Score data without a link to the source page

### GreatSchools

**Required on every use:**
1. GreatSchools logo (linked to greatschools.org) when displaying ratings
2. Link to individual school profile pages
3. Attribution: "School data provided by GreatSchools, Inc."
4. Disclaimer note: "School ratings reflect academic performance data. See GreatSchools for complete information."

**License restrictions:**
- Numeric 1–10 ratings displayed publicly require an Enterprise Data License
- NearbySchools API (freemium) provides rating bands only ("above average," "average," "below average")
- LOCUS uses rating bands by default unless Enterprise license is held

### Census Bureau data

**Required:**
- No license required; free use
- Attribution: "Source: U.S. Census Bureau, [ACS 5-Year Survey / American Community Survey], [vintage year]"
- Do not imply Census Bureau endorsement of LOCUS findings

### FBI UCR / NIBRS

**Required:**
- Attribution: "Source: Federal Bureau of Investigation, Uniform Crime Reporting Program, [year]"
- Caveat: "UCR data relies on voluntary reporting by law enforcement agencies. Methodology and participation vary."

### EPA AirNow

**Required:**
- Attribution: "Source: U.S. Environmental Protection Agency, AirNow"
- No endorsement implied

### FEMA NFHL

**Required:**
- Attribution: "Source: FEMA National Flood Hazard Layer"
- Add standard disclaimer: "Flood zone determinations affect flood insurance requirements and may change. Consult FEMA FIRM maps and a licensed insurance agent for authoritative determination."

### OpenStreetMap

**Required:**
- Attribution: "© OpenStreetMap contributors"
- License: ODbL 1.0 — derived data must be published under the same license (or a compatible one)
- LOCUS engagements: include OSM attribution in citations.md

---

## Terms of service compliance

### Walk Score API

- Free tier: 5,000 calls/day
- API key required: register at walkscore.com/professional/api.php
- Attribution required (see above)
- Prohibited: reselling raw Walk Score data; using scores in automated valuation models without separate licensing

### Google Places API

- Free tier: 10,000 requests/month (Essentials), 5,000 (Pro)
- Pro tier required for: `rating`, `priceLevel`, `userRatingsTotal` fields
- Attribution: "Powered by Google"
- Prohibited: caching place data beyond Google's allowance; using for non-consumer navigation without Maps Platform agreement

### GreatSchools API

- NearbySchools API: $0.004/call, 14-day free trial (5,000 calls)
- Enterprise license: custom pricing — contact sales@greatschools.org
- Attribution required
- Prohibited: displaying 1–10 numeric ratings without Enterprise license

### Yelp Fusion / Places API

- No longer free — $7.99/1,000 calls after 30-day trial
- Attribution: "Powered by Yelp"
- Prohibited: displaying Yelp reviews outside of Yelp attribution context

---

## Engagement delivery checklist

Before delivering any LOCUS dossier to a client, the human reviewer confirms:

```
DELIVERY GATE — All items must be ✅ before release

[ ] AI Assistance Disclosure block present in final-dossier.md
[ ] Fair Housing Notice block present in final-dossier.md
[ ] No prohibited phrases found (validate-fair-housing.sh passed)
[ ] All factual claims have inline citations
[ ] Citations.md is complete (no empty rows with claims)
[ ] Data currency table shows no expired sources (or stale data is flagged)
[ ] Walk Score® attribution present with ® and Redfin credit
[ ] GreatSchools attribution present with school profile links
[ ] Racial/ethnic composition data absent from residential reports
[ ] Human reviewer attestation recorded in engagement-metadata.md
[ ] Dossier ID (LOCUS-DOS-NNN) assigned and recorded
```

The human reviewer signs off by updating `engagement-metadata.md`:

```yaml
human_review:
  reviewer: "[Full name]"
  reviewed_at: "[ISO timestamp]"
  fair_housing_confirmed: true
  prohibited_phrases_checked: true
  ai_disclosure_present: true
  attribution_verified: true
  citations_complete: true
  delivery_gate_passed: true
```

---

## Disclaimer templates

### Standard residential disclaimer

```
This LOCUS analysis is provided for informational purposes. It was prepared with 
AI assistance using publicly available data. Information should be independently 
verified before making housing decisions. This analysis does not constitute real 
estate, legal, financial, or other professional advice. School, crime, and 
environmental data reflect conditions at the time of collection and are subject 
to change. Consult qualified professionals for advice specific to your circumstances.
```

### Commercial/investment disclaimer

```
This LOCUS analysis is provided for informational purposes regarding commercial 
location characteristics. It was prepared with AI assistance using publicly 
available data. It does not constitute investment advice, a valuation opinion, 
or a market analysis under applicable appraisal standards. Investment decisions 
should be made in consultation with qualified real estate, legal, and financial 
advisors. Past performance of comparable locations does not predict future results.
```

### Enterprise/relocation disclaimer

```
This LOCUS analysis is prepared to support corporate relocation decision-making. 
Data was collected from publicly available sources and reflects conditions at 
collection. Individual employees' housing decisions should be made with 
independent research and consultation with local real estate professionals. 
LOCUS scores are analytical tools, not endorsements of specific locations. 
This analysis does not constitute employment, legal, or professional advice.
```

---

*LOCUS Compliance Framework — BHIL LOCUS Framework v1.0*
