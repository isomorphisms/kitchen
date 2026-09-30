# Mailbox mutation before the contract was proved

## Failure

Several distinct questions were collapsed into one script:

- what mailbox is the real source;
- what exactly counts as a selected message;
- whether matching belongs in headers or body;
- what mailbox format and envelope behavior must be preserved;
- whether the operation is inspect, copy or move;
- when an archived message is durable enough to permit source deletion; and
- how interruption, restart and concurrent delivery behave.

The synthetic specimen deliberately searches serialized message text and removes
source records immediately after an archive API call.

## Regression

Use disposable mailboxes only. Expected selected message identities and byte
behavior must be specified independently of the implementation. Copy/move intent
must be explicit, and source deletion must not occur merely because an
intermediate append call returned.

Related: Kitchen issues #7, #8 and #11.
