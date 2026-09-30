# Bad script examples

These are intentionally bad examples preserved as regression seeds.

They come from failures in assistant-written terminal instructions and scripts.
Personal names, hostnames, addresses, paths and data have been replaced with
synthetic values. Unless a file explicitly says otherwise, it is a **minimal
reconstruction of the failure class**, not a claim that this exact byte sequence
was the original script.

Do not run these as setup instructions.

Each example should eventually acquire a fixture and test that:

1. reproduces the failure;
2. rejects the bad specimen;
3. accepts a corrected counterpart; and
4. records which Kitchen rule would have prevented it.

## Initial examples

- [`invented-home-bin/`](invented-home-bin/README.md) — guessed a conventional executable directory instead of using observed state;
- [`wrong-execution-host/`](wrong-execution-host/README.md) — generated a transfer/download recipe for the wrong machine and could transfer a host to itself;
- [`python-pasted-as-shell/`](python-pasted-as-shell/README.md) — delivered source in a form that could be pasted directly into a shell and interpreted by the wrong language;
- [`prerequisite-cascade/`](prerequisite-cascade/README.md) — kept mutating after an unverified install/export prerequisite had already failed;
- [`mailbox-mutate-before-prove/`](mailbox-mutate-before-prove/README.md) — combined selection, archival and source deletion before the selection and byte-preservation contract had been tested;
- [`false-green-wrapper/`](false-green-wrapper/README.md) — reported success even when the required inner test never completed successfully.

## Older history recovered

The history sweep currently reaches July 2025.

- [`powershell-static-ip-positional/`](powershell-static-ip-positional/README.md) — July 2025; recovered assistant code let a one-argument IP address bind as the interface name and left the IP parameter empty;
- [`powershell-dhcp-no-elevation-preflight/`](powershell-dhcp-no-elevation-preflight/README.md) — July 2025; privileged network changes began before required rights were established;
- [`shared-storage-assumption/`](shared-storage-assumption/README.md) — December 2025; shared mobile storage was used before its availability/access was established;
- [`abbreviated-git-fetch/`](abbreviated-git-fetch/README.md) — August 2026; an abbreviated commit ID was used where the remote operation required a real ref;
- [`tracking-reference-assumption/`](tracking-reference-assumption/README.md) — August 2026; successful retrieval was mistaken for proof that the local tracking reference needed next existed;
- [`termux-debian-confusion/`](termux-debian-confusion/README.md) — August 2026; Termux, a rootless Linux environment, Android shell and root were treated as interchangeable;
- [`container-layout-assumption/`](container-layout-assumption/README.md) — August 2026; a conventional container home was substituted for the build image's required absolute layout;
- [`double-shell-wrapper/`](double-shell-wrapper/README.md) — August 2026; an extra shell layer violated the container entrypoint's argument contract;
- [`builder-runtime-mismatch/`](builder-runtime-mismatch/README.md) — August 2026; a builder's installed libraries made a smoke test pass although the target runtime lacked one;
- [`android-artifact-path-assumption/`](android-artifact-path-assumption/README.md) — August 2026; CI looked for the package in the wrong part of the build tree;
- [`static-validation-not-device-acceptance/`](static-validation-not-device-acceptance/README.md) — July–August 2026; parser/signature/build checks were reported as stronger target-device evidence than they actually supplied;
- [`missing-input-counted-as-pass/`](missing-input-counted-as-pass/README.md) — August 2026; unavailable evidence was collapsed into successful/complete checker coverage;
- [`grep-q-pipefail-broken-pipe/`](grep-q-pipefail-broken-pipe/README.md) — September 2026; early consumer exit caused the producer to report a broken pipe under pipefail even though the sought symbol existed.

[`history-sweep-status.md`](history-sweep-status.md) records the current historical search boundary.

Related tracking work is in Kitchen issues #1–#11.

## Working here

Read the [root instructions](../AGENTS.md), [local instructions](AGENTS.md)
and each case's README and AGENTS before editing. Return to the
[Kitchen map](../README.md) for fixtures, tests and incident records.
