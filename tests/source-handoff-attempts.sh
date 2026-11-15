#!/bin/sh
# Independent host controls for the K05 candidate writer at the POSIX seam.
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd -P)
writer=$root/tasks/source-handoff/3-attempt.sh
work=$(mktemp -d)
trap 'rm -rf "$work"' 0
trap 'exit 130' INT
trap 'exit 143' HUP TERM
mkdir "$work/attempts"
plan=$work/plan.tsv
record=$work/record.tsv
tab=$(printf '\t')
source_identity=1111111111111111111111111111111111111111
contract_blob=2222222222222222222222222222222222222222
control_blob=3333333333333333333333333333333333333333
runtime_sha256=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
producer_digest=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
log_digest=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
write_plan() {
    printf 'stage_id\tactor\trequired\tselected\tdepends_on\tclaim\nsetup\tkitchen\tyes\tyes\t-\tmaterialization\nexecution\ttest-runner\tyes\tyes\tsetup\tselected_test\npostcondition\tkitchen\tyes\tyes\texecution\tsuccess_marker\nreporting\tkitchen\tno\tyes\tpostcondition\treceipt_delivery\n' > "$plan"
    plan_blob=$(git hash-object --no-filters "$plan")
}
write_record() {
    attempt_id=$1 stage=$2 actor=$3 observation=$4 validity=$5 exit_code=$6 signal=$7 command=$8 native=$9
    shift 9
    detail=$1
    printf 'attempt\tstage_id\tactor\tobservation\tevidence_validity\texit\tsignal\tcommand\tsource_identity\tproducer_digest\tlog_digest\tnative_code\tdetail\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$attempt_id" "$stage" "$actor" "$observation" "$validity" "$exit_code" "$signal" "$command" "$source_identity" "$producer_digest" "$log_digest" "$native" "$detail" > "$record"
    record_blob=$(git hash-object --no-filters "$record")
}
begin() { sh "$writer" begin "$plan" "$plan_blob" "$work/attempts" "$1" "$source_identity" "$contract_blob" "$control_blob" "$runtime_sha256"; }
record_stage() { sh "$writer" record "$1" "$record" "$record_blob"; }
finish() { sh "$writer" finalize "$1"; }
count=0
passed() { count=$((count + 1)); printf 'ok %s - %s\n' "$count" "$1"; }
write_plan

attempt=$(begin 1)
test -s "$attempt/begin.tsv" && test ! -e "$work/effect"
printf 'effect\n' > "$work/effect"
passed 'attempt observation exists before effectful execution'

write_record 1 setup kitchen PASS VALID 0 - prepare-source ok 'fresh exact source materialized'
record_stage "$attempt" >/dev/null
write_record 1 execution test-runner PASS VALID 0 - run-selected-test ok 'selected test exited zero'
record_stage "$attempt" >/dev/null
write_record 1 postcondition kitchen PASS VALID 0 - check-marker ok 'required marker observed'
record_stage "$attempt" >/dev/null
write_record 1 reporting kitchen PASS VALID 0 - report-receipt ok 'receipt delivered'
record_stage "$attempt" >/dev/null
finish "$attempt" >/dev/null
test "$(awk -F '\t' '$1=="state" {print $2}' "$attempt/final.tsv")" = COMPLETE
test "$(wc -l < "$attempt/observations.tsv")" -eq 5
test -f "$attempt/missing.tsv" && test ! -s "$attempt/missing.tsv"
passed 'complete selected stage set finalizes in plan order'

if begin 1 > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'history was not overwritten' "$work/error" >/dev/null
test -s "$attempt/observations.tsv"
passed 'reused attempt identity cannot overwrite earlier history'

