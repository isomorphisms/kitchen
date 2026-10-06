# Candidate 8: retain included HTTP bytes even when the CLI reports failure.
proc fail (...messages) { echo @messages >&2; exit 1 }
proc api (...args) { gh api @args }
proc read-repo (endpoint; out) {
  var payload = $(api "$endpoint")
  echo "$payload" | json read (out)
}
proc same-repo (; obj, owner) {
  if (obj.id !== expected_repository_id) { fail 'REPOSITORY_ID_MISMATCH' }
  if (str(obj.full_name).lower() !== str("$owner/$repository").lower()) { fail 'CANONICAL_NAME_MISMATCH' }
}
if (target_context !== 'linux-x86_64-grease-v1') { fail 'UNQUALIFIED_CONTEXT' }
setglobal ENV.GH_TOKEN = null
setglobal ENV.GITHUB_TOKEN = null
setglobal ENV.GH_HOST = null
if ! command -v gh >/dev/null { fail 'MISSING_EXECUTABLE' }
if ! gh auth status --hostname github.com >/dev/null 2>&1 { fail 'AUTHENTICATION' }
var login = null
var payload = $(api user)
echo "$payload" | json read (&login)
if (login.login !== expected_login) { fail 'LOGIN_MISMATCH' }
var identity = null
read-repo "repositories/$expected_repository_id" (&identity)
var visibility = identity.visibility
if (identity.id !== expected_repository_id) { fail 'REPOSITORY_ID_MISMATCH' }
var here = $(dirname -- "$0")
var state_dir = "$here/transfer-state"
var ledger = "$state_dir/repository-${expected_repository_id}-to-${destination_owner}.json"
var prior = null
if test -e "$ledger" {
  cat -- "$ledger" | json read (&prior)
  if (prior.repository_id !== expected_repository_id or prior.source !== "$source_owner/$repository" or prior.destination !== "$destination_owner/$repository" or prior.login !== expected_login) { fail 'PRIOR_INTENT_MISMATCH' }
  if (identity.visibility !== prior.visibility) { fail 'VISIBILITY_CHANGED_SINCE_ATTEMPT' }
}
if (str(identity.full_name).lower() === str("$destination_owner/$repository").lower()) {
  var finished = null
  read-repo "repos/$destination_owner/$repository" (&finished)
  same-repo (finished, destination_owner)
  if (finished.visibility !== visibility) { fail 'VISIBILITY_CHANGED' }
  echo 'VERIFIED_ALREADY_AT_DESTINATION'
  exit 0
}
same-repo (identity, source_owner)
if (prior !== null) { fail 'PRIOR_TRANSFER_UNVERIFIED: reconcile numeric identity; do not resend automatically' }
var canonical = null
read-repo "repos/$source_owner/$repository" (&canonical)
same-repo (canonical, source_owner)
if (canonical.visibility !== visibility) { fail 'VISIBILITY_CHANGED' }
if (canonical.permissions.admin !== true) { fail 'API_CAPABILITY' }
var destination = null
setvar payload = $(api "users/$destination_owner")
echo "$payload" | json read (&destination)
if (str(destination.login).lower() !== str(destination_owner).lower()) { fail 'DESTINATION_MISMATCH' }
if (destination.type === 'Organization') {
  var membership = null
  setvar payload = $(api "user/memberships/orgs/$destination_owner")
  echo "$payload" | json read (&membership)
  if (membership.state !== 'active') { fail 'API_CAPABILITY' }
} elif (destination.type !== 'User') { fail 'DESTINATION_TYPE' }
var collision = ''
var collision_file = $(/usr/bin/mktemp -- "$here/destination-lookup.XXXXXX")
try { api --include "repos/$destination_owner/$repository" > "$collision_file" }
var collision_status = _error.code
setvar collision = $(cat -- "$collision_file")
if (collision_status === 0) {
  fail 'DESTINATION_COLLISION'
} elif (collision_status !== 1) { fail 'DESTINATION_LOOKUP_BLOCKED' }
if ! /usr/bin/grep -Eq '^HTTP/[0-9.]+ 404 ' <<< "$collision" { fail 'DESTINATION_LOOKUP_BLOCKED' }
if ! test -d "$state_dir" { mkdir -m 700 -- "$state_dir" }
umask 077
set -o noclobber
json write ({schema_version: 1, repository_id: expected_repository_id, source: "$source_owner/$repository", destination: "$destination_owner/$repository", login: expected_login, visibility: visibility, state: 'ATTEMPTED'}) > "$ledger"
try { api --method POST "repos/$source_owner/$repository/transfer" -f "new_owner=$destination_owner" --silent }
var transfer_status = _error.code
var observed = null
try { read-repo "repositories/$expected_repository_id" (&observed) }
var observation_status = _error.code
if (observation_status === 0) {
  if (observed.id !== expected_repository_id or observed.visibility !== visibility) { fail 'POSTCONDITION_MISMATCH' }
  if (str(observed.full_name).lower() === str("$destination_owner/$repository").lower()) {
    var resolved = null
    read-repo "repos/$destination_owner/$repository" (&resolved)
    same-repo (resolved, destination_owner)
    if (resolved.visibility !== visibility) { fail 'VISIBILITY_CHANGED' }
    if (transfer_status !== 0) { fail 'TRANSFER_FAILED_DESPITE_OBSERVED_MOVE' }
    echo 'VERIFIED_TRANSFER'
    exit 0
  }
}
if (transfer_status !== 0) { fail 'TRANSFER_FAILED' }
fail 'ACCEPTED_BUT_UNVERIFIED: inspect numeric identity before retry; do not blindly resend'
