## [ERR-20260310-001] web_search_brave_rate_limit

**Logged**: 2026-03-10T09:36:00+08:00
**Priority**: medium
**Status**: pending
**Area**: docs

### Summary
Brave web_search hit rate limit while researching OpenClaw Office.

### Error
```
Brave Search API error (429): Request rate limit exceeded for plan
```

### Context
- Operation: web research for OpenClaw Office official introduction and docs
- Tool: web_search
- Fallback used: web_fetch on official site, docs, and GitHub repo

### Suggested Fix
When Brave rate-limits, fall back immediately to web_fetch or local docs instead of retrying search.

### Metadata
- Reproducible: yes
- Related Files: .learnings/ERRORS.md

---
