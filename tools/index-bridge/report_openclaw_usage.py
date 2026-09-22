#!/usr/bin/env python3
"""Report an OpenClaw agent's token usage to the AI Worth Using Agent Index.

The stock client (agent_index_client.py, vendored next to this file) reads
Hermes' state.db and agentsview. OpenClaw keeps transcripts in SQLite
(~/.openclaw/agents/<agent>/agent/openclaw-agent.sqlite, table
transcript_events), which neither collector knows. This script reuses the
client's auth, state, and wire format, and swaps in an OpenClaw collector.

The Index replaces each (day, model) total with what we send, so every run
recomputes the full window from the store; nothing is deltaed or ledgered.

Usage:
  report_openclaw_usage.py --agent bluepencil [--days 28] [--dry-run]
  report_openclaw_usage.py --agent bluepencil --db PATH

Auth: a registered install (see `agent_index_client.py --register`) keeps its
report key in ~/.agent-index/.agent-index.json; nothing else is needed here.
"""
import argparse
import datetime
import json
import sqlite3
import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import agent_index_client as aic  # noqa: E402

KEYS = aic.KEYS  # ("input", "output", "cache_read", "cache_write")


def default_db(agent: str) -> Path:
    return Path.home() / ".openclaw" / "agents" / agent / "agent" / "openclaw-agent.sqlite"


def _day(ts) -> str | None:
    """Local calendar day of an event timestamp (ISO string or epoch ms)."""
    if ts is None:
        return None
    try:
        if isinstance(ts, (int, float)):
            dt = datetime.datetime.fromtimestamp(ts / 1000 if ts > 1e11 else ts)
        else:
            dt = datetime.datetime.fromisoformat(str(ts).replace("Z", "+00:00")).astimezone()
        return dt.date().isoformat()
    except (ValueError, OverflowError, OSError):
        return None


def from_openclaw(db_path: Path, days: int):
    """date -> model -> counters, from the OpenClaw transcript store."""
    window = (datetime.date.today() - datetime.timedelta(days=days)).isoformat()
    today = datetime.date.today().isoformat()
    out = defaultdict(lambda: defaultdict(lambda: dict.fromkeys(KEYS, 0)))
    con = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    try:
        cur = con.execute("SELECT event_json FROM transcript_events")
        for (event_json,) in cur:
            try:
                ev = json.loads(event_json)
            except json.JSONDecodeError:
                continue
            if ev.get("type") != "message":
                continue
            msg = ev.get("message") or {}
            if msg.get("role") != "assistant":
                continue
            usage, model = msg.get("usage"), msg.get("model")
            if not usage or not model:
                continue
            day = _day(ev.get("timestamp") or msg.get("timestamp"))
            if day is None or day < window:
                continue
            day = min(day, today)
            acc = out[day][str(model)]
            acc["input"] += int(usage.get("input") or 0)
            acc["output"] += int(usage.get("output") or 0)
            acc["cache_read"] += int(usage.get("cacheRead") or 0)
            acc["cache_write"] += int(usage.get("cacheWrite") or 0)
    finally:
        con.close()
    return {d: v for d, v in out.items() if any(any(m.values()) for m in v.values())}


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--agent", default="bluepencil")
    ap.add_argument("--db", type=Path)
    ap.add_argument("--days", type=int, default=28)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    db_path = args.db or default_db(args.agent)
    if not db_path.exists():
        print(f"error: sqlite store not found: {db_path}", file=sys.stderr)
        return 2

    aic.use_index()
    aic.purge_unusable_token()
    headers = aic.auth_headers()  # exits if this install never registered

    payload = {"days": aic.merge(from_openclaw(db_path, args.days))}
    total = sum(m[k] for d in payload["days"] for m in d["models"] for k in KEYS)
    print(f"  agent={args.agent} days={len(payload['days'])} tokens={total:,}")
    if args.dry_run:
        print(json.dumps(payload, indent=1)[:2000])
        return 0
    if not payload["days"]:
        aic._post(f"{aic.API}/v1/usage?agent_id={args.agent}", {"days": [], "status": "pending"}, headers)
        print("  nothing to report yet")
        return 0
    code, body = aic._post(f"{aic.API}/v1/usage?agent_id={args.agent}", payload, headers)
    print(f"  {code} {body}")
    return 0 if code == 200 else 1


if __name__ == "__main__":
    sys.exit(main())
