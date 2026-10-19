# Material-bound A1 preparation

This is the Kitchen consumer for Cat Food's
`catfood-android-profile-request-v1` interface. It prepares four fixed actions:
the maintained temporary source test, a repeatable read-only freshness check, a
bounded diagnostic capture, and the already-known export-copy mutation. It is
not a registry or an Android installer.

The consumer requires absolute input paths and exact bytes for the Cat Food
request and profile, the accepted AICI projection, Kitchen's repaired A1 mirror,
K04 source-handoff version 2, and one task-local material file. The material file
uses `kitchen-a1-preparation-material-v1`. A current observed or derived fact
must name an absolute evidence file and its SHA-256. Preferences, historical
facts, unknowns, and deferred facts cannot establish target state.

The Cat Food request must retain:

- AICI PR #285 head `cdf6f09dda2828e4d463dab202d66175397dbbd4`;
- Cat Food PR #143 head `7f4a3707a63812af1039ad80aea8ad7e86983670`
  and the exact approved-obligation interface digest;
- Kitchen PR #65 head `ba7f651e89ae25e831613c8c3fee2f15f73baa54`
  and the exact `tasks/source-handoff/2.sh` SHA-256; and
- checked Ithon revision `d6e83969f82512e920fb17b44326cb54f31d015c`.

The AICI projection must contain the authoritative
`req-grease-non-cxx` correction. Changing the request, profile, relevant
material, mirror, correction, or adapter invalidates the preparation receipt.

Missing export or Shizuku readiness blocks only the dependent diagnostic/copy
actions and emits a named read-only probe. Source-test preparation remains
eligible when its own exact host, checkout path, revision, and adapter bindings
are present. A repeated freshness check is eligible; a completed export copy
without a new named cause is blocked before effects.

The receipt is source/control evidence. It does not establish physical identity,
current authority, service behavior, target execution, installation, or device
acceptance.
