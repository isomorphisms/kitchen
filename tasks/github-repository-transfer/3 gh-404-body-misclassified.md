# Candidate 3: gh 404 JSON body was mistaken for an existing repository

On 2026-10-09 the user ran the pinned ten-repository C67 batch after installing the Cat Food AArch64 Grease runtime. The batch stopped during preflight before any mutation with:

`destination already exists before transfer: {"message":"Not Found",...,"status":"404"}`

The previous fixture emitted its fake 404 only on stderr. Real `gh api` on this Termux/GitHub CLI path emitted the REST error JSON on stdout while also returning nonzero. The code used `$(gh api ... || true)`, erased the exit status, preserved the JSON text, and then interpreted that nonempty text as a repository name. The same pattern existed in candidate 3's destination checks and polling loop.

Candidate 4 preserves candidate 3 and changes the contract:

- a failed destination lookup is classified by the returned GitHub error body;
- only a GitHub Not Found / status 404 response means the destination is absent or still pending;
- a different API error fails closed before mutation;
- successful destination responses still require canonical name and immutable repository ID;
- polling clears 404 bodies instead of treating them as names or IDs;
- final diagnostic source lookup remains informational only.

The fixture now reproduces the actual stdout 404 JSON and includes a 403/non-404 control that must be rejected before POST. This incident stopped in batch preflight; no repository transfer was attempted.

Related: Kitchen #43, Kitchen #44, Flexible Pipes #55.
