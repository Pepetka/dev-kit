## Security Audit Report
- Path: src/auth
- Files analyzed: 6

### Critical
- src/auth/session.ts:112 Session cookie missing HttpOnly and SameSite - Allows client-side access and CSRF risk - Set HttpOnly=true and SameSite=Lax/Strict

### High
- src/auth/login.ts:74 User input concatenated into SQL query - Injection risk - Use parameterized queries

### Medium
- src/auth/password.ts:39 bcrypt rounds set to 6 - Weak against brute force - Increase to 12+ based on perf

### Low / Recommendations
- Add rate limiting on login endpoint
- Log authentication failures with minimal PII

### Remediation Plan
1. Fix SQL injection and cookie flags immediately
2. Increase bcrypt rounds and add rate limiting
