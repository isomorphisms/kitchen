#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from typing import Any
from urllib.parse import quote, urlencode
from urllib.request import Request, urlopen

SEARCH = "https://archive.org/advancedsearch.php"
DETAILS = "https://archive.org/details/"
DEFAULT_FAVORITES = "fav-isomorphismes"


def quoted(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def base_query(title: str | None, author: str | None) -> str:
    terms = ["mediatype:texts"]
    if title:
        terms.append(f'title:("{quoted(title)}")')
    if author:
        terms.append(f'creator:("{quoted(author)}")')
    return " AND ".join(terms)


def search_url(query: str, rows: int) -> str:
    params = [
        ("q", query),
        ("fl[]", "identifier"),
        ("fl[]", "title"),
        ("fl[]", "creator"),
        ("fl[]", "year"),
        ("rows", str(rows)),
        ("page", "1"),
        ("output", "json"),
    ]
    return SEARCH + "?" + urlencode(params, quote_via=quote)


def fetch(url: str, timeout: float) -> list[dict[str, Any]]:
    request = Request(url, headers={"User-Agent": "isomorphisms-kitchen-book-lookup/1"})
    with urlopen(request, timeout=timeout) as response:
        payload = json.load(response)
    docs = payload.get("response", {}).get("docs", [])
    return docs if isinstance(docs, list) else []


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Search Internet Archive and return canonical /details links"
    )
    parser.add_argument("--title")
    parser.add_argument("--author")
    parser.add_argument("--rows", type=int, default=10)
    parser.add_argument("--timeout", type=float, default=20.0)
    parser.add_argument("--favorites", default=DEFAULT_FAVORITES)
    parser.add_argument("--no-favorites", action="store_true")
    parser.add_argument(
        "--plan-only",
        action="store_true",
        help="emit the exact query URLs without network access",
    )
    args = parser.parse_args()

    if not args.title and not args.author:
        parser.error("provide at least one of --title/--author")
    if args.rows < 1 or args.rows > 50:
        parser.error("--rows must be between 1 and 50")

    core = base_query(args.title, args.author)
    planned: list[dict[str, str]] = []
    if not args.no_favorites and args.favorites:
        planned.append(
            {
                "scope": "favorites",
                "url": search_url(f"collection:{args.favorites} AND {core}", args.rows),
            }
        )
    planned.append({"scope": "all", "url": search_url(core, args.rows)})

    if args.plan_only:
        print(json.dumps({"provider": "internet-archive", "queries": planned}, indent=2))
        return 0

    results: list[dict[str, Any]] = []
    seen: set[str] = set()
    for plan in planned:
        for doc in fetch(plan["url"], args.timeout):
            identifier = doc.get("identifier")
            if not isinstance(identifier, str) or not identifier or identifier in seen:
                continue
            seen.add(identifier)
            results.append(
                {
                    "scope": plan["scope"],
                    "identifier": identifier,
                    "title": doc.get("title"),
                    "creator": doc.get("creator"),
                    "year": doc.get("year"),
                    "url": DETAILS + quote(identifier, safe=""),
                }
            )

    print(
        json.dumps(
            {
                "provider": "internet-archive",
                "queries": planned,
                "results": results,
            },
            indent=2,
            ensure_ascii=False,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
