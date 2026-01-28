---
name: code-review
description: Review uncommitted code changes for quality, maintainability, and correctness. Use when the user asks for a code review, quality review, or feedback on current git diffs (optionally scoped to a file or directory).
argument-hint: [path]
allowed-tools: Bash, Read, Grep, Glob
---

# Code Review Skill

Review uncommitted changes (staged and unstaged). If a path is provided, focus on that file or directory.

## Usage

```
/code-review [path]
```

## Review Checklist

1. **Code smells**: long functions, deep nesting, duplication, dead code, magic numbers
2. **Naming**: unclear or inconsistent names, misleading abstractions
3. **Best practices**: error handling, SRP/DRY, type safety
4. **Maintainability**: readability, complexity, unused imports/variables
5. **Performance**: obvious inefficiencies, N+1, unnecessary re-renders

## Output Format

Use `template.md` for the exact response layout and see `examples/sample.md` for a filled example.

## Guidance

- Be concise and actionable.
- Include file:line references.
- Avoid style nitpicks.
- Prioritize risk and impact.
