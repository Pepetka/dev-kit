# Fullstack Dev Kit

Comprehensive Claude Code plugin for code quality, security, and automation.

## Features

- **Code Review** - Automated review of uncommitted changes
- **Security Audit** - OWASP Top 10 vulnerability scanning
- **PR Review** - Review GitHub pull requests via `gh`
- **Protective Hooks** - Blocks dangerous operations (rm -rf /, .env editing, force push)
- **Security Auditor Agent** - Expert vulnerability assessment
- **PR Reviewer Agent** - Specialized GitHub PR review
- **Plan Validator Agent** - Reviews implementation plans for gaps and risks

## Quick Start

```bash
# Clone and setup
git clone https://github.com/pepetka/dev-kit.git
cd dev-kit
chmod +x hooks/scripts/*.sh

# Use in Claude Code
claude --plugin-dir $(pwd)

# Try it
/security-review
/code-review
/pr-review 123
```

## Requirements

- Node.js >= 18.0.0
- Git >= 2.30.0
- jq (for hooks)
- GitHub CLI (optional, for PR review)

**Install jq:**
```bash
brew install jq              # macOS
sudo apt-get install jq      # Ubuntu/Debian
```

See **[INSTALL.md](INSTALL.md)** for detailed installation.

## Skills

### `/code-review [path]`

Review uncommitted changes for code quality.

**Checks:**
- Code smells (long functions, deep nesting)
- Naming conventions
- Best practices (SOLID, DRY)
- Type safety
- Performance hints

**Example:**
```bash
/code-review src/
```

### `/security-review [path]`

Comprehensive security audit (OWASP Top 10).

**Checks:**
- Hardcoded secrets
- SQL injection
- XSS vulnerabilities
- Weak cryptography
- Authentication issues
- Configuration security

**Example:**
```bash
/security-review src/auth
```

### `/pr-review <pr-number|pr-url|branch>`

Review a GitHub pull request for correctness and risks.

**Checks:**
- Correctness and edge cases
- Security pitfalls
- API/UX breakage
- Test coverage
- Performance regressions

**Example:**
```bash
/pr-review 123
```

## Workflow Example

```bash
# 1. Make changes
vim src/auth/login.ts

# 2. Review quality
/code-review src/auth

# 3. Security check
/security-review src/auth

# 4. Commit when clean
git add src/auth/login.ts
git commit -m "feat: improve login validation"
```

## Hooks

Automatic protection against dangerous operations:

- **Blocks editing**: `.env` files, lock files, `.git/`, private keys
- **Blocks commands**: `rm -rf /`, `git push --force main`, fork bombs
- **Warns about**: `chmod 777`, `npm publish --force`

## Documentation

- **[INSTALL.md](INSTALL.md)** - Installation and setup
- **[docs/SKILLS.md](docs/SKILLS.md)** - Complete skills reference
- **[docs/AGENTS.md](docs/AGENTS.md)** - Specialized agents guide
- **[docs/HOOKS.md](docs/HOOKS.md)** - Hooks customization

## Project Status

**Version:** 1.0.0 (Phase 1 Complete ✅)

**Included:**
- Code Review skill
- Security Review skill
- PR Review skill
- Security Auditor agent
- PR Reviewer agent
- Plan Validator agent
- Protective hooks

**Roadmap:**
- Phase 2: Test coverage
- Phase 3: Architecture analysis, Changelog generation
- Phase 4: PostgreSQL/Sentry integration

## Why This Plugin?

✅ **Framework-agnostic** - Works with any tech stack
✅ **Security-first** - OWASP Top 10, prevents secret exposure
✅ **Non-invasive** - Suggests, doesn't auto-fix
✅ **Developer-friendly** - Quick, actionable feedback
✅ **Extensible** - Easy to customize

## License

MIT - see [LICENSE](LICENSE)

## Contributing

Contributions welcome! Fork, create feature branch, submit PR.

## Support

- **Issues**: GitHub Issues
- **Docs**: `docs/` directory
