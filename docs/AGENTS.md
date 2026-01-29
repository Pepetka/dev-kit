# Agents Guide

Specialized subagents that provide expert assistance in specific domains.

## What are Agents?

Agents are specialized AI assistants that Claude Code can invoke for specific tasks. Each agent has:
- **Domain expertise** in a specific area
- **Tailored toolset** for their specialization
- **Custom permissions** appropriate to their role
- **Specific skills** they can execute

Agents are automatically activated when appropriate for the task at hand.

---

## Structure

Agents live in `agents/` and are Markdown files with YAML frontmatter.

**File layout:**
```
agents/
  pr-reviewer.md
  security-auditor.md
  plan-validator.md
```

**Frontmatter schema (required + optional):**
```
name: agent-name
description: What the agent does
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet|opus|haiku|inherit
permissionMode: default|acceptEdits|dontAsk|bypassPermissions|plan
skills: [skill-name]
hooks: { ... }
color: red|blue|green|amber|purple|gray
```

**Field reference:**
- `name` (required): agent identifier, kebab-case recommended (lowercase letters + hyphens).
- `description` (required): one-line summary for routing/delegation.
- `tools` (optional): comma-separated tool allowlist (e.g., `Read, Grep, Glob, Bash`). If omitted, all tools are allowed.
- `disallowedTools` (optional): comma-separated denylist removed from the allowed set.
- `model` (optional): `sonnet` | `opus` | `haiku` | `inherit` (default: `inherit`).
- `permissionMode` (optional): `default` | `acceptEdits` | `dontAsk` | `bypassPermissions` | `plan`.
- `skills` (optional): list of skill names **without** leading `/` (e.g., `[security-review]`). Skills are injected into the subagent context. Subagents do not inherit skills from the parent.
- `hooks` (optional): subagent-scoped hooks object (same schema as `hooks/hooks.json`).
- `color` (optional): UI color hint for the agent.

**Formatting notes:**
- Frontmatter must be YAML between `---` and `---`.
- Use ASCII identifiers; keep values on a single line when possible.

---

## Available Agents

### PR Reviewer

**Description:** Expert in GitHub pull request review.

**When activated:**
- Pull request review tasks
- Requests to review PR by number/URL/branch

**Specialization:**
- Correctness and regressions
- API/UX breakage and error handling
- Test coverage and reliability
- Performance risks

**Tools:**
- Read, Grep, Glob, Bash (for `gh` PR queries)
- No write access (read-only agent)

**Skills:**
- `pr-review`

**Example tasks:**
- "Review PR #123 for risks"
- "Audit this PR: https://github.com/org/repo/pull/123"
- "Review the PR for branch feature/auth-refresh"

---

### Security Auditor

**Description:** Expert in vulnerability assessment and secure coding practices.

**When activated:**
- Security reviews and audits
- Authentication/authorization implementation
- Sensitive data handling
- Cryptography implementation
- Security incident analysis

**Specialization:**
- OWASP Top 10 vulnerabilities
- Secure coding best practices
- Cryptography (hashing, encryption)
- Session management
- Access control patterns

**Tools:**
- Read, Grep, Glob (analysis only)
- No write access (read-only agent)

**Skills:**
- `security-review`

**Example tasks:**
- "Review this authentication code for security issues"
- "Audit the API for SQL injection vulnerabilities"
- "Check if our password hashing is secure"

---

### Plan Validator

**Description:** Validate implementation plans and roadmaps for completeness and risk.

**When activated:**
- Plan/roadmap review requests
- Design or implementation plan critique

**Specialization:**
- Requirements and acceptance criteria
- Sequencing and dependencies
- Testing and verification steps
- Rollout and risk mitigation

**Tools:**
- Read, Grep, Glob (analysis only)
- No write access (read-only agent)

**Skills:**
- (none)

**Example tasks:**
- "Review this implementation plan for gaps"
- "Validate our rollout plan"
- "Critique this design doc"

---

### Code Reviewer

**Description:** Expert in code quality review for uncommitted changes.

**When activated:**
- Code review tasks for uncommitted changes
- Quality review requests
- When `/code-review` skill is invoked

**Specialization:**
- Code smells and maintainability issues
- Best practices and error handling
- Performance optimizations
- Naming conventions

**Tools:**
- Read, Grep, Glob, Bash (for git operations)
- No write access (read-only agent)

**Skills:**
- `code-review`

**Example tasks:**
- "Review my current changes for quality issues"
- "Check this file for best practices"
- "Run a code review on src/services/"

---

## How Agents Work

### Automatic Activation

Agents are proactively activated by Claude Code when:
1. Task matches agent's expertise
2. Specific keywords are detected
3. Skills associated with agent are invoked

### Permission Modes

**default**: Standard permissions, asks for approval when needed

**acceptEdits**: Auto-approve file edits

**dontAsk**: Auto-deny permission prompts

**bypassPermissions**: Auto-approve all tool permissions

**plan**: Always creates an implementation plan first

### Tool Restrictions

Some agents have restricted toolsets for safety (via `tools`/`disallowedTools`):
- **Security Auditor**: Read-only, cannot modify code
- **Test Engineer**: Full access for test creation
- **PR Reviewer**: Read-only for review tasks

---

## Best Practices

### Working with Agents

1. **Trust the expertise**: Agents are specialized for their domains
2. **Provide context**: Give relevant information for better analysis
3. **Review recommendations**: Agents suggest, you decide
4. **Iterate**: Use agents multiple times as you refine code

### Example Workflows

**Security Review:**
```
User: "Review my authentication code"
→ Security Auditor activated
→ Analyzes code for vulnerabilities
→ Provides security report with fixes
```

**Code Refactoring:**
```
User: "Refactor this service class"
→ Refactoring Specialist activated (Phase 3)
→ Creates refactoring plan
→ User approves plan
→ Executes step-by-step with tests
```

**Test Coverage:**
```
User: "Add tests for user registration"
→ Test Engineer activated (Phase 2)
→ Analyzes feature requirements
→ Generates comprehensive tests
→ Reports coverage metrics
```

---

## Agent Configuration

Each agent is defined in `agents/[agent-name].md` with:

```yaml
name: agent-name
description: What the agent does
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet|opus|haiku|inherit
permissionMode: default|acceptEdits|dontAsk|bypassPermissions|plan
skills: [skill-name]
hooks: { ... }
```

### Customizing Agents

You can customize agent behavior by editing their configuration files in the `agents/` directory.

**Note:** Modifying agent behavior may affect reliability and safety.

---

## Troubleshooting

### Agent Not Activating

- Check if task matches agent's description
- Try explicitly mentioning the domain (e.g., "security audit")
- Invoke associated skill directly (e.g., `/security-review`)

### Agent Lacks Permissions

- Review agent's tool allowlist
- Some agents are intentionally restricted
- Use appropriate agent for task (e.g., don't expect Security Auditor to edit code)

### Getting Better Results

- **Be specific** about what you want reviewed/analyzed
- **Provide context** about the application and requirements
- **Ask follow-up questions** for clarification
- **Iterate** based on agent's feedback

---

## Future Enhancements

Planned improvements for agents:

- Multi-agent collaboration
- Custom agent creation
- Agent memory and learning
- Integration with external tools
- CI/CD pipeline integration
