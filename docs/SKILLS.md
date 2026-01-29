# Skills Guide

Complete reference for all available skills in Fullstack Dev Kit.

## Structure

Skills live in `skills/<skill-name>/` and must include `SKILL.md`.

**File layout:**
```
skills/
  pr-review/
    SKILL.md
    template.md
    examples/
      sample.md
  code-review/
    SKILL.md
    template.md
    examples/
      sample.md
  security-review/
    SKILL.md
    template.md
    examples/
      sample.md
```

**Frontmatter schema (required + optional):**
```
name: skill-name
description: What the skill does
argument-hint: [path]
allowed-tools: Bash, Read, Grep, Glob
disable-model-invocation: false
user-invocable: true
model: sonnet|opus|haiku
context: fork
agent: subagent-name
hooks: { ... }
```

**Field reference:**
- `name` (optional, recommended): skill identifier, **no** leading `/`. If omitted, uses the skill directory name. Constraints: lowercase letters, numbers, and hyphens; max 64 chars.
- `description` (recommended): short summary. If omitted, the first paragraph of `SKILL.md` is used.
- `argument-hint` (optional): short hint string shown to the user (e.g., `[path]`).
- `allowed-tools` (optional): comma-separated list of tools Claude can use without asking permission while the skill is active.
- `disable-model-invocation` (optional): `true` to prevent the skill from being auto-invoked by the model.
- `user-invocable` (optional): `false` to hide from `/skills` and block manual invocation.
- `model` (optional): `sonnet` | `opus` | `haiku`.
- `context` (optional): set to `fork` to run the skill in a subagent context.
- `agent` (optional): subagent name to use when `context: fork` is set.
- `hooks` (optional): skill-scoped hooks object (same schema as `hooks/hooks.json`). Skills also support `once: true` inside hook entries to run a hook only once per session.

**Formatting notes:**
- Frontmatter must be YAML between `---` and `---`.
- The user invokes the skill with a leading `/` (e.g., `/code-review`).
- `template.md` defines the exact response layout; `examples/` is optional but recommended.

**String substitutions:**
- `$ARGUMENTS` (all arguments), `$ARGUMENTS[N]` or `$N` (0-based index)
- `${CLAUDE_SESSION_ID}` (current session id)

## Available Skills

### `/pr-review` - Pull Request Review

Comprehensive review of a GitHub pull request.

**Usage:**
```bash
/pr-review <pr-number|pr-url|branch>
```

**What it checks:**
- Correctness and edge cases
- Security and safety pitfalls
- API/UX breakage and error handling
- Test coverage and reliability
- Performance regressions

**Example:**
```bash
# Review PR by number
/pr-review 123

# Review PR by URL
/pr-review https://github.com/org/repo/pull/123

# Review PR by branch
/pr-review feature/auth-refresh
```

**Output includes:**
- Issues categorized by severity
- File:line references
- Actionable fixes and questions

---

### `/code-review` - Code Quality Review

Review uncommitted changes for code quality and best practices.

**Usage:**
```bash
/code-review [path]
```

**What it checks:**
- Code smells (long functions, deep nesting)
- Naming conventions
- Best practices (SOLID, DRY)
- Maintainability and readability
- Type safety
- Performance hints

**Example:**
```bash
# Review all changes
/code-review

# Review specific directory
/code-review src/services

# Review single file
/code-review src/auth.ts
```

**Output includes:**
- List of reviewed files
- Issues categorized by priority
- Positive patterns observed
- Actionable recommendations

**Integration:** Automatically activates the `code-reviewer` agent when invoked.

---

### `/security-review` - Security Audit

Comprehensive security audit focusing on OWASP Top 10 vulnerabilities.

**Usage:**
```bash
/security-review [path]
```

**What it checks:**
- Hardcoded secrets (API keys, passwords)
- SQL injection vulnerabilities
- XSS risks
- CSRF protection
- Authentication & authorization issues
- Weak cryptography
- Configuration security
- Dependency vulnerabilities

**Example:**
```bash
# Audit entire project
/security-review

# Audit authentication module
/security-review src/auth

# Audit specific file
/security-review config/database.ts
```

**Output includes:**
- Critical vulnerabilities (immediate action required)
- High/Medium/Low risk issues
- Security score (1-10)
- Detailed remediation steps

---

## Best Practices

### When to Use Code Review

- Before committing changes
- After implementing a feature
- When refactoring existing code
- As part of your development workflow

### When to Use Security Review

- Before releasing to production
- After implementing authentication/authorization
- When handling sensitive data
- After adding new dependencies
- Regularly as part of security audits

### Workflow Example

```bash
# 1. Make code changes
# ... edit files ...

# 2. Review code quality
/code-review

# 3. Fix any issues found
# ... make improvements ...

# 4. Run security audit (if touching sensitive areas)
/security-review src/auth

# 5. Commit when clean
git add .
git commit -m "feat: add user authentication"
```

---

## Tips

- **Be specific**: Provide path arguments to focus reviews
- **Review early**: Catch issues before they become technical debt
- **Prioritize**: Fix high-priority issues first
- **Learn**: Use reviews as learning opportunities
- **Automate**: Integrate into your CI/CD pipeline

---

## Integration with Tools

All skills automatically integrate with:

- **Git**: For change detection and file analysis
- **Context7**: For framework-specific best practices
- **GitHub** (if configured): For PR features
- **npm/yarn/pnpm**: For dependency analysis
