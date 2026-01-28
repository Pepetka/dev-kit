---
name: security-review
description: Audit code for security risks and vulnerabilities. Use when the user asks for a security review, security audit, OWASP Top 10 scan, or vulnerability assessment (optionally scoped to a file or directory).
argument-hint: [path]
allowed-tools: Bash, Read, Grep, Glob
---

# Security Review Skill

Audit a codebase for security issues with emphasis on OWASP Top 10 and common anti-patterns.

## Usage

```
/security-review [path]
```

## Review Checklist

1. **Secrets**: hardcoded keys, tokens, passwords, leaked creds
2. **Injection**: SQL/NoSQL/command injection, XSS
3. **AuthN/AuthZ**: missing checks, weak sessions, IDOR, privilege escalation
4. **Crypto**: weak algorithms, bad randomness, key handling
5. **Config**: debug flags, insecure headers, permissive CORS
6. **Data exposure**: PII leaks, verbose errors, unsafe storage
7. **Dependencies**: known CVEs, outdated packages

## Output Format

Use `template.md` for the exact response layout and see `examples/sample.md` for a filled example.

## Guidance

- Be specific with file:line references.
- Explain impact and exploitation risk.
- Avoid false positives; verify before reporting.
