# Candidate 7 did not refuse a destination redirect

Merge review on 2026-10-14 found that `read_destination` returned status 4 for
a different canonical name, but the caller continued toward a transfer POST.
An absent destination (404) and an existing redirect are different states.

Candidate 8 proceeds only after the explicit absent-destination result and
refuses redirects before mutation. AI-CI retains the `destination-redirect`
fixture, which candidate 7 incorrectly transfers and candidate 8 rejects with
zero POSTs. Candidate 7 and its earlier native host receipts remain historical
evidence. Neither version has physical C67 acceptance in this work.
