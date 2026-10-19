# NHTSA vPIC decoder Kitchen task

Use `tasks/nhtsa-vin/1.grease` only through a Flexible Pipes admitted
job with exact source revisions. The arguments are MODE, absolute CLI checkout
path, 40-character CLI HEAD, Idriç compiler executable, ICK executable,
absolute ICU checkout path, ICU HEAD, and installed program path.
`install` additionally requires an absolute installation prefix.

Modes: `preflight`, `build`, `install`, `test`. No dependency
installation, source checkout, ordinary GCC/Clang fallback or network request
occurs here. Idriç `contrib` JSON, `idric_net`, and `icu_response` must
already be installed with the same compiler and package prefix.

The test mode compares the installed executable to the produced binary,
checks its adjacent ICU native library, and runs actual offline fixtures.
Only Flexible Pipes' separately recorded `live-provider` stage can claim a
real HTTP decode. Cat Food links to a built executable; it does not treat
source inventory as installed-command evidence. A1 and C67 packaging and
physical-device execution remain separate.
