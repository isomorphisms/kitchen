# Typed ARM parser qualification

Origin: https://github.com/isomorphisms/flexible-pipes/issues/228.

Target: observed Ubuntu 24.04 Linux x86_64 disposable build host.
The maintained parser is Idriç. The canonical pinned Idriç bootstrap is a
separate prerequisite; this recipe never replaces it or downloads dependencies.

Require the exact source head, compiler source revision
2734ac5a86610eddfab73b1644d72b4ac85a65ee, real compiler executable, verified
Grease runtime and Ike source a92fe68bf8aad8dfcfe9f7a7abd84e07290f7fe0.
Refuse missing programs, wrong revisions and reused receipt directories before
compiling. Run compilation and the existing real-binary acceptance through
Ike with a Grease recipe interpreter. Retain compiler output, test output,
Ikefile identity and Ike receipt, including failures. A baseline failure stays
a failure. Neither this recipe nor a green parser test claims ISA execution,
independent ai-ci acceptance, full ISA completeness, device behavior or dispatch.

Tests: baseline must expose the archived header failure; repaired candidate
must pass all eight groups and added hostile classification/provenance cases.
Wrong source/compiler/Ike identities and reused output must be refused.
