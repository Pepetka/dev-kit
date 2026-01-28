#!/bin/bash
set -e

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  Warning: jq not installed - sensitive file protection disabled" >&2
  echo "Install jq: brew install jq (macOS) or sudo apt-get install jq (Linux)" >&2
  exit 0
fi

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BLOCKED_PATTERNS=(
  ".env.local"
  ".env.development"
  ".env.production"
  ".env.test"
  "package-lock.json"
  "yarn.lock"
  "pnpm-lock.yaml"
  "Gemfile.lock"
  "composer.lock"
  ".git/"
  "node_modules/"
  "docker-compose.prod.yml"
  "secrets/"
  ".ssh/"
  "id_rsa"
)

# Block real .env files while allowing examples/templates
if [[ "$FILE_PATH" == ".env" || "$FILE_PATH" == */.env ]]; then
  echo "🔒 Blocked: Cannot edit $FILE_PATH (protected file)" >&2
  echo "This file is protected to prevent accidental exposure of sensitive data." >&2
  echo "If you need to modify this file, please do so manually." >&2
  exit 2
fi

# Check literal patterns
for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "🔒 Blocked: Cannot edit $FILE_PATH (protected file)" >&2
    echo "This file is protected to prevent accidental exposure of sensitive data." >&2
    echo "If you need to modify this file, please do so manually." >&2
    exit 2
  fi
done

# Check file extensions (wildcards)
if [[ "$FILE_PATH" == *.pem ]]; then
  echo "🔒 Blocked: Cannot edit $FILE_PATH (PEM private key)" >&2
  echo "This file is protected to prevent accidental exposure of private keys." >&2
  exit 2
fi

if [[ "$FILE_PATH" == *.key ]]; then
  echo "🔒 Blocked: Cannot edit $FILE_PATH (private key)" >&2
  echo "This file is protected to prevent accidental exposure of private keys." >&2
  exit 2
fi

exit 0
