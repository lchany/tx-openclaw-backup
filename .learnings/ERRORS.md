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
## [ERR-20260310-002] openclaw_office_temp_process_killed

**Logged**: 2026-03-10T10:06:50+08:00
**Priority**: high
**Status**: pending
**Area**: infra

### Summary
OpenClaw Office temporary process on port 5180 was terminated, causing the browser to show `fail to fetch`.

### Error
```
Exec failed (mellow-falcon, signal SIGTERM)
```

### Context
- Office frontend was started via a background exec session with a 120s timeout.
- After timeout, the session was killed and port 5180 stopped listening.
- Gateway on 18789 remained healthy.

### Suggested Fix
Run OpenClaw Office as a persistent service (systemd user unit or equivalent) instead of a timeout-bound temporary exec session.

### Metadata
- Reproducible: yes
- Related Files: .learnings/ERRORS.md
- See Also: ERR-20260310-001

---
