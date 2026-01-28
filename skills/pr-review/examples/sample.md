# PR Review

## Summary

- Reviewed PR #123 for auth token refresh and session handling changes

## Findings

### High

- `src/auth/refresh.ts:84`: Missing validation of refresh token audience; an attacker could reuse a token across clients. Add client_id/azp check to match the current session.

### Medium

- `src/auth/refresh.ts:112`: Logs include full JWT on error path. Redact token content or log only token id.

### Low

- `src/auth/refresh.ts:44`: Retry loop lacks backoff; consider jitter to avoid thundering herd on refresh storm.

## Questions

- Is there a requirement to allow cross-device refresh tokens, or should refresh be scoped to a single client?

## Suggested Follow-ups

- Add a negative test for cross-client refresh token reuse.
