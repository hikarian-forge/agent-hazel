#!/usr/bin/env bash

# README
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
# This script initializes the local `.env` file from
# `.env.sample` and scans the codebase for hardcoded
# environment variable leaks. It ensures secrets stay
# in `.env` (or `.env.sample`) and are referenced via
# interpolation in config files.
#
# Current File: envs.sh
# Commands: N/A
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "$SCRIPT_DIR/logs.sh"

ENV_SAMPLE="${ROOT_DIR}/.env.sample"
ENV_FILE="${ROOT_DIR}/.env"

if [ ! -f "${ENV_SAMPLE}" ]; then
  error ".env.sample not found at ${ENV_SAMPLE}."
  exit 1
fi

if [ ! -f "${ENV_FILE}" ]; then
  cp "${ENV_SAMPLE}" "${ENV_FILE}"
  info "Created .env from .env.sample"
else
  info ".env already exists; keeping current values"
fi

info "Checking codebase for any leaked secrets..."

LEAKS_FOUND=0

ENV_VARS=(
  "DISCORD_BOT_TOKEN"
  "DISCORD_GUILD_ID"
  "DISCORD_ALLOW_FROM"
  "DISCORD_CHANNEL_ID"
  "OPENROUTER_API_KEY"
  "GROQ_API_KEY"
  "GEMINI_API_KEY"
  "OLLAMA_BASE_URL"
  "OLLAMA_EMBEDDING_MODEL"
  "NULLCLAW_IMAGE"
)


# NOTE: 
# Patterns are used to detect hardcoded secrets. We look for values
# that look like tokens/ids/keys but are not wrapped in ${} or using
# their .env value.
PATTERNS=(
  'token.*:.*"[^$][^"]*"'
  'api_key.*:.*"[^$][^"]*"'
  'guild_id.*:.*"[0-9]\{6,\}"'
  'allow_from.*:.*"[0-9]\{6,\}"'
)

CONFIG_FILES=$(find "${ROOT_DIR}" -type f \( -name "*.json" -o -name "*.yml" -o -name "*.yaml" \) \
  ! -path "*/node_modules/*" \
  ! -path "*/.git/*" \
  ! -path "*/.env*" \
  2>/dev/null || true)

for file in ${CONFIG_FILES}; do
  for var in "${ENV_VARS[@]}"; do
    if grep -q "${var}" "${file}" 2>/dev/null; then
      if grep -Pq "\"\$\{.*${var}.*\}\"|\"\$\{env:${var}\}\"|\"${var}\"" "${file}" 2>/dev/null; then
        continue  # Skip secrets properly interpolated.
      else
        if grep -Pq "${var}.*:.*\"[A-Za-z0-9._-]{10,}\"" "${file}" 2>/dev/null; then
          error "Potential leak in ${file}: ${var} appears to have a hardcoded value."
          LEAKS_FOUND=$((LEAKS_FOUND + 1))
        fi
      fi
    fi
  done

  # NOTE: Check for Discord token patterns (MTA... format)
  if grep -Pq "token.*:.*\"MT[A-Za-z0-9._-]{20,}\"" "${file}" 2>/dev/null; then
    error "Discord token pattern detected in ${file}."
    LEAKS_FOUND=$((LEAKS_FOUND + 1))
  fi

  # NOTE: Check for API key patterns (sk-, gsk-, etc.)
  if grep -Pq "(api_key|API_KEY).*:.*\"(sk-|gsk-|xoxb-|xoxp-)[A-Za-z0-9._-]{10,}\"" "${file}" 2>/dev/null; then
    error "API key pattern detected in ${file}"
    LEAKS_FOUND=$((LEAKS_FOUND + 1))
  fi
done

if [ ${LEAKS_FOUND} -gt 0 ]; then
  error "Found ${LEAKS_FOUND} potential environment variable leak(s). Please fix before committing."
  exit 1
else
  success "No environment variable leaks detected. Environment file is ready to be populated."
fi
