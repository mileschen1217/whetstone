#!/usr/bin/env bash
# AC-2: BASELINE records the six reads, the step's own with/without measurement and reader entered: no; brief has no review step.
sec="$(awk '/^# A reader before the brief is signed/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"
printf '%s' "$sec" | grep -qE 'both plants found in [0-9]+ of 6' || { echo "BASELINE lacks 'both plants found in N of 6'"; exit 1; }
printf '%s' "$sec" | grep -qiE 'with the step [0-9, ]+ of 12' || { echo "BASELINE lacks the with-step trials"; exit 1; }
printf '%s' "$sec" | grep -qiE 'without the step [0-9, ]+' || { echo "BASELINE lacks the without-step trials"; exit 1; }
printf '%s' "$sec" | grep -qF 'reader entered: no' || { echo "BASELINE lacks 'reader entered: no'"; exit 1; }
f=skills/brief/SKILL.md
for p in "brief-review.md" "independent: false" "answered:"; do grep -qF -- "$p" "$f" && { echo "brief still has: $p"; exit 1; }; done
grep -qiE "review(ed)? .*(draft|brief).*before" "$f" && { echo "brief still says the draft is reviewed before hand-over"; exit 1; }
exit 0
