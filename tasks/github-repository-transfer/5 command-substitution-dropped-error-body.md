# Candidate 5: failed command substitution discarded the gh error body

Hosted native-Grease CI run 38002665682 reached candidate 5 and reproduced the normal missing-destination lookup. The `gh` fixture emitted the same JSON shape observed on the user's C67 and returned nonzero.

Candidate 5 wrapped `destination_full=$(gh api ...)` in Grease `try`, then attempted to inspect the captured body. Under this Grease runtime, the failed command substitution did not leave the command's stdout in the assigned variable. The variable was empty, so the fixed-string 404 test could not classify the response.

Candidate 6 preserves candidate 5 and separates the two channels: `gh api` writes stdout to a private temporary file while `try/_error` records success or failure. The file is then inspected for the exact `"status":"404"` marker. Non-404 failures still abort before mutation. This also applies to the post-transfer polling lookups.

No live GitHub mutation occurred in the failing CI run.
