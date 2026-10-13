# Indeed CLI acceptance preparation

Target: Ubuntu 24.04 x86-64 disposable Linux host. No Android acceptance.
The maintained program is Idriç, with ICU/Idric-Net transport and ICK-native
library compilation. Grease supplies the preparation/test procedure.

Inputs: absolute candidate checkout and full source head, installed program,
verified Grease executable, independent ai-ci checkout/full head and verifier.
The operation must reject wrong revisions, dirty tracked source and missing
executables. It must run the installed program from outside the checkout,
exercise real local HTTP transport, and compare actual proof classifications
with the independent oracle. It must demonstrate that a wrong classification
is rejected. No real credentials, installations or network to Indeed occur.

Reruns create separate temporary receipts. Client response directories are
private and cleaned by ICU. Shell captures contain synthetic fixtures only.
Keep all command args separate; no eval, inline generated shell, guessed
checkouts, dependencies hidden in test execution or deletion of user files.

Requirements precede the candidate. Positive fixture: the actual installed
Idriç CLI. Negative fixture: category 1 deliberately changed to category 5.
Preflight follows `preflight/terminal.md`; source and target identities are
observed, never inferred from a recorded PASS.
