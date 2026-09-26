#!/bin/sh
# End-to-end test for install.sh against a real OpenClaw CLI.
# Runs in a throwaway HOME, so your own ~/.openclaw is never touched.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
HOME=$(mktemp -d)
export HOME
trap 'rm -rf "$HOME"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
get() {
  openclaw config get "$1" --json |
    node -e 'console.log(JSON.stringify(JSON.parse(require("fs").readFileSync(0, "utf8"))))'
}
expect() { [ "$(get "$1")" = "$2" ] || fail "$1 is $(get "$1"), want $2"; }
# Piped on stdin, the way `curl | sh` runs it.
install() { env "$@" sh < "$root/install.sh" >/dev/null; }

echo "fresh install from a checkout"
install BLUEPENCIL_DIR="$root"
openclaw config validate >/dev/null || fail "config does not validate"
expect agents.entries.bluepencil.workspace "\"$root\""
expect agents.entries.bluepencil.identity '{"name":"bluepencil","emoji":"✏️"}'
expect tools.agentToAgent.enabled true
expect tools.agentToAgent.allow '["main","bluepencil"]'

echo "second run changes nothing"
before=$(cat "$HOME/.openclaw/openclaw.json")
install BLUEPENCIL_DIR="$root"
[ "$(cat "$HOME/.openclaw/openclaw.json")" = "$before" ] || fail "rerun changed openclaw.json"

echo "keeps existing callers and adds new ones"
openclaw config set tools.agentToAgent.allow '["main","sales"]' >/dev/null
install BLUEPENCIL_DIR="$root" BLUEPENCIL_CALLERS="ops, writer"
expect tools.agentToAgent.allow '["main","sales","ops","writer","bluepencil"]'

echo "clones into a missing directory"
rm -rf "$HOME/.openclaw"
install
[ -f "$HOME/bluepencil/AGENTS.md" ] || fail "no clone at ~/bluepencil"
expect agents.entries.bluepencil.workspace "\"$HOME/bluepencil\""

echo "ok"
