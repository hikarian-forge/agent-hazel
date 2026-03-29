#!/usr/bin/env bash

# README
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
# This script is used as the entry point script for
# docker, it will make sure the required files for
# NullClaw have read/write permissions and other
# QoL changes.
#
# Current File: entrypoint.sh
# Commands: N/A
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*

set -e

if [ -f /nullclaw-data/workspace/memory.db ]; then
    chmod 777 /nullclaw-data/workspace/memory.db
fi

chmod -R 777 /nullclaw-data/workspace

exec "$@"