attempt2=$(begin 2)
write_record 2 setup kitchen FAIL VALID 74 - prepare-source setup_failed 'source preparation failed'
record_stage "$attempt2" >/dev/null
write_record 2 execution test-runner NOT_RUN VALID - - run-selected-test blocked_by_setup 'dependent stage did not run'
record_stage "$attempt2" >/dev/null
write_record 2 postcondition kitchen NOT_RUN VALID - - check-marker blocked_by_execution 'dependent stage did not run'
record_stage "$attempt2" >/dev/null
write_record 2 reporting kitchen NOT_RUN VALID - - report-receipt blocked_by_postcondition 'dependent stage did not run'
record_stage "$attempt2" >/dev/null
finish "$attempt2" >/dev/null
grep -F "2${tab}setup${tab}kitchen${tab}FAIL" "$attempt2/observations.tsv" >/dev/null
test -s "$attempt/observations.tsv"
passed 'setup failure and every dependent NOT_RUN remain attributable'

attempt3=$(begin 3)
write_record 3 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt3" >/dev/null
if finish "$attempt3" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'stage=completeness' "$work/error" >/dev/null
grep -Fx execution "$attempt3/missing.tsv" >/dev/null
grep -Fx postcondition "$attempt3/missing.tsv" >/dev/null
grep -Fx reporting "$attempt3/missing.tsv" >/dev/null
test ! -e "$attempt3/observations.tsv"
passed 'omitted selected rows retain exact incomplete evidence and fail closed'

write_plan
attempt4=$(begin 4)
printf '# changed\n' >> "$attempt4/plan.tsv"
write_record 4 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
if record_stage "$attempt4" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'plan snapshot changed' "$work/error" >/dev/null
passed 'changed required-stage plan blocks observation writes'

write_plan
attempt13=$(begin 13)
write_record 13 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt13" >/dev/null
printf '# changed\n' >> "$attempt13/stages/setup.tsv"
if finish "$attempt13" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'stage observation changed after recording' "$work/error" >/dev/null
test ! -e "$attempt13/final.tsv"
passed 'changed stage evidence blocks finalization'

write_plan
if sh "$writer" begin "$plan" 0000000000000000000000000000000000000000 "$work/attempts" 5 "$source_identity" "$contract_blob" "$control_blob" "$runtime_sha256" > "$work/output" 2> "$work/error"; then exit 1; fi
test ! -e "$work/attempts/attempt-5"
passed 'wrong independent plan identity blocks attempt creation'

attempt5=$(begin 5)
write_record 5 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt5" >/dev/null
if record_stage "$attempt5" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'prior evidence was not overwritten' "$work/error" >/dev/null
passed 'one attempt cannot replace a stage observation'

attempt6=$(begin 6)
write_record 6 setup other-actor PASS VALID 0 - prepare-source ok 'forged actor'
if record_stage "$attempt6" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'stage actor differs' "$work/error" >/dev/null
passed 'actor must come from the independent plan'

attempt7=$(begin 7)
saved_source=$source_identity
source_identity=9999999999999999999999999999999999999999
write_record 7 setup kitchen PASS VALID 0 - prepare-source ok 'wrong source'
source_identity=$saved_source
if record_stage "$attempt7" > "$work/output" 2> "$work/error"; then exit 1; fi
grep -F 'closed A04-compatible observation' "$work/error" >/dev/null
passed 'wrong source identity cannot enter the attempt'

attempt8=$(begin 8)
write_record 8 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt8" >/dev/null
write_record 8 execution test-runner INTERRUPTED VALID 130 SIGINT run-selected-test interrupted 'child interrupted'
record_stage "$attempt8" >/dev/null
write_record 8 postcondition kitchen NOT_RUN VALID - - check-marker blocked_by_execution 'dependent stage did not run'
record_stage "$attempt8" >/dev/null
write_record 8 reporting kitchen NOT_RUN VALID - - report-receipt blocked_by_postcondition 'dependent stage did not run'
record_stage "$attempt8" >/dev/null
finish "$attempt8" >/dev/null
grep -F 'INTERRUPTED' "$attempt8/observations.tsv" >/dev/null
grep -F 'SIGINT' "$attempt8/observations.tsv" >/dev/null
passed 'interruption and dependent NOT_RUN remain separate raw observations'

