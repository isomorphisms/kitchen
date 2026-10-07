#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys

COMPONENT = re.compile(r"^[A-Za-z0-9_.-]+$")


def checked(value: str, label: str) -> str:
    if not COMPONENT.fullmatch(value):
        raise SystemExit(f"unsafe GitHub {label}: {value!r}")
    return value


def render(source_owner: str, repository: str, destination_org: str) -> bytes:
    source_owner = checked(source_owner, "source owner")
    repository = checked(repository, "repository")
    destination_org = checked(destination_org, "destination organization")
    source = f"{source_owner}/{repository}"
    destination = f"{destination_org}/{repository}"
    lines = [
        "gh auth status --hostname github.com",
        f"gh repo fork {source} --org {destination_org} --clone=false",
        (
            f"gh api repos/{destination} "
            "--jq '{full_name, fork, parent: .parent.full_name, source: .source.full_name}'"
        ),
    ]
    data = ("\n".join(lines) + "\n").encode("utf-8")
    if b" sh " in b" " + data + b" " or data.startswith(b"sh "):
        raise SystemExit("refusing shell-interpreter invocation")
    return data


def main() -> int:
    parser = argparse.ArgumentParser(description="Render Kitchen's GitHub fork paste block")
    parser.add_argument("source_owner")
    parser.add_argument("repository")
    parser.add_argument("destination_org")
    args = parser.parse_args()
    sys.stdout.buffer.write(render(args.source_owner, args.repository, args.destination_org))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
