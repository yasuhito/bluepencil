#!/usr/bin/env bash
# Report bluepencil's OpenClaw token usage to the AI Worth Using Agent Index.
# Meant to run every 5 minutes (systemd timer / cron).
#
# The vendored client reads OpenClaw's SQLite transcripts itself, so this runs
# it directly: there is nothing left for a wrapper to swap in.
#
# One-time setup (already done on this machine):
#   plow-agents login && plow-agents mint <line> --credential-file ~/.config/bluepencil/plow-credentials
#   . ~/.config/bluepencil/plow-credentials && ./agent_index_client.py --register --agent bluepencil ...
# After that the report key lives in ~/.agent-index/.agent-index.json and no
# Plow token is needed per run.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$HERE/agent_index_client.py" --agent "${AGENT_ID:-bluepencil}" "$@"
