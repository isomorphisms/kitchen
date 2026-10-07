# Predecessor boundary

Live sources checked on 2026-10-07:

* Kitchen main e614bf52a251d83ad5fbbd9da0d6140293f2293c; retained PR 29
  ede931c8fc9d95fb91f11c4230de28f1a97030bc.
* Cat Food retained PR 111 a1d36ee45b66a1af86d7594cc18df889610d5c81
  and parent PR 112 fffa3c9ae49b954a447608642f9597dc428427ab:
  profile is A1-only, instance can be declared, and delivery reports installation
  NOT_RUN. Positive authenticated delivery is blocked.
* AICI retained PR 211 e4723d886658edffd65ffa3d35dc3a2cf83f15ce:
  independent producer deployment/isolation and signing remain blocked.
* Audited integration snapshots: Cat Food
  609a9628d5a52860f956bf62e0914a0cd03292ae, Flexible Pipes
  c8cb7ac069a798eaf6cc228de9a2c23b2b351587, AICI
  8bf8be153f792c4def251287ed85543d1fe24f07.

No verified CF-A2-S2/S3/S4 successor appeared during live lookup. These snapshots
are provenance, not substitutions for predecessor acceptance. Version 1 is a
HOST_FIXTURE adapter protocol only. Replace this boundary in a new numbered
version after inspecting those outputs; do not enable production with a flag.

Required packages are prebuilt Grease, checked Ithon plus its declared Python
runtime, bounded-process, the selected channel runtime and (for rish) verified
DEX files. File validity does not establish Shizuku service/authorization.
Android build tools are never runtime prerequisites.

Cat Food issue 123 keeps repeatable producer execution in Flexible Pipes:
https://github.com/isomorphisms/catfood/issues/123 . Kitchen supplies the same
maintained owner bytes to its manual and registered consumers; no copy of FP
producer logic, installer or hardware inventory is introduced here.
