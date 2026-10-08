#!/usr/bin/env python3
"""Fixtures for canonical identity and fail-closed pin preflight."""
from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / "tasks/github-organization-pin-preflight/1.py"
STUB = """#!/usr/bin/env python3
import json
import os
import sys
from pathlib import Path
Path(os.environ["CALLS"]).open("a").write(json.dumps(sys.argv[1:]) + "\\n")
args = sys.argv[1:]
if args == ["auth", "status", "--hostname", "github.com"]:
    if os.environ.get("AUTH_FAIL") == "1":
        print("not logged in", file=sys.stderr)
        sys.exit(1)
    sys.exit(0)
if args[0] == "api" and len(args) == 2 and args[1].startswith("repos/"):
    path = args[1][6:]
    if path == "isomorphismes/wegert":
        print(json.dumps({"id": 1341206906, "full_name": path}))
    elif path == "functorial-games/spinor":
        print(json.dumps({"id": 1407855382, "full_name": path}))
    elif path == "isomorphismes/redirect":
        print(json.dumps({"id": 1407855382, "full_name": "functorial-games/spinor"}))
    else:
        print("not found", file=sys.stderr)
        sys.exit(1)
    sys.exit(0)
print("unexpected invocation", file=sys.stderr)
sys.exit(1)
"""

with tempfile.TemporaryDirectory() as temp:
    home = Path(temp)
    helper = home / "gh"
    helper.write_text(STUB)
    helper.chmod(0o755)
    calls = home / "calls"
    env = {**os.environ, "PATH": str(home) + os.pathsep + os.environ["PATH"], "CALLS": str(calls)}

    def run(*args: str, auth_fail: bool = False):
        calls.write_text("")
        working = {**env, "AUTH_FAIL": "1" if auth_fail else "0"}
        completed = subprocess.run(
            [sys.executable, str(SCRIPT), *args],
            text=True, capture_output=True, env=working, check=False,
        )
        called = [json.loads(line) for line in calls.read_text().splitlines()]
        assert all(call[:1] in (["auth"], ["api"]) for call in called), called
        return completed, called

    ok, called = run("isomorphismes", "isomorphismes/wegert")
    assert ok.returncode == 0, ok.stderr
    report = json.loads(ok.stdout)
    assert report["status"] == "PENDING_UI"
    assert report["mutation_performed"] is False
    assert report["pins_verified"] is False
    assert report["resolved"][0]["id"] == 1341206906
    assert len(called) == 2

    wrong, called = run("isomorphismes", "isomorphismes/wegert,functorial-games/spinor")
    assert wrong.returncode != 0
    report = json.loads(wrong.stdout)
    assert report["status"] == "BLOCKED"
    assert "belongs to another organization" in report["reasons"][0]
    assert len(called) == 3

    moved, _ = run("isomorphismes", "isomorphismes/redirect")
    assert moved.returncode != 0
    assert "resolves to" in json.loads(moved.stdout)["reasons"][0]

    for bad in [
        "isomorphismes/wegert,isomorphismes/Wegert",
        "isomorphismes/wegert;touch-bad",
        "wegert",
        "",
    ]:
        result, called = run("isomorphismes", bad)
        assert result.returncode != 0
        assert not called

    invalid_org, called = run("bad;org", "isomorphismes/wegert")
    assert invalid_org.returncode != 0 and not called

    no_auth, called = run("isomorphismes", "isomorphismes/wegert", auth_fail=True)
    assert no_auth.returncode != 0 and called == [
        ["auth", "status", "--hostname", "github.com"]
    ]

    missing, called = run("isomorphismes", "isomorphismes/missing")
    assert missing.returncode != 0
    assert json.loads(missing.stdout)["status"] == "BLOCKED"

print("Kitchen organization pin preflight: PASS")