attempt9=$(begin 9)
write_record 9 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt9" >/dev/null
write_record 9 execution test-runner FAIL VALID 17 - run-selected-test exit_17 'printed success text before failing'
record_stage "$attempt9" >/dev/null
write_record 9 postcondition kitchen NOT_RUN VALID - - check-marker blocked_by_execution 'dependent stage did not run'
record_stage "$attempt9" >/dev/null
write_record 9 reporting kitchen NOT_RUN VALID - - report-receipt blocked_by_postcondition 'dependent stage did not run'
record_stage "$attempt9" >/dev/null
finish "$attempt9" >/dev/null
grep -F 'printed success text before failing' "$attempt9/observations.tsv" >/dev/null
grep -F "${tab}17${tab}-" "$attempt9/observations.tsv" >/dev/null
passed 'forged success text cannot replace the retained child exit'

printf 'stage_id\tactor\trequired\tselected\tdepends_on\tclaim\nsetup\tkitchen\tyes\tyes\t-\tmaterialization\nexecution\ttest-runner\tyes\tyes\tsetup\tselected_test\npostcondition\tkitchen\tyes\tyes\texecution\tsuccess_marker\ncleanup\tkitchen\tno\tyes\texecution\towned_cleanup\nreporting\tkitchen\tno\tyes\tcleanup\treceipt_delivery\n' > "$plan"
plan_blob=$(git hash-object --no-filters "$plan")
attempt14=$(begin 14)
write_record 14 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt14" >/dev/null
write_record 14 execution test-runner TIMEOUT VALID 124 SIGTERM run-selected-test timeout 'child exceeded its declared bound'
record_stage "$attempt14" >/dev/null
write_record 14 postcondition kitchen NOT_RUN VALID - - check-marker blocked_by_execution 'dependent stage did not run'
record_stage "$attempt14" >/dev/null
write_record 14 cleanup kitchen PASS VALID 0 - cleanup-owned-state ok 'owned cleanup completed'
record_stage "$attempt14" >/dev/null
write_record 14 reporting kitchen PASS VALID 0 - report-receipt ok 'failure receipt delivered'
record_stage "$attempt14" >/dev/null
finish "$attempt14" >/dev/null
grep -F "${tab}TIMEOUT${tab}VALID${tab}124${tab}SIGTERM${tab}" "$attempt14/observations.tsv" >/dev/null
grep -F "${tab}cleanup${tab}kitchen${tab}PASS" "$attempt14/observations.tsv" >/dev/null
grep -F "${tab}reporting${tab}kitchen${tab}PASS" "$attempt14/observations.tsv" >/dev/null
passed 'timeout remains separate from successful cleanup and reporting'

printf 'stage_id\tactor\trequired\tselected\tdepends_on\tclaim\nsetup\tkitchen\tyes\tyes\t-\tmaterialization\noptional-log\tkitchen\tno\tyes\tsetup\toptional_diagnostic\n' > "$plan"
plan_blob=$(git hash-object --no-filters "$plan")
attempt10=$(begin 10)
write_record 10 setup kitchen PASS VALID 0 - prepare-source ok 'setup passed'
record_stage "$attempt10" >/dev/null
empty_digest=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
saved_log=$log_digest log_digest=$empty_digest
write_record 10 optional-log kitchen PASS VALID 0 - capture-optional-log empty_ok 'empty output is permitted for this optional stage'
log_digest=$saved_log
record_stage "$attempt10" >/dev/null
finish "$attempt10" >/dev/null
grep -F "$empty_digest" "$attempt10/observations.tsv" >/dev/null
passed 'declared harmless empty optional output remains recordable'

write_plan
attempt11=$(begin 11)
attempt12=$(begin 12)
cmp "$attempt11/plan.tsv" "$attempt12/plan.tsv"
test "$(awk -F '\t' '$1=="plan_git_blob" {print $2}' "$attempt11/begin.tsv")" = "$(awk -F '\t' '$1=="plan_git_blob" {print $2}' "$attempt12/begin.tsv")"
test "$(awk -F '\t' '$1=="attempt" {print $2}' "$attempt11/begin.tsv")" != "$(awk -F '\t' '$1=="attempt" {print $2}' "$attempt12/begin.tsv")"
passed 'equal immutable inputs preserve plan identity without fabricating one execution'

printf 'source handoff attempt regression cases: %s passed\n' "$count"
