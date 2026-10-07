# Version 2 qualification history

Version 1 preserved its bounded observation behavior, but task digest validation
occurred after output creation, and unknown model/firmware profiles could pass.
The instance label was copied rather than checked against a current uniquely
scoped property. ABI and expected application version were not required.

Version 2 has requirements and new hostile fixtures for those cases. Initial
checked-Ithon runs rejected two unannotated method-result comparisons before
executing any scenario. All 68 attempted cases correctly remained FAIL in the
saved first/second ledgers. Explicit bool/string bindings repaired the checked
source. No Python fallback or unchecked Ithon execution was used.

The original build adapter supports A1 only. The separately versioned off-device
adapter adds arm64-v8a, accepts an explicit NDK root and preserves the verified
r27c compiler/linker digests. The same maintained native launcher and independent
AICI bounded-process source remain the runtime recipes. Its NDK path is a
preserved recipe, not fresh S4 ICK-fallback authorization. Both Android builds
remain CROSS_BUILD_ONLY; package registration and physical behavior are blocked.

`ro.serialno` is the candidate identity domain, explicitly required in the input
profile. Inaccessible/empty/unknown values fail; this is not a claim that either
phone exposes that property through current rish. Cat Food must choose and
qualify an appropriate instance domain in S2 before production integration.
