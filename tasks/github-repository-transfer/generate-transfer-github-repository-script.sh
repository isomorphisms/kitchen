#!/opt/catfood/bin/grease
# Grease; historical numbered candidates and their evidence remain unchanged.
proc fail (...messages) { echo @messages >&2; exit 2 }
var parameters = ARGV
var presentations = ['standalone', 'paste']
if (len(ARGV) === 7 and ARGV[0] === '--paste') {
  setvar parameters = ARGV[1:]
  setvar presentations = ['paste']
}
if (len(parameters) !== 6) { fail 'usage: generator [--paste] SOURCE REPOSITORY DESTINATION LOGIN NUMERIC_ID CONTEXT' }
var source_owner = parameters[0]
var repository = parameters[1]
var destination_owner = parameters[2]
var expected_login = parameters[3]
var expected_repository_id = parameters[4]
var target_context = parameters[5]
for value in @parameters {
  if ! /usr/bin/grep -Eq '^[A-Za-z0-9][A-Za-z0-9_.-]*$' <<< "$value" { fail 'invalid input component' }
}
if ! /usr/bin/grep -Eq '^[1-9][0-9]*$' <<< "$expected_repository_id" { fail 'repository ID must be positive' }
if (target_context !== 'linux-x86_64-grease-v1') { fail 'unqualified execution context' }
var here = $(dirname -- "$0")
umask 077
set -o noclobber
for presentation in @presentations {
  var suffix = '.sh'
  if (presentation === 'paste') { setvar suffix = '.paste.grease' }
  var proposed_output = "transfer-${repository}-from-${source_owner}-to-${destination_owner}${suffix}"
  if test -e "$proposed_output" { fail 'output already exists; no artifact was overwritten' }
}
for presentation in @presentations {
var suffix = '.sh'
if (presentation === 'paste') { setvar suffix = '.paste.grease' }
var output = "transfer-${repository}-from-${source_owner}-to-${destination_owner}${suffix}"
{
  if (presentation === 'paste') {
    if ! /usr/bin/sha256sum --check --status <<< "cf85b1dc4caea07749d5070bbc143d669e687820598c36a0050fddccb2612dc6  $here/transfer-github-repository.grease" { fail 'The compact acquisition pin does not match the maintained recipe bytes' }
    printf '# GitHub ownership transfer: %s/%s -> %s/%s; execution requires your authorization.\n' "$source_owner" "$repository" "$destination_owner" "$repository"
    cat <<'PASTE'
if /opt/catfood/bin/grease -c '
proc blocked (...messages) { echo "Prerequisite unavailable; no transfer requested:" @messages >&2; echo "KITCHEN_TRANSFER_CHILD_EXIT:2"; exit 2 }
for executable in curl sha256sum mktemp mkdir mv rm { if ! command -v "$executable" >/dev/null { blocked "$executable" } }
var state = "$[ENV.HOME]/.local/state/kitchen/github-transfers"
umask 077
if test -L "$state" { blocked "Transfer state is a symbolic link" }
mkdir -p -m 700 -- "$state"
var program = "$state/transfer-github-repository-cf85b1dc4cae.grease"
if ! test -f "$program" {
  var download = $(mktemp -- "$state/acquisition.XXXXXX")
  if ! curl --proto "=https" --proto-redir "=https" --tlsv1.2 --fail --silent --show-error --location --output "$download" "https://raw.githubusercontent.com/isomorphisms/kitchen/322b4ff634ee745748b209f19e63c472d01e0ae9/tasks/github-repository-transfer/transfer-github-repository.grease" { rm -- "$download"; blocked "Recipe acquisition failed" }
  if ! sha256sum --check --status <<< "cf85b1dc4caea07749d5070bbc143d669e687820598c36a0050fddccb2612dc6  $download" { rm -- "$download"; blocked "Recipe bytes failed verification" }
  mv -- "$download" "$program"
}
if ! sha256sum --check --status <<< "cf85b1dc4caea07749d5070bbc143d669e687820598c36a0050fddccb2612dc6  $program" { blocked "Recipe bytes changed" }
try { /opt/catfood/bin/grease "$program" @ARGV }
var child_status = _error.code
printf "KITCHEN_TRANSFER_CHILD_EXIT:%s\\n" "$child_status"
exit "$child_status"
PASTE
    printf '%s transfer-github-repository --source-owner %s --repository %s --destination-owner %s --expected-login %s --repository-id %s --context %s; then\n' "'" "$source_owner" "$repository" "$destination_owner" "$expected_login" "$expected_repository_id" "$target_context"
    cat <<'OUTCOME'
  if test -t 1; then printf '\033[32mOWNERSHIP_TRANSFER_VERIFIED\033[0m\n'; else echo 'OWNERSHIP_TRANSFER_VERIFIED'; fi
else
  if test -t 2; then printf '\033[31mOWNERSHIP_TRANSFER_NOT_VERIFIED; retain transfer state before retry\033[0m\n' >&2; else echo 'OWNERSHIP_TRANSFER_NOT_VERIFIED; retain transfer state before retry' >&2; fi
fi
OUTCOME
  } else {
    /usr/bin/head -n -1 -- "$here/transfer-github-repository.grease"
    printf 'transfer --source-owner %s --repository %s --destination-owner %s --expected-login %s --repository-id %s --context %s\n' "$source_owner" "$repository" "$destination_owner" "$expected_login" "$expected_repository_id" "$target_context"
  }
} > "$output"
chmod 700 -- "$output"
echo "$output"
}
