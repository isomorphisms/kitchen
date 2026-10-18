#!/bin/sh
# Candidate Kitchen K05 observation writer for the existing POSIX handoff seam.
# It records raw owner observations; AICI independently computes validity/verdicts.
(
    stop() { printf 'BLOCKED stage=%s %s\n' "$1" "$2" >&2; exit 1; }
    [ "$#" -ge 1 ] || stop arguments 'begin|record|finalize ...'
    mode=$1
    tab=$(printf '\t')
    newline='
'
    for argument in "$@" "$0"; do
        case $argument in *"$tab"*|*"$newline"*) stop arguments 'tabs and newlines in arguments are unsupported' ;; esac
    done
    for dependency in env git awk dirname mkdir mv cp grep wc sync rm; do
        command -v "$dependency" >/dev/null 2>&1 || stop dependency "missing $dependency; no installation attempted"
    done
    clean_git() {
        env -i PATH="$PATH" HOME="$HOME" GIT_CONFIG_NOSYSTEM=1 \
            GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
            GIT_NO_REPLACE_OBJECTS=1 git "$@"
    }
    blob() { clean_git hash-object --no-filters "$1"; }
    absolute_directory() {
        [ -d "$1" ] && [ ! -L "$1" ] || return 1
        (CDPATH='' cd -- "$1" && pwd -P)
    }
    valid_git_blob() {
        [ "${#1}" -eq 40 ] || return 1
        case $1 in *[!0-9a-f]*) return 1 ;; esac
    }
    valid_sha256_or_absent() {
        [ "$1" = - ] && return 0
        [ "${#1}" -eq 64 ] || return 1
        case $1 in *[!0-9a-f]*) return 1 ;; esac
    }
    field() { awk -F '\t' -v key="$2" '$1==key { print $2 }' "$1"; }
    validate_plan() {
        awk -F '\t' '
            NR==1 {
                if ($0 != "stage_id\tactor\trequired\tselected\tdepends_on\tclaim") exit 1
                next
            }
            NF!=6 { exit 1 }
            $1 !~ /^[a-z][a-z0-9_-]*$/ || $2 !~ /^[a-z][a-z0-9_-]*$/ || $6 !~ /^[a-z][a-z0-9_-]*$/ { exit 1 }
            ($3!="yes" && $3!="no") || ($4!="yes" && $4!="no") || seen[$1]++ { exit 1 }
            $5!="-" && !seen[$5] { exit 1 }
            { rows++ }
            END { if (rows<1) exit 1 }
        ' "$1"
    }
    validate_attempt() {
        attempt=$1
        [ -d "$attempt" ] && [ ! -L "$attempt" ] || stop attempt 'attempt directory unavailable or unsafe'
        attempt=$(absolute_directory "$attempt") || stop attempt 'cannot resolve attempt directory'
        [ -f "$attempt/begin.tsv" ] && [ ! -L "$attempt/begin.tsv" ] || stop attempt 'begin receipt unavailable or unsafe'
        [ -f "$attempt/plan.tsv" ] && [ ! -L "$attempt/plan.tsv" ] || stop attempt 'plan snapshot unavailable or unsafe'
        [ "$(field "$attempt/begin.tsv" schema)" = kitchen-k05-attempt-v1 ] || stop attempt 'unsupported attempt receipt'
        [ -f "$attempt/begin.git-blob" ] && [ ! -L "$attempt/begin.git-blob" ] || stop attempt 'begin receipt seal unavailable or unsafe'
        IFS= read -r begin_blob < "$attempt/begin.git-blob" || stop attempt 'cannot read begin receipt seal'
        valid_git_blob "$begin_blob" || stop attempt 'begin receipt seal is malformed'
        [ "$(blob "$attempt/begin.tsv")" = "$begin_blob" ] || stop attempt 'begin receipt changed after attempt creation'
        plan_blob=$(field "$attempt/begin.tsv" plan_git_blob)
        [ "$(blob "$attempt/plan.tsv")" = "$plan_blob" ] || stop attempt 'plan snapshot changed after attempt creation'
        validate_plan "$attempt/plan.tsv" || stop attempt 'plan snapshot is malformed'
    }

    case $mode in
        begin)
            [ "$#" -eq 9 ] || stop arguments 'begin PLAN PLAN_GIT_BLOB ATTEMPTS_ROOT ATTEMPT SOURCE CONTRACT_GIT_BLOB CONTROL_GIT_BLOB RUNTIME_SHA256_OR_DASH'
            plan=$2 plan_blob=$3 root=$4 attempt_id=$5 source_identity=$6 contract_blob=$7 control_blob=$8 runtime_sha256=$9
            [ -f "$plan" ] && [ ! -L "$plan" ] || stop plan 'plan unavailable or unsafe'
            valid_git_blob "$plan_blob" || stop plan 'invalid plan Git blob'
            [ "$(blob "$plan")" = "$plan_blob" ] || stop plan 'plan bytes differ from independently supplied identity'
            validate_plan "$plan" || stop plan 'invalid required-stage plan'
            root=$(absolute_directory "$root") || stop attempt 'attempt root unavailable or unsafe'
            case $attempt_id in ''|*[!0-9]*|0) stop attempt 'attempt identity must be a positive decimal integer' ;; esac
            valid_git_blob "$source_identity" || stop source 'invalid source identity'
            valid_git_blob "$contract_blob" || stop contract 'invalid contract Git blob'
            valid_git_blob "$control_blob" || stop control 'invalid control Git blob'
            valid_sha256_or_absent "$runtime_sha256" || stop runtime 'invalid runtime SHA-256 identity'
            target=$root/attempt-$attempt_id
            pending=$root/.attempt-$attempt_id.pending
            [ ! -e "$target" ] && [ ! -L "$target" ] || stop attempt 'attempt identity already exists; history was not overwritten'
            mkdir "$pending" || stop attempt 'cannot create attempt observation before execution'
            mkdir "$pending/stages" || stop attempt 'cannot create stage observation directory'
            cp "$plan" "$pending/plan.next" || stop attempt 'cannot snapshot required-stage plan'
            [ "$(blob "$pending/plan.next")" = "$plan_blob" ] || stop attempt 'plan snapshot identity changed'
            mv "$pending/plan.next" "$pending/plan.tsv" || stop attempt 'cannot finalize required-stage plan snapshot'
            {
                printf 'schema\tkitchen-k05-attempt-v1\n'
                printf 'attempt\t%s\n' "$attempt_id"
                printf 'plan_git_blob\t%s\n' "$plan_blob"
                printf 'source_identity\t%s\n' "$source_identity"
                printf 'contract_git_blob\t%s\n' "$contract_blob"
                printf 'control_git_blob\t%s\n' "$control_blob"
                printf 'runtime_sha256\t%s\n' "$runtime_sha256"
                printf 'state\tOPEN\n'
            } > "$pending/begin.next" || stop attempt 'cannot write attempt observation before execution'
            mv "$pending/begin.next" "$pending/begin.tsv" || stop attempt 'cannot finalize attempt observation'
            blob "$pending/begin.tsv" > "$pending/begin.git-blob.next" || stop attempt 'cannot identify initial attempt observation'
            mv "$pending/begin.git-blob.next" "$pending/begin.git-blob" || stop attempt 'cannot seal initial attempt observation'
            sync "$pending/begin.tsv" "$pending/begin.git-blob" "$pending/plan.tsv" 2>/dev/null || stop attempt 'cannot make initial attempt observation durable'
            mv "$pending" "$target" || stop attempt 'cannot publish initial attempt observation'
            printf '%s\n' "$target"
            ;;
        record)
            [ "$#" -eq 4 ] || stop arguments 'record ATTEMPT_DIRECTORY RECORD RECORD_GIT_BLOB'
            validate_attempt "$2"
            [ ! -e "$attempt/final.tsv" ] && [ ! -L "$attempt/final.tsv" ] || stop record 'attempt already finalized; history was not overwritten'
            record=$3 record_blob=$4
            [ -f "$record" ] && [ ! -L "$record" ] || stop record 'record unavailable or unsafe'
            valid_git_blob "$record_blob" || stop record 'invalid record Git blob'
            [ "$(blob "$record")" = "$record_blob" ] || stop record 'record bytes differ from independently supplied identity'
            expected_attempt=$(field "$attempt/begin.tsv" attempt)
            expected_source=$(field "$attempt/begin.tsv" source_identity)
            awk -F '\t' -v expected_attempt="$expected_attempt" -v expected_source="$expected_source" '
                NR==1 {
                    if ($0 != "attempt\tstage_id\tactor\tobservation\tevidence_validity\texit\tsignal\tcommand\tsource_identity\tproducer_digest\tlog_digest\tnative_code\tdetail") exit 1
                    next
                }
                NR!=2 || NF!=13 { exit 1 }
                $1!=expected_attempt || $2!~/^[a-z][a-z0-9_-]*$/ || $3!~/^[a-z][a-z0-9_-]*$/ { exit 1 }
                $4!="PASS" && $4!="FAIL" && $4!="NOT_RUN" && $4!="SKIPPED" && $4!="INTERRUPTED" && $4!="TIMEOUT" { exit 1 }
                $5!="VALID" && $5!="INCOMPLETE" && $5!="MALFORMED" && $5!="STALE" && $5!="WRONG_TARGET" && $5!="WRONG_LAYER" && $5!="UNTRUSTED_PRODUCER" { exit 1 }
                $6!="-" && $6!~/^[0-9]+$/ { exit 1 }
                $7!="-" && $7!~/^SIG[A-Z0-9]+$/ { exit 1 }
                $8=="" || $9!=expected_source || $12=="" || $13=="" { exit 1 }
                ($10!="-" && (length($10)!=64 || $10!~/^[0-9a-f]+$/)) || ($11!="-" && (length($11)!=64 || $11!~/^[0-9a-f]+$/)) { exit 1 }
                { rows++ }
                END { if (rows!=1) exit 1 }
            ' "$record" || stop record 'record is not one closed A04-compatible observation'
            stage=$(awk -F '\t' 'NR==2 { print $2 }' "$record")
            actor=$(awk -F '\t' 'NR==2 { print $3 }' "$record")
            expected_actor=$(awk -F '\t' -v stage="$stage" 'NR>1 && $1==stage { print $2 }' "$attempt/plan.tsv")
            [ -n "$expected_actor" ] || stop record 'observed stage is absent from the independently supplied plan'
            [ "$actor" = "$expected_actor" ] || stop record 'stage actor differs from the independently supplied plan'
            target=$attempt/stages/$stage.tsv
            lock=$attempt/stages/.$stage.claimed
            mkdir "$lock" || stop record 'stage already has an observation; prior evidence was not overwritten'
            cp "$record" "$lock/record.next" || stop record 'cannot stage observation'
            [ "$(blob "$lock/record.next")" = "$record_blob" ] || stop record 'staged observation identity changed'
            printf '%s\n' "$record_blob" > "$lock/record.git-blob.next" || stop record 'cannot write stage observation seal'
            mv "$lock/record.git-blob.next" "$lock/record.git-blob" || stop record 'cannot finalize stage observation seal'
            sync "$lock/record.next" "$lock/record.git-blob" 2>/dev/null || stop record 'cannot make stage observation durable'
            mv "$lock/record.next" "$target" || stop record 'cannot publish stage observation'
            printf '%s\n' "$target"
            ;;
        finalize)
            [ "$#" -eq 2 ] || stop arguments 'finalize ATTEMPT_DIRECTORY'
            validate_attempt "$2"
            [ ! -e "$attempt/final.tsv" ] && [ ! -L "$attempt/final.tsv" ] || stop finalize 'attempt already finalized; history was not overwritten'
            observations=$attempt/observations.next
            printf 'attempt\tstage_id\tactor\tobservation\tevidence_validity\texit\tsignal\tcommand\tsource_identity\tproducer_digest\tlog_digest\tnative_code\tdetail\n' > "$observations" || stop finalize 'cannot stage normalized observations'
            missing=$attempt/missing.next
            : > "$missing" || stop finalize 'cannot stage missing-stage record'
            while IFS="$tab" read -r stage actor required selected dependency claim extra; do
                [ "$stage" = stage_id ] && continue
                [ -z "$extra" ] || stop finalize 'plan row changed after validation'
                if [ -f "$attempt/stages/$stage.tsv" ] && [ ! -L "$attempt/stages/$stage.tsv" ]; then
                    [ -f "$attempt/stages/.$stage.claimed/record.git-blob" ] && [ ! -L "$attempt/stages/.$stage.claimed/record.git-blob" ] || stop finalize 'stage observation seal unavailable or unsafe'
                    IFS= read -r stage_blob < "$attempt/stages/.$stage.claimed/record.git-blob" || stop finalize 'cannot read stage observation seal'
                    valid_git_blob "$stage_blob" || stop finalize 'stage observation seal is malformed'
                    [ "$(blob "$attempt/stages/$stage.tsv")" = "$stage_blob" ] || stop finalize 'stage observation changed after recording'
                    awk 'NR==2 { print }' "$attempt/stages/$stage.tsv" >> "$observations" || stop finalize 'cannot stage an existing observation'
                elif [ "$selected" = yes ]; then
                    printf '%s\n' "$stage" >> "$missing" || stop finalize 'cannot retain missing-stage identity'
                fi
            done < "$attempt/plan.tsv"
            observation_blob=$(blob "$observations") || stop finalize 'cannot identify normalized observations'
            missing_count=$(wc -l < "$missing") || stop finalize 'cannot count missing stages'
            if [ "$missing_count" -eq 0 ]; then
                state=COMPLETE
                mv "$observations" "$attempt/observations.tsv" || stop finalize 'cannot finalize complete observations'
                rm_target=$missing
            else
                state=INCOMPLETE
                mv "$observations" "$attempt/observations.incomplete.tsv" || stop finalize 'cannot retain incomplete observations'
                mv "$missing" "$attempt/missing.tsv" || stop finalize 'cannot retain missing-stage identities'
                rm_target=
            fi
            {
                printf 'schema\tkitchen-k05-finalization-v1\n'
                printf 'attempt\t%s\n' "$(field "$attempt/begin.tsv" attempt)"
                printf 'state\t%s\n' "$state"
                printf 'observations_git_blob\t%s\n' "$observation_blob"
                printf 'missing_selected_stage_count\t%s\n' "$missing_count"
            } > "$attempt/final.next" || stop finalize 'cannot write finalization receipt'
            mv "$attempt/final.next" "$attempt/final.tsv" || stop finalize 'cannot publish finalization receipt'
            sync "$attempt/final.tsv" 2>/dev/null || stop finalize 'cannot make finalization receipt durable'
            [ -z "$rm_target" ] || rm -f "$rm_target"
            [ "$state" = COMPLETE ] || stop completeness 'selected stage observation is absent; incomplete evidence retained for A04'
            printf '%s\n' "$attempt/observations.tsv"
            ;;
        *) stop arguments 'unknown mode; expected begin, record or finalize' ;;
    esac
)
