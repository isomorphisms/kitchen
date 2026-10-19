# Version 2: independent mutant artifacts and source-bound receipts

Version 1 was source-pinned by the initial FP preflight at Kitchen
`c15da935730883b803996e766b9e0681b45504e3`. Its unchanged numbered source and
Ikefile are retained here. That procedure runs the capture's targeted mutant
harness and independent positive artifacts, but does not independently inspect
the actual bad mutant artifacts or require a source-bound report.

Version 2 closes that acceptance gap. Its separate Ikefile requires independent
ai-ci rejection of the three real bad disk outputs, distinct diagnostics, exact
compiled source identity and a declared verifier toolchain. The Grease driver
explicitly enables fail-closed command/pipeline handling before preflight.
These are new acceptance requirements, not evidence that version 1 completed
them. Both versions remain synthetic source/build work, with no production
controller, real account, device or dispatch authority.
