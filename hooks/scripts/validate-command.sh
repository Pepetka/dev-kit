#!/bin/bash
set -e

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  Warning: jq not installed - command validation disabled" >&2
  echo "Install jq: brew install jq (macOS) or sudo apt-get install jq (Linux)" >&2
  exit 0
fi

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

if echo "$COMMAND" | grep -qE 'rm\s+[^[:space:]]*--no-preserve-root'; then
  echo "🚫 Blocked: Dangerous recursive delete with --no-preserve-root" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+[^[:space:]]*-r[^[:space:]]*-f[^[:space:]]*\s+/\s*$'; then
  echo "🚫 Blocked: Dangerous recursive delete from root directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+[^[:space:]]*-f[^[:space:]]*-r[^[:space:]]*\s+/\s*$'; then
  echo "🚫 Blocked: Dangerous recursive delete from root directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+[^[:space:]]*-r[^[:space:]]*-f[^[:space:]]*\s+/\s+'; then
  echo "🚫 Blocked: Dangerous recursive delete from root directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+[^[:space:]]*-f[^[:space:]]*-r[^[:space:]]*\s+/\s+'; then
  echo "🚫 Blocked: Dangerous recursive delete from root directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'git\s+push.*--force.*(main|master)'; then
  echo "🚫 Blocked: Force push to main/master branch" >&2
  echo "Force pushing to main/master can overwrite history and cause data loss." >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+-rf.*\.git\s*$'; then
  echo "🚫 Blocked: Attempt to delete .git directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'rm\s+-rf.*\.git/'; then
  echo "🚫 Blocked: Attempt to delete .git directory" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE ':\s*\(\s*\)\s*\{\s*:\s*\|\s*:\s*&?\s*\}'; then
  echo "🚫 Blocked: Fork bomb detected" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'dd\s+if=/dev/(zero|random).*of=/dev/(sda|hda|disk)'; then
  echo "🚫 Blocked: Dangerous disk operation" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'chmod\s+(-R\s+)?777'; then
  echo "⚠️  Warning: Setting permissions to 777 is insecure" >&2
  echo "Consider using more restrictive permissions." >&2
fi

if echo "$COMMAND" | grep -qE 'npm\s+publish.*--force'; then
  echo "⚠️  Warning: Force publishing to npm registry" >&2
  echo "This can overwrite existing versions." >&2
fi

exit 0
