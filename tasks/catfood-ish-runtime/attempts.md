# Refusals that improved the candidate

- The first stage-zero artifact checker used implicit errexit inside a
  conditional function call. Modified executable bytes were accepted by the
  test harness. Explicit failure returns now reject damaged payloads, wrong ABI
  and aliases; passing fixture execution was never physical evidence.
- Grease refused ambiguous backslashes, Bash bracket syntax, nested command
  substitution in a condition, and direct parsing of the inherited POSIX
  identity library. Raw strings and explicit intermediate values fix the
  language errors. A narrow command interface invokes the existing identity
  oracle through its actual stage-zero interpreter; the Grease procedure does
  not copy or translate the device table.
- Environment values must be read through Grease's environment interface.
  Shell variable interpolation did not establish the Termux prefix. An actual
  host fixture exposed the refusal before any physical run.
- A corrupt boot file exposed a missing input redirect on the checksum loop.
  The corrected loop reads all six digest records before runtime execution.
- Rewriting both payload and its local checksum record could have evaded a
  self-referential check. The current procedure verifies the cached immutable
  archive and compares the installed record against that archive before
  checking the installed bytes.
- Partial fixture execution exits before receipt publication and preserves
  the install receipt. The two final orchestration runs passed from `/tmp`
  with whitespace in the workspace; their receipts remain synthetic.

The retained `1-test.grease` and its adjacent fixtures record the Kitchen
preparation candidate. Ongoing tests belong to Cat Food's canonical suite.
