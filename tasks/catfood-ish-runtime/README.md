# Cat Food Ish runtime preparation

The requirements were recorded before implementing the physical acceptance
candidate. Canonical implementation and regression fixtures live together in
`isomorphisms/catfood`:

- `android/acceptance/ish-installed.grease`
- `tests/ish-acceptance-fixtures.grease`
- `tests/fixtures/ish-runtime/`

This directory retains the preparation contract and historical fixture
candidate. It is not a competing delivery registry or current device adapter.
Run the canonical fixture suite through the verified Grease entrypoint, supplying
an absolute Cat Food control checkout. It runs twice outside that checkout and
uses a workspace containing whitespace. Fixture receipts remain private scratch
data and are never submitted as physical evidence.

Verified on Ubuntu 24.04 x86-64 using Grease packaging source
`9a874c4e082d26f21b2cc807b5553e7e19d5f590`, inherited implementation
`5651cf97a1b5042f24f14112a7ade9a1518eb0bc`, workflow artifact 11419782646,
ZIP SHA-256 `71e679fef031225716bbb4d6ea140ab17e9d44e7aa6bd4964e7bccbbed6ce323`.
The implementation executable's historical filename is `ysh`; the verified
consumer-facing entrypoint used for these runs is `grease`.

Passing tests: override refusal, contradictory identity, another instance,
changed payload, changed payload and digest record together, partial runtime
failure, and two positive orchestration runs. The pinned archive seals the
digest record; a mutable local checksum file cannot authorize changed binaries.
The installation receipt stayed byte-identical in every case.

Prepared physical action source SHA-256:
`0c4a6e3c094a233559934b3103b1787e87ebb8aa64a37b831ee8807ba7a0fa84`.
Canonical fixture source SHA-256:
`f0bdfe55c93b13cb916d7b669d471197110b1c04ba38fd1f00b1df4f824ab3a5`.

No actual A1, C67 or TAB_P10 runtime was executed here. The action requires
the installed workspace to be observed on that exact device. It does not borrow
A1 storage, Shizuku, SD-card or ADB facts for the other devices.
