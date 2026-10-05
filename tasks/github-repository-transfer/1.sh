#!/system/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

lower() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

same_name() {
    [ "$(lower "$1")" = "$(lower "$2")" ]
}

[ "$#" -eq 4 ] ||
    fail 'usage: 1.sh SOURCE_OWNER REPOSITORY DESTINATION_OWNER EXPECTED_LOGIN'

source_owner=$1
repository=$2
destination_owner=$3
expected_login=$4
source_request=$source_owner/$repository

# For this human-facing transfer, use the interactive gh login rather than an
# ambient token that may silently select another account.
unset GH_TOKEN GITHUB_TOKEN

command -v gh >/dev/null 2>&1 || fail 'gh is not installed'
gh auth status --hostname github.com >/dev/null 2>&1 ||
    fail 'gh is not authenticated to github.com'

login=$(gh api user --jq '.login')
[ "$login" = "$expected_login" ] ||
    fail "refusing: gh is authenticated as $login, expected $expected_login"

# Resolve the source once and keep GitHub's canonical casing. Comparisons are
# case-insensitive because GitHub owner/repository names are case-insensitive;
# a redirect to a genuinely different owner/name still fails closed.
set +e
source_canonical=$(gh api "repos/$source_request" --jq '.full_name' 2>&1)
source_status=$?
set -e

[ "$source_status" -eq 0 ] ||
    fail "cannot read source $source_request: $source_canonical"

same_name "$source_canonical" "$source_request" ||
    fail "refusing: $source_request resolves to $source_canonical instead of being the canonical source"

source=$source_canonical

# This checked helper is for transfers into organizations. Validate the
# destination owner before mutating anything, and use GitHub's canonical login
# for the transfer and postcondition.
set +e
destination_owner_canonical=$(gh api "orgs/$destination_owner" --jq '.login' 2>&1)
destination_owner_status=$?
set -e

[ "$destination_owner_status" -eq 0 ] ||
    fail "destination organization $destination_owner is not accessible: $destination_owner_canonical"

set +e
membership=$(gh api "user/memberships/orgs/$destination_owner_canonical" \
    --jq '.state + ":" + .role' 2>&1)
membership_status=$?
set -e

[ "$membership_status" -eq 0 ] ||
    fail "refusing: $login is not an active member of $destination_owner_canonical: $membership"

membership_state=${membership%%:*}
membership_role=${membership#*:}

[ "$membership_state" = active ] ||
    fail "refusing: membership in $destination_owner_canonical is $membership_state, not active"

destination=$destination_owner_canonical/$repository
printf 'destination organization: %s (%s)\n' \
    "$destination_owner_canonical" "$membership_role"

destination_canonical=$(
    gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true
)

if [ -n "$destination_canonical" ] &&
   same_name "$destination_canonical" "$destination"; then
    fail "refusing: destination already exists: $destination_canonical"
fi

if [ -n "$destination_canonical" ]; then
    printf 'note: %s currently redirects to %s; that is not a canonical destination collision\n' \
        "$destination" "$destination_canonical" >&2
fi

printf 'transferring %s -> %s\n' "$source" "$destination"

set +e
transfer_output=$(gh api --method POST "repos/$source/transfer" \
    -f "new_owner=$destination_owner_canonical" \
    --silent 2>&1)
transfer_status=$?
set -e

if [ "$transfer_status" -ne 0 ]; then
    printf 'GitHub rejected transfer %s -> %s:\n%s\n' \
        "$source" "$destination" "$transfer_output" >&2
    exit "$transfer_status"
fi

attempt=0
while [ "$attempt" -lt 30 ]; do
    destination_canonical=$(
        gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true
    )

    if [ -n "$destination_canonical" ] &&
       same_name "$destination_canonical" "$destination"; then
        printf 'verified: %s\n' "$destination_canonical"
        exit 0
    fi

    attempt=$((attempt + 1))
    [ "$attempt" -lt 30 ] && sleep 2
done

source_after=$(
    gh api "repos/$source" --jq '.full_name' 2>/dev/null || true
)

[ -n "$source_after" ] || source_after='unavailable'

fail "transfer request returned success, but the canonical destination did not appear: $destination; source lookup now resolves to: $source_after"
