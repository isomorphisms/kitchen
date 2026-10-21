# Mathieu exact-source host build

Target: Linux x86_64 build host. Input: clean Mathieu checkout at an exact head, qualified native ICK compiler, pinned Ike binary, executable Grease, and a new evidence directory. No phone compilation.

Require: verify source head and cleanliness, compiler and Ike bytes, then use Ike's external Grease recipe runner to compile and execute the actual native engine in Debug and Release. Release must retain test checks with NDEBUG. Record source/material hashes and stage output. Refuse wrong source head, dirty source, wrong compiler, wrong Ike, relative/unsafe paths, or an existing evidence directory before compilation. Do not publish, merge, install or claim independent acceptance.

Compiler bytes correspond to the already materialized ICK host stage; the source pin must be recovered separately for independent acceptance. This producer records the byte identity and does not invent a source-build receipt.
