# Android handset identity and download-path assumption

Evidence date: October 6, 2026.

During a physical APK sideload diagnostic, the user reported being on a
`MIRO A1`. Multiple physical A1 handsets existed in the working context, but
the generated follow-up treated the model name as if it uniquely identified
which handset was active. The same follow-up also guessed that the downloaded
APK lived under `/sdcard/Download`.

Both assumptions were unjustified.

## Failure modes

### Model class mistaken for physical instance

A model label such as `MIRO A1` is not a unique device identifier. Scripts and
instructions that depend on the exact handset must not silently select one
same-model unit from prior context.

### Download event mistaken for a path

A file made available by an Android app can arrive through a content provider,
app-private storage, emulated shared storage, Downloads, or another
user-selected location. No generic “downloaded” event proves
`/sdcard/Download`.

The string `/sdcard` also must not be described as evidence of a physical
removable SD card; on Android it commonly resolves to emulated shared storage.

## Regression rule for pasteable scripts

A human-facing script that consumes a recently downloaded Android file must do
one of the following:

1. accept an explicit path/URI supplied by the current context;
2. discover candidate files using a mechanism justified for the current app
   and authority, display the candidate(s), and operate only on the resolved
   object; or
3. stop with a bounded message that the location is unresolved.

Do not manufacture a default path merely to avoid asking or discovering.

Likewise, when the command depends on a particular physical handset, require or
derive current-instance evidence rather than using the model name as identity.

## Related prior regression

This is a recurrence and strengthening of
`bad-script-examples/shared-storage-assumption/`: the earlier case concerned
unchecked shared-storage availability. This incident additionally covers
invented download locations and same-model handset ambiguity.
