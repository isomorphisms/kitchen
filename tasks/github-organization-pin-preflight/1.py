#!/usr/bin/env python3
"""Read-only eligibility check for GitHub organization profile pins.

This script NEVER claims to pin repositories. The supported final mutation is
currently performed through GitHub's organization profile UI.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys

COMPONENT = re.compile(r"[A-Za-z0-9_.-]+\Z")
MAX_PINS = 6


def invalid(message: str) -> int:
    print(f"BLOCKED: {message}", file=sys.stderr)
    return 2


def parse(organization: str, raw_repositories: str) -> list[str]:
    if not COMPONENT.fullmatch(organization):
        raise ValueError("unsafe or empty organization")
    repositories = raw_repositories.split(",")
    if not 1 <= len(repositories) <= MAX_PINS:
        raise ValueError("expected between one and six repositories")
    seen: set[str] = set()
    for item in repositories:
        components = item.split("/")
        if len(components) != 2 or not all(COMPONENT.fullmatch(x) for x in components):
            raise ValueError(f"unsafe repository: {item!r}; expected owner/name")
        identity = item.casefold()
        if identity in seen:
            raise ValueError(f"duplicate repository: {item!r}")
        seen.add(identity)
    return repositories


def gh(*args: str) -> str:
    completed = subprocess.run(
        ["gh", *args], text=True, capture_output=True, check=False
    )
    if completed.returncode:
        raise RuntimeError(
            f"gh {' '.join(args[:2])} failed ({completed.returncode}): "
            f"{completed.stderr.strip()}"
        )
    return completed.stdout


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        return invalid("usage: 1.py ORGANIZATION OWNER/REPO[,OWNER/REPO...]")
    organization, raw_repositories = argv
    try:
        repositories = parse(organization, raw_repositories)
    except ValueError as exc:
        return invalid(str(exc))

    try:
        gh("auth", "status", "--hostname", "github.com")
    except (OSError, RuntimeError) as exc:
        return invalid(f"GitHub authentication not usable: {exc}")

    resolved: list[dict[str, str | int]] = []
    reasons: list[str] = []
    for requested in repositories:
        try:
            repo = json.loads(gh("api", f"repos/{requested}"))
            canonical = repo["full_name"]
            repository_id = repo["id"]
            if not isinstance(canonical, str) or not isinstance(repository_id, int):
                raise ValueError("GitHub response omitted canonical name/numeric ID")
            resolved.append(
                {"requested": requested, "canonical": canonical, "id": repository_id}
            )
            if canonical.casefold() != requested.casefold():
                reasons.append(f"{requested} resolves to {canonical}, not itself")
            elif canonical.split("/")[0].casefold() != organization.casefold():
                reasons.append(f"{canonical} belongs to another organization")
        except (OSError, RuntimeError, ValueError, KeyError, TypeError) as exc:
            reasons.append(f"{requested}: cannot establish identity: {exc}")

    status = "BLOCKED" if reasons else "PENDING_UI"
    report = {
        "operation": "github-organization-pin-preflight",
        "organization": organization,
        "requested_order": repositories,
        "resolved": resolved,
        "status": status,
        "reasons": reasons,
        "mutation_performed": False,
        "pins_verified": False,
        "next_step": (
            "Do not transfer a repository without separate authorization."
            if reasons else
            f"Open https://github.com/orgs/{organization}; choose View as: Public, "
            "Customize pins, select the desired repositories, and Save pins. "
            "Check the rendered profile afterward."
        ),
    }
    print(json.dumps(report, sort_keys=True))
    return 2 if reasons else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
