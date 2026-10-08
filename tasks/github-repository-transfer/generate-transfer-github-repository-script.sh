#!/opt/catfood/bin/grease
# Grease; historical numbered candidates and their evidence remain unchanged.
proc fail (...messages) { echo @messages >&2; exit 2 }
if (len(ARGV) !== 6) { fail 'usage: generator SOURCE REPOSITORY DESTINATION LOGIN NUMERIC_ID CONTEXT' }
var source_owner = ARGV[0]
var repository = ARGV[1]
var destination_owner = ARGV[2]
var expected_login = ARGV[3]
var expected_repository_id = ARGV[4]
var target_context = ARGV[5]
for value in @ARGV {
  if ! /usr/bin/grep -Eq '^[A-Za-z0-9][A-Za-z0-9_.-]*$' <<< "$value" { fail 'invalid input component' }
}
if ! /usr/bin/grep -Eq '^[1-9][0-9]*$' <<< "$expected_repository_id" { fail 'repository ID must be positive' }
if (target_context !== 'linux-x86_64-grease-v1') { fail 'unqualified execution context' }
var output = "transfer-${repository}-from-${source_owner}-to-${destination_owner}.sh"
if test -e "$output" { fail 'output already exists' }
var here = $(dirname -- "$0")
umask 077
set -o noclobber
{
  /usr/bin/head -n -1 -- "$here/transfer-github-repository.grease"
  printf 'transfer --source-owner %s --repository %s --destination-owner %s --expected-login %s --repository-id %s --context %s\n' "$source_owner" "$repository" "$destination_owner" "$expected_login" "$expected_repository_id" "$target_context"
} > "$output"
chmod 700 -- "$output"
echo "$output"
