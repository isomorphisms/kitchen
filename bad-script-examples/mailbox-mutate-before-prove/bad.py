#!/usr/bin/env python3
# INTENTIONALLY BAD. Synthetic reproduction.

import mailbox
from pathlib import Path

source_path = Path("/var/mail/example-user")
archive_path = Path.home() / "Mail" / "selected.mbox"

source = mailbox.mbox(source_path)
archive = mailbox.mbox(archive_path)

for key, message in list(source.iteritems()):
    # Bad policy: a vague body search stands in for a defined selection contract.
    text = message.as_string()
    if "PROJECT-LIST" not in text:
        continue

    # Bad sequencing: mutate destination and then delete source without an
    # independently tested preservation/durability contract.
    archive.add(message)
    source.remove(key)

archive.flush()
source.flush()
