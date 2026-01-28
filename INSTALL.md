# Installation Guide

Step-by-step guide to install and configure Fullstack Dev Kit plugin for Claude Code.

## Prerequisites

Before installing, ensure you have:

### Required
- **Node.js** >= 18.0.0 - [Download](https://nodejs.org/)
- **Git** >= 2.30.0 - [Download](https://git-scm.com/)
- **Claude Code CLI** - [Installation Guide](https://github.com/anthropics/claude-code)
- **jq** - JSON processor for hooks

### Optional
- **GitHub CLI (gh)** - For PR review features
- **PostgreSQL client** - For database analysis (Phase 2+)

### Install jq

**macOS:**
```bash
brew install jq
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq
```

**Windows (WSL):**
```bash
sudo apt-get install jq
```

---

## Installation

### Option 1: Clone from GitHub (Recommended)

```bash
# Clone the repository
git clone https://github.com/pepetka/dev-kit.git

# Navigate to plugin directory
cd dev-kit

# Make hook scripts executable
chmod +x hooks/scripts/*.sh

# Verify installation
./hooks/scripts/setup-env.sh
```

### Option 2: Download ZIP

1. Download ZIP from GitHub releases
2. Extract to desired location
3. Run `chmod +x hooks/scripts/*.sh`

---

## Configuration

### 1. Environment Variables (Optional)

For PR review (optional):

```bash
# Add to ~/.bashrc or ~/.zshrc
export GITHUB_TOKEN="ghp_your_github_token_here"
```

**Getting GitHub token:**
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Select scopes: `repo`, `read:org`
4. Copy token and add to environment

### 2. Load Plugin in Claude Code

```bash
# Option A: Use plugin directory flag
claude --plugin-dir /path/to/dev-kit

# Option B: Add to Claude Code config
# Edit ~/.claude/config.json
{
  "plugins": [
    "/path/to/dev-kit"
  ]
}
```

### 3. Verify Installation

Start Claude Code and check:

```bash
# List available skills
/skills

# Should show:
# - code-review
# - security-review
# - pr-review
```

---

## First Use

### Test Security Review

```bash
# In your project directory
cd /path/to/your/project

# Run security review
/security-review
```

### Test Code Review

```bash
# Make some changes to your code
# ... edit files ...

# Run code review on changes
/code-review
```

### Test PR Review (Optional)

```bash
# Review PR by number (requires gh + auth)
/pr-review 123
```

---

## Configuration Options

### Customize Protected Files

Edit `hooks/scripts/validate-sensitive-files.sh`:

```bash
BLOCKED_PATTERNS=(
  ".env"
  "your-custom-pattern"  # Add your patterns
)
```

### Customize Blocked Commands

Edit `hooks/scripts/validate-command.sh`:

```bash
# Add custom dangerous patterns
if echo "$COMMAND" | grep -qE 'your-pattern'; then
  echo "🚫 Blocked: Your message" >&2
  exit 2
fi
```

### Disable Hooks

Edit `hooks/hooks.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": []
      }
    ]
  }
}
```

---

## Troubleshooting

### Hooks Not Working

**Issue:** Hooks not executing

**Solutions:**
1. Verify jq is installed: `which jq`
2. Check script permissions: `ls -la hooks/scripts/`
3. Make executable: `chmod +x hooks/scripts/*.sh`
4. Test manually: `echo '{}' | ./hooks/scripts/setup-env.sh`

### GitHub Features Not Available

**Issue:** PR review features not working

**Solutions:**
1. Install GitHub CLI: `brew install gh` (macOS)
2. Authenticate: `gh auth login`
3. Verify: `gh auth status`
4. Set token: `export GITHUB_TOKEN=ghp_xxx`

### Plugin Not Loading

**Issue:** Skills not available

**Solutions:**
1. Check plugin path is correct
2. Verify plugin.json exists: `cat .claude-plugin/plugin.json`
3. Check Claude Code logs
4. Restart Claude Code session

### Permission Errors

**Issue:** Cannot execute hook scripts

**Solution:**
```bash
chmod +x hooks/scripts/*.sh
```

---

## Updating

### Update to Latest Version

```bash
# If installed via git clone
cd dev-kit
git pull origin main

# Make scripts executable again
chmod +x hooks/scripts/*.sh

# Restart Claude Code
```

---

## Uninstallation

### Remove Plugin

```bash
# Option A: Remove from config
# Edit ~/.claude/config.json and remove plugin path

# Option B: Stop using --plugin-dir flag

# Option C: Delete plugin directory
rm -rf /path/to/dev-kit
```

---

## Next Steps

After installation:

1. Read [Skills Guide](docs/SKILLS.md) to learn available features
2. Review [Hooks Reference](docs/HOOKS.md) to understand protections
3. Check [Agents Guide](docs/AGENTS.md) for specialized assistants
4. Try security review on your project: `/security-review`
5. Integrate into your workflow

---

## Getting Help

- **Documentation**: See `docs/` directory
- **Issues**: Report bugs on GitHub
- **Examples**: Check example usage in README.md

---

## What's Included (Phase 1)

✅ **Skills:**
- `/code-review` - Code quality review
- `/security-review` - Security audit
- `/pr-review` - PR review

✅ **Agents:**
- Security Auditor - Vulnerability assessment
- PR Reviewer - Pull request review
- Plan Validator - Implementation plan review

✅ **Hooks:**
- Sensitive files protection
- Dangerous command validation
- Environment setup

✅ **MCP Servers:**
- GitHub integration (configured)
- Context7 documentation (configured)

---

## Coming in Future Phases

📅 **Phase 2:**
- Test Coverage skill
- Test Engineer agent

📅 **Phase 3:**
- Architecture Review skill
- Changelog Generator skill
- Refactoring tools

📅 **Phase 4:**
- Additional integrations
- Custom MCP servers
