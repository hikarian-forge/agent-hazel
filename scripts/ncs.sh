#!/usr/bin/env bash

# README
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
# This script initializes local environment setup by
# creating `.env` from `.env.sample` when missing,
# then recreates and starts the Docker Compose stack
# in detached mode for a clean first run.
#
# Current File: ncs.sh
# Commands: N/A
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "$SCRIPT_DIR/logs.sh"

ENV_SAMPLE="${ROOT_DIR}/.env.sample"
ENV_FILE="${ROOT_DIR}/.env"

if ! command -v docker >/dev/null 2>&1; then
  error "docker is not installed or not on PATH, install docker to continue this script."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  error "docker compose is not provided or not available, check or create compose file."
  exit 1
fi

if [ ! -f "${ENV_SAMPLE}" ]; then
  error ".env.sample was not found at ${ENV_SAMPLE}."
  exit 1
fi

if [ ! -f "${ENV_FILE}" ]; then
  cp "${ENV_SAMPLE}" "${ENV_FILE}"
  info "Created .env from .env.sample"
else
  info ".env already exists; keeping current values"
fi

info  "Starting fresh containers from compose.yml..."

docker compose -f "${ROOT_DIR}/compose.yml" down --remove-orphans
docker compose -f "${ROOT_DIR}/compose.yml" up -d --force-recreate

info "Done! Services are running in detached mode."
