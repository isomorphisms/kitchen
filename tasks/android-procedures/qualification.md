# CF-A2-S5 executed qualification — 2026-10-07

Result: BLOCKED for production integration; independently testable Kitchen
candidates completed. No merge, release, service activation or device build.

## Sources and execution

Kitchen retained source ede931c8fc9d95fb91f11c4230de28f1a97030bc was reconciled
with verified live main e614bf52a251d83ad5fbbd9da0d6140293f2293c in an isolated
checkout. Published implementation source is 674d16ec7e8e42a43e979e31fe07f1991979b1d5,
tree f0902c3127f80c5465a4744ae7aae37cceec013c. Build version 3 source is
d1094d889afd219b209ac9078a750168294fcca2, tree
294049bb31b6c6446671d7f187c620fdd49964bb. The local committed build checkout
1f77057780c76d1e8a0ab5c8c854d6b70c958c8f has the same complete tree as that
published source. Archives record both identities; source-tree equality was
verified through GitHub's created tree object, not assumed from prose.

Checked Ithon: 396d8b7af1417a0a61245db940fdb22ef9fbac51, with explicitly
selected /usr/bin/python3 host runtime. The frontend checks before lowering/
execution. Grease source ba869518c7d850de6c47d8c6234654575e264e6c; executed
native inherited YSH backend SHA-256
7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c.
The verified Grease launcher invokes that backend; no generic sh execution is
counted as Grease. Host fixture subprocesses use the AICI bounded native source
at e4723d886658edffd65ffa3d35dc3a2cf83f15ce.

## Executed results

| Check | Executed result | Boundary |
|---|---:|---|
| sh tests/source-handoff.sh | 27 PASS | Existing finite pre-Grease source seam |
| sh tests/ib-durable-store.sh | 22 PASS | Existing source handoff |
| tests/android-diagnostic.pi through checked Ithon | 50 PASS | Preserved v1, two unrelated directories |
| tests/android-diagnostic-2.pi through checked Ithon | 70 PASS | v2, two unrelated directories, fresh state |
| tests/android-procedures.pi through checked Ithon and real Grease wrapper | 324 PASS | 27 cases × 3 operations × 2 routes × 2 directories |
| tests/android-runtime-bundle.pi, retained Cat Food acquisition and delivered native command | 2 PASS | Cached HOST_FIXTURE archive; two fresh directories |
| Build adapter v2 after host guard | 3 FAIL before output | Preserved Grease strict_errexit failure |
| Build adapter v3, committed source | host + A1 + C67 PASS | Off-device cross-build candidates |
| S2/S3/S4 production adapters; Cat Food independent acceptance of new receipts | BLOCKED | No verified predecessor outputs |
| Actual FP registry/dispatch using these new contracts | NOT_RUN | Candidate registered fixture scope only |
| Android installation, runtime availability, replacement, launch, physical capture | NOT_RUN | No phone commands or effects |

The fixture owner admission rejects wrong handset/ABI, stale profile, signer and
downgrade cases before any executor call. These prove refusal propagation, not
the correctness of missing Cat Food policy. URI/path cases prove intact opaque
location propagation. The fixtures also independently reject zero-without-receipt,
changed owner/runtime/payload/input, rewritten owner receipt, failed install,
failed validator, timeout and partial output. All failures remain nonzero through
the identical Grease wrapper. Runtime selectors and Cat Food target overrides in
the ambient environment cannot select different owner bytes or target facts.

Capture covers absent/multiple/disappearing/reused PID, changed APK digest/path,
model-instance/ABI/firmware refusal, task/runtime byte changes, expected version,
stopped service with valid files, authorization/context failure, permission,
partial producer output with nonzero exit, timeout, output bounds, interruption,
empty/irrelevant telemetry and valid weaker observations. Device-state sentinels
are synthetic host fixtures. The channel fixture accepts only finite read-only
commands; none starts services, clears logs, installs or uninstalls packages.

The native bundle test invokes the real retained Cat Food install.sh finite
acquisition seam with a cached exact archive, then executes the delivered native
launcher with hostile Python/Ithon selectors and no source checkout fallback.
The archive is mechanically assembled from committed task/runtime closure and
prebuilt bytes. The old Cat Food package-diagnostic.pi only selects capture.pi,
so it cannot canonically package 2-capture.pi without an S3-owned update. This
host cached acquisition result does not register the archive for either phone.

## Prebuilt bytes and prerequisites

The paired A1/C67 recipe uses NDK r27c API 21, with compiler SHA-256
a871130d810536f7bb924c8aeaff57c66de27bed9b13d0ccafba25fdcc8bd02d and linker
c4a7473d3b8a99a32335616838af2aa85c6333091abeab423be2a905ff5f288c.
This preserves the existing recipe. New ICK-fallback/producer authority remains
S4-owned and BLOCKED; compilation is not authenticated producer acceptance.

| Candidate | Archive SHA-256 | Native launcher SHA-256 | Bounded helper SHA-256 |
|---|---|---|---|
| A1 armeabi-v7a | aaac00938339ae0568f449e3ce64fee960700fe907ffd237264566f506d98616 | 33de3e85178dea456a57e9ecdd3592b73217789888fc1e55831604a66fe1a041 | 7886cf15a871ecf0625073664fd839cd41436756d5e506adf867f7ec931d4698 |
| C67 arm64-v8a | f6c59c352a1ffa9fd9f165cc32c3af720861b2956a7e22067e8c07bbf8cd39cb | fed8632e74849b0263e0a3b52f4cbee493f000bd40eb0d5d651df99c36093c25 | 403c171a8729c15e19d91b88d218112b9727ada09586eecaec6936ecf59eb6d0 |
| Host fixture | 14bb614b703760ad22d3e64aabb5f4952164d8822647ee0733842635d2bec69e | a9c9823cbce76d1fe6ef7405d78f2d328a14c54c6a0871210f4257826de6627f | Recorded in archive CONTENTS.tsv |

A1 binaries inspect as ELF32 ARM with /system/bin/linker; C67 as ELF64 AArch64
with /system/bin/linker64. They are unstripped small candidates; no footprint
optimization or executed ABI is claimed. Each archive carries exact source,
runtime closure and file digests. The Android native launcher requires Python at
its compiled /data/data/com.termux/files/usr/bin/python path, plus the delivered
Ithon closure. Cat Food must independently qualify that runtime location. The
explicit channel and rish DEX remain separate prerequisites; valid files do not
establish a live Shizuku service. No compiler/build tool is a device prerequisite.

## Remaining integration boundary

Replace candidate fixture adapters using verified S2 immutable plan/profile,
S3 acquisition/installation/receipt-validator and S4 exact producer outputs.
Qualify the instance-identity domain, canonical v2 task packager, runtime closure
and both ABI artifacts. Register the exact same owner bytes with actual FP
dispatch and run Cat Food's independent receipt validator. Preserve Kitchen
procedure ownership, Cat Food facts, leaf build semantics and FP repeatable
execution per https://github.com/isomorphisms/catfood/issues/123 . Do not promote
these snapshots, caller digests or declared registration into producer authority.

No owner issue is closed and the existing PR remains parked until those gates
are available. The primary evidence and blockers are reported directly in chat.
