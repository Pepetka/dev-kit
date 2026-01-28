---
name: pr-review
description: Review a GitHub pull request for correctness, risks, and best practices (by PR number, URL, or current branch).
argument-hint: <pr-number|pr-url|branch>
allowed-tools: Bash, Read, Grep, Glob
---

# PR Review Skill

Review a GitHub pull request using `gh` and local repo context.

## Usage

```
/pr-review <pr-number|pr-url|branch>
```

## Workflow

1. Resolve the PR target:
   - If number or URL: use `gh pr view` to fetch metadata and files.
   - If branch: infer PR with `gh pr view --json` or `gh pr list`.
2. Fetch the diff (`gh pr diff`) and review changed files locally.
3. Identify issues by severity and provide actionable fixes.

## Review Checklist

1. **Correctness**: logic errors, edge cases, inconsistent behavior
2. **Safety**: security pitfalls, data exposure, unsafe defaults
3. **API/UX**: breaking changes, contracts, error handling
4. **Tests**: missing coverage, fragile tests, mismatched assertions
5. **Performance**: obvious inefficiencies, N+1, heavy operations

## Output Format

Use `template.md` for the exact response layout and see `examples/sample.md` for a filled example.

## Guidance

- Be concise and actionable.
- Include file:line references.
- Avoid style-only nits.
- Prioritize risk and impact.
