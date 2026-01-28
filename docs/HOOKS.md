# Hooks Reference

Hooks are automated safeguards that prevent dangerous operations and enforce best practices.

## What are Hooks?

Hooks are scripts that execute at specific points during Claude Code operations:
- **SessionStart**: When a session begins
- **UserPromptSubmit**: When a user message is submitted
- **PreToolUse**: Before a tool is executed
- **PermissionRequest**: When a tool requests permission
- **PostToolUse**: After a tool completes
- **PostToolUseFailure**: After a tool fails
- **SubagentStart**: When a subagent starts
- **SubagentStop**: When a subagent stops
- **Stop**: When Claude stops responding
- **PreCompact**: Before context compaction
- **SessionEnd**: When a session ends
- **Notification**: When a notification is emitted
- **Setup**: When Claude Code initializes

Hooks can:
- **Block** dangerous operations (exit code 2)
- **Warn** about risky actions (stderr output)
- **Setup** environment and dependencies
- **Enforce** project conventions

---

## Active Hooks

### 1. Validate Sensitive Files (PreToolUse)

**Trigger:** Before `Write` or `Edit` tool use

**Purpose:** Prevent accidental exposure of sensitive data

**Requirements:** `jq` must be installed. If not available, hook gracefully disables with warning.

**Blocks editing of:**
- `.env` and common real env variants (`.env.local`, `.env.development`, `.env.production`, `.env.test`)
- Lock files (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`)
- `.git/` directory
- Private keys (`*.pem`, `*.key`, `id_rsa`)
- `secrets/` directory
- `.ssh/` directory
- Production configs (`docker-compose.prod.yml`)

**Example (blocked):**
```
🔒 Blocked: Cannot edit .env (protected file)
This file is protected to prevent accidental exposure of sensitive data.
If you need to modify this file, please do so manually.
```

**Example (no jq):**
```
⚠️  Warning: jq not installed - sensitive file protection disabled
Install jq: brew install jq (macOS) or sudo apt-get install jq (Linux)
```

**Why:** Prevents Claude from accidentally committing secrets or overwriting critical files.

---

### 2. Validate Command (PreToolUse)

**Trigger:** Before `Bash` tool use

**Purpose:** Prevent destructive or dangerous commands

**Requirements:** `jq` must be installed. If not available, hook gracefully disables with warning.

**Blocks:**
- `rm -rf /` - Recursive delete from root
- `git push --force main/master` - Force push to main branches
- `rm -rf .git` - Deletion of git repository
- Fork bombs (`:(){:|:&};:`)
- Dangerous disk operations (`dd if=/dev/zero of=/dev/sda`)

**Warns about:**
- `chmod 777` - Overly permissive file permissions
- `npm publish --force` - Force publishing to npm

**Example (blocked):**
```
🚫 Blocked: Force push to main/master branch
Force pushing to main/master can overwrite history and cause data loss.
```

**Example (no jq):**
```
⚠️  Warning: jq not installed - command validation disabled
Install jq: brew install jq (macOS) or sudo apt-get install jq (Linux)
```

**Why:** Protects against accidental data loss and destructive operations.

---

### 3. Setup Environment (SessionStart)

**Trigger:** When Claude Code session starts

**Purpose:** Initialize environment and check dependencies

**Checks:**
- Git installation
- jq installation (for hook JSON processing)
- GitHub CLI installation and authentication
- Project type detection

**Output:**
```
🚀 Initializing Fullstack Dev Kit...
📂 Project: my-app
🌿 Branch: feature/new-auth
📦 Node.js project detected
✅ Environment ready
```

**Why:** Ensures all required tools are available and provides project context.

---

## Hook Configuration

Hooks are defined in `hooks/hooks.json`:

```json
{
  "description": "Fullstack Dev Kit hooks",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/validate-sensitive-files.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Properties

**Top-level structure:**
```
{
  "description": "Optional hook pack description",
  "hooks": {
    "PreToolUse": [ ... ],
    "PostToolUse": [ ... ],
    "SessionStart": [ ... ],
    "SessionEnd": [ ... ]
  }
}
```

**Lifecycle keys:**
- `PreToolUse`: runs before any tool call
- `PermissionRequest`: runs when a tool requests permission
- `PostToolUse`: runs after any tool completes
- `PostToolUseFailure`: runs after a tool fails
- `SessionStart`: runs when a session begins
- `SessionEnd`: runs when a session ends
- `UserPromptSubmit`: runs when a user message is submitted
- `Stop`: runs when Claude stops responding
- `SubagentStart`: runs when a subagent starts
- `SubagentStop`: runs when a subagent stops
- `PreCompact`: runs before context compaction
- `Notification`: runs when a notification is emitted
- `Setup`: runs when Claude Code initializes

Each item under a lifecycle key can define:

- **matcher** (optional): Tool name regex for tool-related lifecycles (`PreToolUse`, `PostToolUse`, `PermissionRequest`), e.g. `"Write|Edit"` or `"Bash"`. If omitted, runs for all tools in that lifecycle.
- **hooks** (required): Array of hook actions to run.

Each entry in `hooks` can include:

- **type** (required): Action type. Supported: `"command"`, `"prompt"`.
- **command** (required for `command`): Script or command to run.
- **prompt** (required for `prompt`): Prompt string or array of prompt strings.
- **timeout** (optional): Maximum runtime in seconds.

---

## Hook Scripts

Scripts are located in `hooks/scripts/`:

- `validate-sensitive-files.sh`
- `validate-command.sh`
- `setup-env.sh`

### Script Interface

**Input:** JSON via stdin with event-specific fields (example for a tool hook)
```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file"
  }
}
```

**Output:**
- **Exit 0**: Allow operation
- **Exit 2**: Block operation
- **stderr**: User message (warning or error)

### Example Hook Script

```bash
#!/bin/bash
set -e

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE_PATH" == *".env"* ]]; then
  echo "🔒 Blocked: Cannot edit .env file" >&2
  exit 2
fi

exit 0
```

---

## Customizing Hooks

### Disable a Hook

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

### Add Protected Files

Edit `hooks/scripts/validate-sensitive-files.sh`:

```bash
BLOCKED_PATTERNS=(
  ".env"
  "custom-secret.txt"  # Add your pattern
)
```

### Add Blocked Commands

Edit `hooks/scripts/validate-command.sh`:

```bash
if echo "$COMMAND" | grep -qE 'your-dangerous-pattern'; then
  echo "🚫 Blocked: Your custom message" >&2
  exit 2
fi
```

### Create New Hook

1. Create script in `hooks/scripts/`
2. Make it executable: `chmod +x hooks/scripts/your-hook.sh`
3. Add to `hooks/hooks.json`

---

## Best Practices

### When to Use Hooks

**Good use cases:**
- Preventing data loss
- Enforcing security policies
- Project-specific conventions
- Environment validation

**Bad use cases:**
- Code formatting (use formatters)
- Linting (use linters)
- Complex business logic
- Anything that slows down workflow

### Hook Design Principles

1. **Fast**: Hooks should execute quickly (<100ms)
2. **Clear**: Error messages should be actionable
3. **Safe**: Hooks should not modify state
4. **Focused**: One responsibility per hook
5. **Bypassable**: Allow manual override when needed

### Testing Hooks

```bash
# Test validate-sensitive-files
echo '{"tool_input":{"file_path":".env"}}' | ./hooks/scripts/validate-sensitive-files.sh
# Should exit with code 2 and show error

# Test validate-command
echo '{"tool_input":{"command":"rm -rf /"}}' | ./hooks/scripts/validate-command.sh
# Should exit with code 2 and show error
```

---

## Troubleshooting

### Hook Not Executing

1. Check the hook exists under the correct lifecycle key and its `hooks` array is not empty
2. Verify script is executable: `chmod +x hooks/scripts/your-hook.sh`
3. Test script manually
4. Check Claude Code logs

### Hook Blocking Valid Operations

1. Review matcher pattern - may be too broad
2. Add exceptions to script
3. Temporarily disable hook
4. Report issue for plugin improvement

### Hook Script Errors

Common issues:
- Missing `jq` - install with `brew install jq` (macOS)
- Permission errors - run `chmod +x hooks/scripts/*.sh`
- Path issues - use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths

---

## Future Enhancements

Planned hook improvements:

- PostToolUse hooks for validation
- SessionEnd hooks for cleanup
- Async hooks for expensive operations
- Hook templates for common patterns
- Better error reporting
- Hook testing framework
