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
    fail 'usage: 1.sh SOURCE_OWNER REPOSITORY DESTINATION_ORGANIZATION EXPECTED_LOGIN'

source_owner=$1
repository=$2
destination_owner=$3
expected_login=$4
source_request=$source_owner/$repository

unset GH_TOKEN GITHUB_TOKEN

command -v gh >/dev/null 2>&1 || fail 'gh is not installed'
gh auth status --hostname github.com >/dev/null 2>&1 ||
    fail 'gh is not authenticated to github.com'

login=$(gh api user --jq '.login')
[ "$login" = "$expected_login" ] ||
    fail "refusing: gh is authenticated as $login, expected $expected_login"

set +e
source_canonical=$(gh api "repos/$source_request" --jq '.full_name' 2>&1)
source_status=$?
set -e
[ "$source_status" -eq 0 ] ||
    fail "cannot read source $source_request: $source_canonical"
same_name "$source_canonical" "$source_request" ||
    fail "refusing: $source_request resolves to $source_canonical instead of being the canonical source"
source=$source_canonical

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
printf 'destination organization: %s (%s)\n' "$destination_owner_canonical" "$membership_role"

destination_canonical=$(gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true)
if [ -n "$destination_canonical" ] && same_name "$destination_canonical" "$destination"; then
    destination_is_fork=$(gh api "repos/$destination" --jq '.fork' 2>/dev/null || true)
    destination_source=$(gh api "repos/$destination" --jq '.source.full_name // ""' 2>/dev/null || true)
    if [ "$destination_is_fork" = true ] &&
       [ -n "$destination_source" ] &&
       same_name "$destination_source" "$source"; then
        printf 'already verified: %s is a fork of %s\n' "$destination_canonical" "$destination_source"
        exit 0
    fi
    fail "refusing: destination already exists but is not the requested fork: $destination_canonical"
fi

if [ -n "$destination_canonical" ]; then
    fail "refusing: $destination resolves to unexpected repository $destination_canonical"
fi

printf 'forking %s -> %s\n' "$source" "$destination"

set +e
fork_output=$(gh api --method POST "repos/$source/forks" \
    -f "organization=$destination_owner_canonical" \
    -f "name=$repository" \
    -F "default_branch_only=false" \
    --silent 2>&1)
fork_status=$?
set -e

if [ "$fork_status" -ne 0 ]; then
    printf 'GitHub rejected fork %s -> %s:\n%s\n' \
        "$source" "$destination" "$fork_output" >&2
    exit "$fork_status"
fi

attempt=0
while [ "$attempt" -lt 30 ]; do
    destination_canonical=$(gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true)
    if [ -n "$destination_canonical" ] && same_name "$destination_canonical" "$destination"; then
        destination_is_fork=$(gh api "repos/$destination" --jq '.fork' 2>/dev/null || true)
        destination_source=$(gh api "repos/$destination" --jq '.source.full_name // ""' 2>/dev/null || true)
        if [ "$destination_is_fork" = true ] &&
           [ -n "$destination_source" ] &&
           same_name "$destination_source" "$source"; then
            printf 'verified: %s is a fork of %s\n' "$destination_canonical" "$destination_source"
            exit 0
        fi
        fail "fork destination appeared with wrong network identity: $destination_canonical source=$destination_source fork=$destination_is_fork"
    fi

    attempt=$((attempt + 1))
    [ "$attempt" -lt 30 ] && sleep 2
done

fail "fork request returned success, but the verified destination did not appear: $destination"
