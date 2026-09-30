# Transfer endpoints

Inherit the [root instructions](../../AGENTS.md) and
[specimen-preservation rules](../AGENTS.md). Read the
[case account](README.md); keep bad evidence unchanged.

Name execution host, source endpoint and destination endpoint separately in
fixtures. Test the wrong-host and unintended self-transfer cases against an
independently specified direction. Use mocked or disposable endpoints; no live
SSH connection, credentials or download is needed to establish this contract.
