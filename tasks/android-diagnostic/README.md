# A1 diagnostic preparation

Run the checked-Ithon consumer with absolute paths:

```text
ithon tasks/android-diagnostic/prepare.pi prepare \
  --profile-request /absolute/request.tsv \
  --profile /absolute/profile.tsv \
  --requirements /absolute/aici-projection.tsv \
  --material /absolute/material.tsv \
  --mirror /absolute/kitchen/systems/miro-a1-termux.md \
  --source-handoff /absolute/kitchen/tasks/source-handoff/2.sh \
  --output /absolute/preparation.tsv
```

Use `verify` with the same inputs and existing output before relying on a
prepared action. Read [requirements.md](requirements.md) first.

The task-local material file begins with
`# kitchen-a1-preparation-material-v1`, selects one of the four fixed actions,
and records facts as:

```text
meta<TAB>selected_action<TAB>diagnostic-capture
fact<TAB>NAME<TAB>CLASS<TAB>STATE<TAB>VALUE<TAB>ABSOLUTE_EVIDENCE_PATH<TAB>SHA256<TAB>REVISION
```

Observed and derived current facts require evidence bytes. Unknown or deferred
facts use `-` for both evidence fields. The preparation emits action-specific
blockers and keeps unrelated eligible actions visible.
