#!/usr/bin/env python3
from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TASK = ROOT / "tasks/github-repository-fork"
CONTRACT = json.loads((TASK / "paste-contract.json").read_text())
RENDERER = TASK / "render-paste-block.py"

assert CONTRACT["schema_version"] == 1
assert CONTRACT["operation"] == "github-repository-fork"
assert CONTRACT["parameters"] == ["source_owner", "repository", "destination_org"]
assert CONTRACT["output_contract"]["form"] == "plain-text-paste-block"
assert CONTRACT["output_contract"]["shell_interpreter_invocation"] is False
assert CONTRACT["output_contract"]["preserve_repository_name"] is True
assert CONTRACT["output_contract"]["clone"] is False

for case in CONTRACT["cases"]:
    p = case["parameters"]
    completed = subprocess.run(
        [sys.executable, str(RENDERER), p["source_owner"], p["repository"], p["destination_org"]],
        capture_output=True,
        check=False,
    )
    assert completed.returncode == 0, completed.stderr.decode()
    assert completed.stdout == case["expected"].encode()
    text = completed.stdout.decode()
    assert " sh " not in f" {text} "
    assert "--fork-name" not in text
    assert "--clone=false" in text
    assert text.count("gh repo fork ") == 1
    assert text.rstrip().endswith("}'")

bad = subprocess.run(
    [sys.executable, str(RENDERER), "bad;owner", "repo", "org"],
    capture_output=True,
)
assert bad.returncode != 0

print("Kitchen GitHub fork paste contract: PASS")
