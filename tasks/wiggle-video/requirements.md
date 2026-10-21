# WIGGLE-VIDEO-01, candidate 1

Target: offline Linux host execution. No Android or physical-device claim.

The common driver must validate a data-only typed timeline before invoking an
application adapter. Clock time is rational mathematical time, never render
wall time. Every requested frame and every same-time event is retained.
Scalar/vector coordinates permit linear or held values; gestures and discrete
operations are ordered events; sample indices are source sampled integers.
Missing initial values, nonfinite/out-of-range values, unknown controls,
ambiguous ordering and invalid interpolation must fail before rendering.

An adapter receives the evaluated timeline and must run its actual application
engine and renderer, writing contiguous zero-based PPM frames and exact state
checkpoints. The common driver never draws mathematical objects. Source inputs,
adapter executable, source revisions, input digests, evaluated timeline, frame
hashes and backend identity must be retained. No new encoder is permitted:
the exact pinned movie-from-stills/build.sh and 1.sh assemble the MP4.

An existing output directory must be refused. Failed/interrupted attempts must
retain their inputs and failure state. Independent AI-CI must open actual source
frames and decode the actual video, reject changed inputs, frame gaps/reordering,
hash/source mismatches, constant output, invalid timing and encoder failures.
Domain-specific state correctness additionally requires an app-owned oracle;
generic media verification must not certify mathematics or physical execution.

Tests: independently specified boundary values, equal-time event ordering,
fractional fps, held values, forbidden event interpolation, nonfinite input,
out-of-range input, stale/changed input, missing/extra frame, first/last state,
rerun preservation, rejected adapter/encoder and decoded-video verification.
