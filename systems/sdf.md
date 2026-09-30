# SDF shell account

This note is intentionally conservative until more of the host is probed and
recorded.

Known workflow facts:

- Do not assume the same home-directory layout used on Android.
- Do not invent `~/bin` or another conventional directory if the session has
  established a different layout.
- Preserve the user's actual shell configuration and aliases instead of
  rewriting the account into a generic Linux example.
- Treat available commands, package names, filesystem layout, and shell
  implementation as host facts to verify, not assumptions inherited from
  Termux.

Before a mutating SDF command, establish the relevant path and shell state from
the current session or with a read-only probe.

## Mailbox refiling facts established in the SDF session

- The live incoming mailbox is `/var/mail/isomorphisms`.
- The SPEC-LIST archive is `~/Mail/spec-list`.
- The established executable directory for this account is `~/opt/bin`; do not
  substitute `~/bin` or drop the `bin` component.
- A destructive refiler must not infer permission to create an adjacent
  replacement in `/var/mail` merely because the mailbox file itself is
  writable.
- Before the first live move, record the host identity, directory and mailbox
  ownership/modes, free space, and available locking commands with the
  read-only probe in `probes/sdf-mailbox-refile.sh`.
