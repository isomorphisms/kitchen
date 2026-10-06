#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from urllib.parse import quote, urlencode

BASE = "https://www.abebooks.com"


def clean_isbn(value: str) -> str:
    cleaned = re.sub(r"[^0-9Xx]", "", value)
    if len(cleaned) not in (10, 13):
        raise SystemExit("ISBN must contain 10 or 13 digits/X characters")
    return cleaned.upper()


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Build the user's direct AbeBooks used-book lookup URL"
    )
    parser.add_argument("--title")
    parser.add_argument("--author")
    parser.add_argument("--isbn")
    args = parser.parse_args()

    if args.isbn:
        isbn = clean_isbn(args.isbn)
        print(f"{BASE}/book-search/isbn/{quote(isbn, safe='')}/used/")
        return 0

    if not args.title and not args.author:
        parser.error("provide --isbn or at least one of --title/--author")

    params: list[tuple[str, str]] = [
        ("cm_sp", "SearchF-_-home-_-Results"),
        ("ref_", "search_f_hp"),
        ("sortbyp", "17"),
        ("sts", "t"),
    ]
    if args.author:
        params.append(("an", args.author))
    if args.title:
        params.append(("tn", args.title))

    query = urlencode(params, quote_via=quote)
    print(f"{BASE}/servlet/SearchResults?{query}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
