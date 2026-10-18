# AUTOFILE-API-01 source acceptance procedure

Target: Ubuntu x86_64 GitHub runner or equivalent declared host.

The procedure receives exact clean checkouts of the API candidate, independent
ai-ci checker, Kitchen and Ike; an exact ICK compiler; the pinned Grease
executable; and a new owner-private evidence directory.

It must:

1. reject source identity drift and dirty trees before compilation;
2. compile and run the leaf contract through ICK;
3. compile and run the independent ai-ci witness through ICK;
4. verify both ICK toolchain manifests through the shared ai-ci contract;
5. let Ike own dependency order and the digest-bound receipt; and
6. retain hashes without credentials, private response bodies or conversation
   content.

No browser authentication, private endpoint call, conversation move, merge,
release or deployment is permitted.

