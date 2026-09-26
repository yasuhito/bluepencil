#!/bin/sh
# Install bluepencil into your OpenClaw Gateway.
#
#   curl -fsSL https://raw.githubusercontent.com/yasuhito/bluepencil/main/install.sh | sh
#
# BLUEPENCIL_DIR      where to clone (default ~/bluepencil)
# BLUEPENCIL_MODEL    model id for bluepencil (default: the Gateway's)
# BLUEPENCIL_CALLERS  agents allowed to call it (default: the default agent)
# OPENCLAW_PROFILE    OpenClaw profile to install into (default: none)
set -eu

# Wrapped so that `curl | sh` reads the whole script before running any of it.
main() {
  dir=${BLUEPENCIL_DIR:-$HOME/bluepencil}
  repo=https://github.com/yasuhito/bluepencil

  oc() { openclaw ${OPENCLAW_PROFILE:+--profile "$OPENCLAW_PROFILE"} "$@"; }

  for cmd in git node openclaw; do
    command -v "$cmd" >/dev/null || { echo "bluepencil: $cmd is required" >&2; exit 1; }
  done

  # An existing checkout holds the learned voice and drafts; leave it as is.
  [ -d "$dir" ] || git clone --quiet "$repo" "$dir"

  agents=$(oc agents list --json)
  has_agent() { printf '%s' "$agents" | node -e '
    const list = JSON.parse(require("fs").readFileSync(0, "utf8"));
    process.exit(list.some((a) => a.id === process.argv[1]) ? 0 : 1);' "$1"; }

  if has_agent bluepencil; then
    echo "bluepencil: agent already registered, keeping its settings"
  else
    oc agents add bluepencil --workspace "$dir" --non-interactive \
      ${BLUEPENCIL_MODEL:+--model "$BLUEPENCIL_MODEL"} >/dev/null
  fi
  oc agents set-identity --agent bluepencil --from-identity >/dev/null

  callers=${BLUEPENCIL_CALLERS:-$(printf '%s' "$agents" | node -e '
    const list = JSON.parse(require("fs").readFileSync(0, "utf8"));
    console.log((list.find((a) => a.isDefault) || {}).id || "");')}

  # config set replaces arrays, so merge into the current allow list.
  current=$(oc config get tools.agentToAgent.allow --json 2>/dev/null) || current='[]'
  allow=$(printf '%s' "$current" | node -e '
    const have = JSON.parse(require("fs").readFileSync(0, "utf8"));
    const add = [...process.argv[1].split(/[\s,]+/), "bluepencil"].filter(Boolean);
    console.log(JSON.stringify([...new Set([...have, ...add])]));' "$callers")
  oc config set tools.agentToAgent.enabled true >/dev/null
  oc config set tools.agentToAgent.allow "$allow" >/dev/null

  echo "bluepencil: installed in $dir"
  echo "bluepencil: agents allowed to call it: $allow"
  echo "Open bluepencil in the Control UI and start a new conversation."
}

main "$@"
