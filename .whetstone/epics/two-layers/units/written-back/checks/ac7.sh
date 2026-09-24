#!/usr/bin/env bash
# AC-7: verify.sh puts the evidence file's line before `exit:` into an evidence row's Output; the header says so; the fixture has a case for it and passes whole.
grep -qE "line before .exit:|line before \`exit:\`" scripts/verify.sh || { echo "verify.sh header does not name the convention"; exit 1; }
grep -qE "evidence line reaches|line before exit" evals/verify-fixtures/run.sh || { echo "fixture has no case for the evidence line"; exit 1; }
out="$(bash evals/verify-fixtures/run.sh 2>&1)"; code=$?; echo "$out" | tail -3
[ $code -eq 0 ] || { echo "fixture not all ok"; exit 1; }
