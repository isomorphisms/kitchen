# Agent instructions: probes

Inherit the [root instructions](../AGENTS.md) and all intervening directory rules.

Follow this folder's [README](README.md). Probe only the missing fact in the
named target context, using bounded read-only operations. State what evidence
the probe establishes, what output is needed and how errors remain distinct.

Do not install packages, create paths, change permissions or cross a privilege
boundary as an incidental probe. Avoid secrets and unnecessary private output.
Record actual results and dates in the relevant scoped evidence, not invented
success. A tool's absence, permission denial and unsupported option must not be
collapsed into the same diagnosis. Test probe failures with disposable inputs
where possible; a simulated result is not a live observation.
