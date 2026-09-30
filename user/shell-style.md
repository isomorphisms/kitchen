# Shell and command style

- Prefer full, readable words where practical instead of cryptic historical
  abbreviations.
- Existing preferred vocabulary includes forms such as `list`, `copy`,
  `move`, `process`, and `erase --yes` where the relevant shell/tooling
  provides them.
- Prefer Grease/YSH for first-party shell work when applicable.
- Do not silently translate a Grease/YSH request back into generic Bash or
  POSIX-shell idiom merely because it is familiar.
- Keep commands small enough that a failure identifies the broken assumption.
- For a sequence of mutations, verify state between meaningful steps.
- Do not rely on a preliminary `cd` supplied by the human; scripts should
  resolve their own working location or use explicit verified paths.
