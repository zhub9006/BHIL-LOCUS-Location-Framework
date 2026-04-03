# Contributing to BHIL LOCUS Framework

Thank you for your interest in improving the LOCUS Framework. This document covers
how to contribute prompts, scoring refinements, data source mappings, and workflow
improvements.

---

## Ground Rules

1. **Fair housing first.** Any contribution touching scoring, persona weighting, or
   data source selection must be reviewed against `integration/compliance.md` before
   submission. PRs that introduce protected-class proxies will not be merged.

2. **Cite everything.** LOCUS is a citation-first framework. New prompts or data
   source docs must include verifiable public-domain or API-accessible sources.
   Unattributed scoring claims will be rejected.

3. **One concern per PR.** Keep changes focused. A PR that refines `P03` recreational
   scoring should not also restructure the citations template.

---

## Types of Contributions

### Prompt Improvements (prompts/)
- Tighten JSON schema contracts in existing prompts
- Add or remove POI categories based on data availability
- Improve scoring calibration language in rubric sections

### Scoring Refinements (scoring/)
- Recalibrate z-score anchors in `scoring-methodology.md`
- Add or adjust persona weight matrices in `persona-profiles.md`
- Extend the trajectory signal inventory in `trajectory-methodology.md`

### Data Source Updates (data-sources/)
- Flag deprecated APIs or changed endpoints
- Add new free-tier or government data sources
- Update access tier classifications (Free / Freemium / Commercial)

### Workflow Additions (workflows/)
- Propose new SKU tiers with defined time budgets
- Improve step sequencing in existing workflow docs

### Scripts (tools/scripts/)
- Bug fixes or portability improvements to shell scripts
- New utility scripts that aid engagement setup or validation

---

## Pull Request Process

1. Fork the repository and create a branch: `feature/your-description`
2. Make your changes with clear commit messages
3. Run local validation: `bash tools/scripts/validate-templates.sh`
4. Open a PR using the provided template (`.github/PULL_REQUEST_TEMPLATE.md`)
5. A BHIL maintainer will review within 5 business days

---

## Commit Message Format

```
type(scope): short description

Types: fix | feat | docs | scoring | data | chore
Scope: prompts | scoring | templates | workflows | data-sources | scripts | ci

Examples:
  feat(prompts): add P11 short-term-rental analysis module
  fix(scoring): correct z-score anchor for walkability tier 3
  data(sources): update GreatSchools API v3 endpoint in d5
```

---

## Code of Conduct

All contributors are expected to engage professionally. Discriminatory language,
protected-class stereotyping in scoring logic, or bad-faith submissions will result
in immediate removal of contribution access.

---

*BHIL LOCUS Framework — Human-Directed. AI-Enabled. Commercially Tested.*
