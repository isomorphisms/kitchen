# Capture version 2 requirements (written before the candidate)

Preserve version 1 and its tests. Version 2 must reject wrong task bytes before
creating output or calling Android. Require current expected model, unique
serial property with its explicit property domain, firmware and selected ABI
from Cat Food; unknown/declarative profiles cannot claim current identity.
Match plan/profile target and handset instance, then observe the serial/model/
firmware/ABI through the explicitly selected channel before capture. Recheck
them after capture. Do not infer A1/C67/TAB_P10 from machine width.

Keep version 1 bounded native subprocess supervision, single PID and process
start checks, current APK digest checks, finite observation commands and weak
claim scope. Bind version_code when supplied by the plan. Rehash channel,
DEX and bounded helper before every call and after the last call. No log clear,
service start, permission change, install or uninstall belongs in capture.
Re-resolve the installed APK path after observation; hashing a retained old
path cannot prove that the current package still selects that APK. Bind the
exact plan/profile/runtime input bytes throughout the observation.

Add hostile cases for wrong same-model handset, wrong ABI, stale firmware,
missing current identity, changed task/channel/helper/DEX, changed identity
or APK during observation, nonzero partial producer output and plan version
mismatch. Keep valid counterparts for both ABIs without introducing a device
registry. Preserve a separate fixture device-state sentinel.

Bundle qualification uses the real retained Cat Food finite acquisition seam,
an explicitly cached HOST_FIXTURE archive, and the prebuilt native launcher.
Two fresh consumer directories must execute only delivered checked-Ithon/task/
helper bytes with cleared state and hostile interpreter/module selectors.
Keep acquisition/source/runtime digests distinct from installed Android claims.
