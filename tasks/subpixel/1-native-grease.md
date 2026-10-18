# Native Grease qualification

The first parse probe caught an unquoted absolute path in a typed `var`
assignment (`var linker = /usr/bin/...`). Native Grease rejected that expression
before execution. The path is now an explicit string. No alternate interpreter
was used. Execute with the pinned native Grease binary; its ASan build requires
`ASAN_OPTIONS=detect_leaks=0` in this ptrace/container context, as in the retained
transfer-handoff action. That setting disables leak scanning, not script errors.

The complete producer/oracle path requires the pinned source checkouts and an
actual owned ICK build. A syntax pass or refusal test is not that execution.
