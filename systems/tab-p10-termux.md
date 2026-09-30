# TAB_P10 — Termux

Source: Cat Food device notes, especially `isomorphisms/catfood/AGENTS.md`.

Observed 2026-09-18 in Cat Food:

- physical model: `TAB_P10`;
- platform: `sun65iw1p1`;
- architecture: `aarch64`;
- `~/storage/downloads` resolved to Android shared Downloads;
- `~/storage/external-1` was absent;
- no working external SD card had been established;
- shared Downloads rejected direct ELF execution while private Termux storage
  executed the same test binary;
- same-device ADB setup was explicitly deferred.

Do not prescribe the phone's SD-card paths, Shizuku layout, or executable
locations here. Do not turn ordinary on-device tablet work into an ADB setup
task unless that work genuinely requires ADB and the deferred boundary has been
reopened.
