## Code Review - Current Changes

### Files Reviewed
- src/api/user.ts (+42, -8)
- src/components/Profile.tsx (+18, -5)

### Focus Areas
- Error handling in API calls
- React rendering efficiency

### Findings
**High**:
- src/api/user.ts:88 Missing error handling for fetch failures - Unhandled rejections can crash the request path - Wrap in try/catch and return a typed error

**Medium**:
- src/components/Profile.tsx:41 Derived state recalculated on every render - Causes extra renders for large lists - Memoize with useMemo

**Low** (optional):
- src/api/user.ts:27 Magic number for retry count - Extract to named constant

### Positive Patterns
- Clear separation between data fetching and UI rendering

### Summary
- Fix the missing error handling in the API layer, then tighten render performance in Profile.
