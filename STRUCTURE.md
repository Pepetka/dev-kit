# Project Structure

```
dev-kit/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
│   └── marketplace.json         # Local plugin marketplace manifest
│
├── skills/                      # User-invocable skills
│   ├── code-review/
│   │   ├── SKILL.md            # Skill instructions
│   │   ├── template.md         # Output template
│   │   └── examples/
│   │       └── sample.md       # Example output
│   ├── pr-review/
│   │   ├── SKILL.md
│   │   ├── template.md
│   │   └── examples/
│   │       └── sample.md
│   └── security-review/
│       ├── SKILL.md
│       ├── template.md
│       └── examples/
│           └── sample.md
│
├── agents/                      # Specialized AI agents
│   ├── plan-validator.md       # Plan validation agent
│   ├── pr-reviewer.md          # PR review agent
│   └── security-auditor.md     # Security expert agent
│
├── hooks/                       # Safety hooks
│   ├── hooks.json              # Hooks configuration
│   └── scripts/
│       ├── validate-sensitive-files.sh
│       ├── validate-command.sh
│       └── setup-env.sh
│
├── docs/                        # Documentation
│   ├── SKILLS.md               # Skills reference
│   ├── AGENTS.md               # Agents guide
│   └── HOOKS.md                # Hooks reference
│
├── .mcp.json                    # MCP servers config
├── .gitignore                   # Git ignore rules
├── LICENSE                      # MIT License
├── README.md                    # Main documentation
└── INSTALL.md                   # Installation guide
```

## File Count

- Configuration: 4 files (.claude-plugin/plugin.json, .claude-plugin/marketplace.json, .mcp.json, hooks/hooks.json)
- Skills: 3 skills × 3 files = 9 files
- Agents: 3 files
- Hooks: 3 bash scripts
- Documentation: 6 files (README, INSTALL, 3 in docs/, LICENSE)

**Total: 25 essential files**
