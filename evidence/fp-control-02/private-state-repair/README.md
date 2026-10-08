# Existing state permission counterexample and repair

The earlier compact producer at `59fc9d004ebbf851da1617929de1885b84f07157`
used `mkdir -p -m 700` to establish private state. That command leaves an existing
directory's mode unchanged. A targeted fresh-session fixture supplied an
existing mode-0777 directory; the old exact paste made one transfer POST and
reported verification. `original-unsafe-observations.json` preserves the
independent API observations. The new negative assertion failed as intended.
No live transfer occurred; the API was the same disposable service.

The maintained generator now checks the directory's executing-user ownership
and mode 0700 before acquisition or any API call. It refuses shared state rather
than silently changing existing permissions. The immutable descriptive transfer
program at `322b4ff634ee745748b209f19e63c472d01e0ae9` remains byte-for-byte
unchanged, SHA-256 `cf85b1dc4caea07749d5070bbc143d669e687820598c36a0050fddccb2612dc6`.

The repaired generator is SHA-256
`470e3c79cd56c2435788baa9405615ac342b20ac2f04046f02fd978d19957302`.
The exact generated Young Tableaux paste is 2,348 bytes, SHA-256
`4ca06c07fdcb4220ca355b84dbc902c2d17bad4b1809d32376dd8237e011b0e0`.
These bytes were emitted by the maintained generator and tested unchanged;
the previously checked paste was not manually edited.

Both fresh Grease and Bash parent diagnostics pass all eighteen independent
API scenarios and all seven acquisition/state negatives. The new mode-0777
fixture makes zero acquisition/API attempts and zero transfer requests, reports
inner exit 2, preserves parent state and survives. The unchanged positive
controls still perform and independently verify exactly one allowed simulated
transfer, then reconcile without resending. An always-refuse implementation
would fail those positives.

The complete standalone artifact is unchanged (6,143 bytes, SHA-256
`7ba9c74e80205f9764f28ffdd429570c83d35d14261b4b0d553c0836684d0774`).
Earlier positive receipts in `../compact-handoff/` remain historical evidence
for their exact producer; they do not establish this newly asserted state
permission requirement. This repair is local Linux fixture evidence, with the
same excluded production, live-transfer, worker-isolation and Android claims.
