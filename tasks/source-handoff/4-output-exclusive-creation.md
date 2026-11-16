# K01 preparation output creation

Observed 2026-11-16 on a disposable Linux x86_64 host, continuing the maintained
adapters integrated by Kitchen PR #66, "Bind Kitchen preparation to exact
material context," and PR #67, "Bind served candidates to executed controls."
Baseline source: `739faa3068983531a04db33b3ecc43573272368e`.

Both `tasks/android-diagnostic/prepare.pi` and `qualify.pi` checked
`output.exists()` and then called `write_bytes()`. A dangling output symlink
appears absent to `exists()`. The subsequent write followed it and created a
receipt at its unintended target. Separate checked-Ithon regressions reproduced
the failure in both adapters: each reported "dangling ... symlink unexpectedly
passed." An existing output could also appear between that check and the write.

The maintained descriptive adapters now open the output with exclusive binary
creation (`xb`). The operating system refuses every existing final path,
including a dangling symlink, without following or replacing it. A competing
creator receives the existing `OUTPUT_ALREADY_EXISTS` refusal. The original
numbered shell candidates and historical qualification records are unchanged.

Actual checked-Ithon host verification at revision
`d6e83969f82512e920fb17b44326cb54f31d015c` passed:

- 19 material-bound preparation controls;
- 17 exact requirement/control qualification cases;
- existing file bytes and both dangling/existing-target symlinks remain intact;
- two actual child processes contending for one output admit exactly one writer
  and preserve the admitted receipt bytes.

Both suites execute from an unrelated directory containing whitespace and
retain fresh-output/repeat verification. The maintained source qualification
workflow now executes both suites. These results concern output creation on the
host; they do not establish production AICI authority, managed Grease closure,
device execution or live effects. This repair does not claim protection against
replacement of an output's parent directory or complete publication after a
process is interrupted during writing.
