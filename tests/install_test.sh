#!/bin/sh
# End-to-end test for install.sh against a real OpenClaw CLI.
# Runs in a throwaway HOME and clones this repository's HEAD, so neither
# your ~/.openclaw nor this checkout is touched.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
HOME=$(mktemp -d)
export HOME
trap 'rm -rf "$HOME"' EXIT
export BLUEPENCIL_REPO="file://$root"
ws=$HOME/bluepencil

fail() { echo "FAIL: $*" >&2; exit 1; }
get() {
  openclaw config get "$1" --json |
    node -e 'console.log(JSON.stringify(JSON.parse(require("fs").readFileSync(0, "utf8"))))'
}
expect() { [ "$(get "$1")" = "$2" ] || fail "$1 is $(get "$1"), want $2"; }
# Piped on stdin, the way `curl | sh` runs it.
install() { env "$@" sh < "$root/install.sh" >/dev/null; }
# OpenClaw rewrites workspace files it cannot parse; a user's clone stays clean.
clean() { [ -z "$(git -C "$ws" status --porcelain)" ] || fail "install changed the checkout: $(git -C "$ws" status --porcelain)"; }

echo "fresh install clones into ~/bluepencil"
install
openclaw config validate >/dev/null || fail "config does not validate"
expect agents.entries.bluepencil.workspace "\"$ws\""
expect agents.entries.bluepencil.identity '{"name":"bluepencil","emoji":"✏️"}'
expect tools.agentToAgent.enabled true
expect tools.agentToAgent.allow '["main","bluepencil"]'
clean

echo "second run changes nothing"
before=$(cat "$HOME/.openclaw/openclaw.json")
install
[ "$(cat "$HOME/.openclaw/openclaw.json")" = "$before" ] || fail "rerun changed openclaw.json"
clean

echo "keeps existing callers and adds new ones"
openclaw config set tools.agentToAgent.allow '["main","sales"]' >/dev/null
install BLUEPENCIL_CALLERS="ops, writer"
expect tools.agentToAgent.allow '["main","sales","ops","writer","bluepencil"]'

echo "ok"
