# IB-U8-E1 native reader build handoff

This Kitchen task is the receiver for the Flexible Pipes reader-build
assignment. It is deliberately a preflight and handoff contract, not a second
browser implementation and not an APK publication path.

The authoritative material bundle is `materials.tsv`. Its source pins reconcile
the existing Material reader, direct-DEX migration, the URL/Arena requirement,
ICU metadata, PFD ownership, typed Prepaint, Binder ingress, and the additive
Arena promotion. A worker must read the bundle literally and reject a missing,
different, or unmaterialized source instead of selecting a newer branch.

## Required sequence

1. Flexible Pipes composes the checked `IB-U8-E1` assignment after its Ike
   preflight has checked the material bundle. Composition is not delivery. The
   pipeline must stop at `AWAITING_HANDOFF_DELIVERY` until a trusted,
   human-visible Kitchen delivery adapter records the same literal assignment.
2. Kitchen begins only from that visible assignment and retains the FP stage,
   payload, and AI-CI blocked-receipt identities. A GitHub commit, issue, or
   local file is not a dispatched job.
3. Before a package build, materialize one exact IB source tree that contains
   the admitted ICU metadata/PFD source and typed Prepaint integration. Its
   real `NativeSourceProjection` must emit direct DEX. The known `_builtin.NIL`
   collection/record rejection is a hard blocker, not permission to substitute
   Java, Gradle, RefC, C++, or a separate document model.
4. Use the pinned Idriç and Android-NDK candidates through the pinned checked
   ICK route. Grease source is pinned, but a missing checked Grease runtime is
   a `BLOCKED_GREASE_RUNTIME` result; do not bootstrap or replace it with a
   shell implementation.
5. Build only after the previous gates. The package identity must remain
   `org.isomorphisms.ib.prepaint` with the listed test certificate. Replacement
   evidence requires two distinct APK bytes, a nondecreasing versionCode, and
   a same-package/signer replacement with no uninstall. A new signer or
   package name is rejected.
6. Keep ARM32 and ARM64 build/ART evidence distinct from physical acceptance.
   MIRO A1 is the primary `armeabi-v7a` consumer; MIRO C67 is the paired
   `arm64-v8a` consumer. A C67 receipt must identify the physical instance and
   cannot be inferred from an emulator, A1, or a compatible byte stream.

The Android manifest must request no network permission and no root access;
first-party Java/Kotlin/Gradle application code remains forbidden. Platform
signing metadata tooling is not Java application code. The reader owns no
direct fetch path: ICU runs behind the authorized worker and private
Binder/PFD/Arena boundary.

## Required rejection controls

The preflight and independent receipt verifier must reject a wrong source,
compiler, manifest hash, package, signer, version policy, source epoch, or
tampered job/artifact. A command that uses `tee` in a way that could hide a
nonzero producer status is rejected before work starts. No APK SHA exists until
a real package build has passed all of these gates.

## Current result

`NativeSourceProjection` does not yet emit direct DEX for the retained source
collections and records. Therefore this task currently permits only the
source-pinned preflight and the visible-delivery handoff; it does not build,
sign, install, release, or claim an APK.
