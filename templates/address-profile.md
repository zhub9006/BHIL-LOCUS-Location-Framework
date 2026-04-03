---
template: address-profile
version: "1.0"
locus_version: "1.0"
---

# Address Profile — {{ENGAGEMENT_ID}}

> **Instructions:** Complete all fields before running any LOCUS prompts.
> Required fields are marked ✱. Leave optional fields blank if unknown.

---

## ✱ Subject Property

| Field | Value |
|-------|-------|
| Street Address | |
| City | |
| State | |
| ZIP Code | |
| Unit / Suite (if applicable) | |
| Property Type | ☐ Single-family ☐ Condo/Co-op ☐ Multi-family ☐ Commercial ☐ Mixed-use ☐ Land |
| Listing Status | ☐ Active ☐ Under Contract ☐ Off-market ☐ Other: |

---

## ✱ Engagement Parameters

| Field | Value |
|-------|-------|
| SKU Tier | ☐ Express ☐ Full ☐ Complete ☐ Enterprise |
| Primary Persona | ☐ Family ☐ Young Professional ☐ Retiree ☐ Investor ☐ Remote Worker ☐ Custom |
| Client / Matter Reference | |
| Requested Delivery Date | |
| Analyst Assigned | |

### Custom Persona Weights (if applicable)
*Complete only if "Custom" selected above. Weights must sum to 100.*

| Dimension | Weight (%) |
|-----------|-----------|
| D1 Walkability & Geospatial | |
| D2 Food, Drink & Social | |
| D3 Recreation & Green Space | |
| D4 Daily Errands & Retail | |
| D5 Education | |
| D6 Transportation & Commute | |
| D7 Civic Infrastructure & Safety | |
| D8 Neighborhood Trajectory | |
| D9 Business Environment | |
| **TOTAL** | **100%** |

---

## Enterprise Tier — Comparison Addresses
*Complete only for Enterprise SKU. Add rows as needed.*

| # | Address | Purpose (baseline / competitor / portfolio) |
|---|---------|---------------------------------------------|
| 1 | | |
| 2 | | |
| 3 | | |
| 4 | | |

---

## Contextual Notes

### Known Property Characteristics
*List anything the analyst should keep in mind — HOA, historic designation, flood zone disclosure, ongoing construction nearby, etc.*

```
[Enter notes here]
```

### Client-Provided Priorities
*Has the client indicated specific concerns or dimensions they care most about?*

```
[Enter notes here]
```

### Data Access Notes
*Any known data gaps, restricted MLS data, or specific sources to prioritize or avoid?*

```
[Enter notes here]
```

---

## Pre-Flight Checklist

Before running LOCUS prompts, confirm:

- [ ] Address verified against USPS or Census Geocoder
- [ ] SKU tier confirmed with client
- [ ] Persona confirmed or custom weights validated (sum = 100%)
- [ ] Engagement ID assigned and logged in `ID-REGISTRY.md`
- [ ] Engagement directory created: `engagements/{{ENGAGEMENT_ID}}/`
- [ ] `engagement-metadata.md` populated and saved
- [ ] `citations.md` initialized
- [ ] Comparison addresses entered (Enterprise only)

---

*LOCUS Framework · BHIL · Human-Directed. AI-Enabled. Commercially Tested.*
*Template version 1.0 — see `integration/compliance.md` for Fair Housing requirements before delivery.*
