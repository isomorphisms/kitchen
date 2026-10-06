# Candidate 5: use the pinned Grease try error register.
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
unset GH_TOKEN GITHUB_TOKEN GH_HOST
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
if (str(identity.full_name).lower() === str("$destination_owner/$repository").lower()) {
  var finished = null
  read-repo "repos/$destination_owner/$repository" (&finished)
  same-repo (finished, destination_owner)
  if (finished.visibility !== visibility) { fail 'VISIBILITY_CHANGED' }
  echo 'VERIFIED_ALREADY_AT_DESTINATION'
  exit 0
}
same-repo (identity, source_owner)
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
try { setvar collision = $(api "repos/$destination_owner/$repository") }
var collision_status = _error.code
if (collision_status === 0) {
  var existing = null
  echo "$collision" | json read (&existing)
  if (str(existing.full_name).lower() === str("$destination_owner/$repository").lower()) { fail 'DESTINATION_COLLISION' }
} elif (collision_status !== 4) { fail 'DESTINATION_LOOKUP_BLOCKED' }
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
