#!/usr/bin/env bash
# AC-8: BASELINE.md has the two-layers section with both units' numbers and the cost.
s="$(awk '/^# The three signed pages in two layers/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"
[ -n "$s" ] || { echo "BASELINE.md: no section"; exit 1; }
for p in "line" "boundary" "18/18" "USD" "Decisions needed"; do printf '%s' "$s" | grep -qF -- "$p" || { echo "section lacks: $p"; exit 1; }; done
printf '%s' "$s" | grep -qE '\b10\b' && printf '%s' "$s" | grep -qE '\b13\b' || { echo "section lacks the real-page counts 10 and 13"; exit 1; }
