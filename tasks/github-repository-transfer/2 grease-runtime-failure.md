# Candidate 2: shell-compatible fixtures did not qualify Grease

On 2026-10-09 the user installed the Cat Food ARM64 Grease package on a MIRO C67. Archive SHA-256: 3ddb962ef313e528e525fa03518f494577e921c2201ecb49f7a11f2fbf4e82b2; source 8052868773077602266d80bf39aad6998e2da749. The FP wrapper failed at line 14: '[' should be invoked as 'test' (simple_test_builtin). This attempt stopped before a transfer POST.

Requirements were fixed before qualification: retain Kitchen generation and FP execution, preserve candidate 2, use real Grease defaults without disabling safety options, and test positive/negative outcomes with a fake GitHub, not a fake interpreter. The exact three-repository batch must POST once per repository and never POST again on a completed rerun. Work outside the checkout and with whitespace in paths.

A bracket-only fix exposed additional failures in native Grease: nested command substitutions in conditionals; assignments/functions in errexit-disabled conditions; reading environment entries as shell locals; unset/export rather than ENV mutation; the ':' builtin; and POSIX arithmetic in the verification loop. Merely replacing '[' would therefore have exposed another user-facing failure. An intermediate polling-loop failure occurred after the fixture POST; all these intermediate runs used a fake GitHub, not a live mutation.

Candidate 3 uses test, try/_error, ENV, explicit normalized-name variables, and native arithmetic. The generator selects 3.ysh. FP must consume its companion repair: the old wrapper remains incompatible. Grease safety options stay enabled. Failed POST stderr is retained rather than lost in an aborted command substitution.

Actual local execution: native Linux x86-64 Grease/Oils 0.37.0, implementation 5651cf97a1b5042f24f14112a7ade9a1518eb0bc, artifact 11419782646, archive SHA-256 71e679fef031225716bbb4d6ea140ab17e9d44e7aa6bd4964e7bccbbed6ce323, ELF SHA-256 7e31cd05b7a9d8fb2a4a9e003a7f3fcb0159138506d17f0fb28da8cbe22aa85c. Tests passed with actual native Grease, not sh: 13 standalone scenarios, 14 FP integration scenarios, deterministic generation, invalid input, missing root, existing artifacts, exact three-repository batch, and completed rerun with exactly three total POSTs. GitHub and sleep were fixtures.

Physical C67 execution of the repaired scripts and live ownership transfer remain NOT_VERIFIED. Host-runtime source differs from the installed Android source and is not phone acceptance. This change repairs language/runtime execution, not every earlier operational audit finding: separate source-name/ID reads, destination HTTP-error classification, and shared-directory artifact races remain separate hardening work. CI now acquires a digest-bound real interpreter and must fail if it cannot acquire it; it never substitutes sh.

Related: https://github.com/isomorphisms/kitchen/issues/43 and https://github.com/isomorphisms/flexible-pipes/pull/53.
