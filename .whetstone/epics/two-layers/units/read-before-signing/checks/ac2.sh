#!/usr/bin/env bash
# AC-2: BASELINE says reader entered: yes|no consistent with the count; brief has the review step iff yes.
sec="$(awk '/^# A reader before the brief is signed/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"
e="$(printf '%s' "$sec" | grep -oE 'reader entered: (yes|no)' | head -1)"; [ -n "$e" ] || { echo "no 'reader entered:' line in BASELINE"; exit 1; }
n="$(printf '%s' "$sec" | grep -oE 'both plants found in [0-9]+ of 6' | grep -oE '[0-9]+' | head -1)"; [ -n "$n" ] || { echo "BASELINE lacks 'both plants found in N of 6'"; exit 1; }
if [ "$n" -ge 4 ]; then [ "$e" = "reader entered: yes" ] || { echo "found $n but $e"; exit 1; }; else [ "$e" = "reader entered: no" ] || { echo "found $n but $e"; exit 1; }; fi
f=skills/brief/SKILL.md
if [ "$e" = "reader entered: yes" ]; then
  for p in "review" "brief-review.md" "independent: false" "each finding"; do grep -qF -- "$p" "$f" || { echo "brief lacks: $p"; exit 1; }; done
  grep -qiE "review(ed)? .*(draft|brief).*before" "$f" || { echo "brief does not say the draft is reviewed before hand-over"; exit 1; }
else
  grep -qF -- "brief-review.md" "$f" && { echo "brief has the review step but reader entered: no"; exit 1; }
fi
exit 0
