#!/bin/bash

echo "🚀 Initializing Fullstack Dev Kit..."

load_env_var_from_file() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^[[:space:]]*${key}=" "$file" | tail -n 1)"
  if [ -n "$line" ]; then
    local value="${line#*=}"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
    export "${key}=${value}"
  fi
}

# Load only the variables used by .mcp.json
load_env_files=(".env" ".env.local" ".env.development" ".env.production")
for env_file in "${load_env_files[@]}"; do
  if [ -f "$env_file" ]; then
    load_env_var_from_file "$env_file" "GITHUB_PERSONAL_ACCESS_TOKEN"
    load_env_var_from_file "$env_file" "CONTEXT7_API_KEY"
    load_env_var_from_file "$env_file" "DATABASE_URL"
    load_env_var_from_file "$env_file" "SENTRY_AUTH_TOKEN"
    load_env_var_from_file "$env_file" "SENTRY_ORG"
    load_env_var_from_file "$env_file" "SENTRY_PROJECT"
  fi
done

log_env_var() {
  local key="$1"
  local value="${!key}"
  if [ -n "$value" ]; then
    echo "✅ ${key}=*** (len:${#value})"
  else
    echo "⚠️  ${key} not set"
  fi
}

log_env_var "GITHUB_PERSONAL_ACCESS_TOKEN"
log_env_var "CONTEXT7_API_KEY"
log_env_var "DATABASE_URL"
log_env_var "SENTRY_AUTH_TOKEN"
log_env_var "SENTRY_ORG"
log_env_var "SENTRY_PROJECT"

command -v git >/dev/null 2>&1 || { echo "⚠️  Git not found - please install git"; exit 1; }

command -v jq >/dev/null 2>&1 || echo "⚠️  jq not installed - some hooks may not work properly"

command -v gh >/dev/null 2>&1 || echo "ℹ️  GitHub CLI (gh) not installed - PR review features will be limited"

if command -v gh >/dev/null 2>&1; then
  if ! gh auth status >/dev/null 2>&1; then
    echo "ℹ️  GitHub CLI not authenticated - run 'gh auth login' for PR review features"
  fi
fi

if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
  REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "unknown")
  echo "📂 Project: $REPO_NAME"
  echo "🌿 Branch: $BRANCH"

  if [ -f "package.json" ]; then
    echo "📦 Node.js project detected"
  fi
else
  echo "ℹ️  Not in a git repository"
fi

echo "✅ Environment ready"
exit 0
