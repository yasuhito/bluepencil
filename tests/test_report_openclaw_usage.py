"""Regression tests for OpenClaw transcript usage collection."""

import datetime
import json
import sqlite3
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools" / "index-bridge"))
from report_openclaw_usage import from_openclaw  # noqa: E402


class OpenClawUsageTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp_dir.cleanup)
        self.db_path = Path(self.temp_dir.name) / "events.sqlite"
        with sqlite3.connect(self.db_path) as db:
            db.execute("CREATE TABLE transcript_events (event_json TEXT, event_zstd BLOB)")

    def add_event(self, event, *, compressed=False):
        text = json.dumps(event).encode()
        blob = subprocess.check_output(["zstd", "-q", "-c"], input=text) if compressed else None
        with sqlite3.connect(self.db_path) as db:
            db.execute(
                "INSERT INTO transcript_events VALUES (?, ?)",
                (None if compressed else text.decode(), blob),
            )

    def test_aggregates_by_day_and_model_and_ignores_other_records(self):
        today = datetime.date.today()
        yesterday = today - datetime.timedelta(days=1)
        old = today - datetime.timedelta(days=3)

        self.add_event({"type": "message", "timestamp": f"{today}T12:00:00", "message": {
            "role": "assistant", "model": "model-a", "usage": {
                "input": 10, "output": 2, "cacheRead": 3, "cacheWrite": 4,
            },
        }})
        self.add_event({"type": "message", "timestamp": f"{today}T12:01:00", "message": {
            "role": "assistant", "model": "model-a", "usage": {"input": 5, "output": 1},
        }})
        self.add_event({"type": "message", "timestamp": f"{yesterday}T12:00:00", "message": {
            "role": "assistant", "model": "model-b", "usage": {"input": 7, "output": 1},
        }})
        self.add_event({"type": "message", "timestamp": f"{today}T12:00:00", "message": {
            "role": "user", "model": "model-a", "usage": {"input": 999},
        }})
        self.add_event({"type": "tool", "timestamp": f"{today}T12:00:00", "message": {
            "role": "assistant", "model": "model-a", "usage": {"input": 999},
        }})
        self.add_event({"type": "message", "timestamp": f"{old}T12:00:00", "message": {
            "role": "assistant", "model": "model-a", "usage": {"input": 999},
        }})
        with sqlite3.connect(self.db_path) as db:
            db.execute("INSERT INTO transcript_events VALUES (?, NULL)", ("not JSON",))

        self.assertEqual(from_openclaw(self.db_path, days=1), {
            str(today): {"model-a": {
                "input": 15, "output": 3, "cache_read": 3, "cache_write": 4,
            }},
            str(yesterday): {"model-b": {
                "input": 7, "output": 1, "cache_read": 0, "cache_write": 0,
            }},
        })

    def test_includes_compressed_assistant_events(self):
        today = datetime.date.today()
        self.add_event({"type": "message", "timestamp": f"{today}T12:00:00", "message": {
            "role": "assistant", "model": "model-a", "usage": {
                "input": 4, "output": 6, "cacheRead": 2, "cacheWrite": 1,
            },
        }}, compressed=True)

        self.assertEqual(from_openclaw(self.db_path, days=1), {
            str(today): {"model-a": {
                "input": 4, "output": 6, "cache_read": 2, "cache_write": 1,
            }},
        })


if __name__ == "__main__":
    unittest.main()
