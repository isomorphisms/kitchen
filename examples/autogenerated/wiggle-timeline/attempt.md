# Typed time-indexed inputs

Values: nonnegative rational seconds, positive rational frames/second, finite
control coordinates with units and bounds, ordered event words, source sample
indices, source/executable identities and rendered frames.

`interpolation_allowed : control_kind → interpolation → Bool` keeps discrete
actions out of linear interpolation. Planning maps a validated trace to a
sequence of frame times, current held/interpolated values, and ordered events
since the previous frame. An adapter maps that plan through an existing engine
to numbered frames and app-defined checkpoints. Orchestration effects include
filesystem snapshots, subprocess execution, hashing and media inspection.

The Idriç slice below is a real finite type/rule program, not a movie renderer.
Compiler source: isomorphisms/Idric 0e8cfdd1106ebdeffd01b6c519880ea3afc7dc35.
The local compiler was initially absent; exact repository bootstrap is being
attempted. Execution result is NOT_RUN until a compiler receipt is recorded.
The host process/filesystem/media orchestration is separately checked Ithon,
following FP's existing maintained frontend boundary; its success does not
establish Idriç execution. No Python or Bash implementation is introduced.

First language boundary: a qualified Idriç host distribution with process,
hashing and incremental file interfaces for this complete driver. A removal
test for the Ithon orchestration must reproduce the same timeline and reject
all malformed/changed-source fixtures through Idriç's own executable.
