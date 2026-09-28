#!/usr/bin/env bash
# AC-2: BASELINE's entry line follows the count and its Δ line the two counts; with yes the four skill files carry the step (the lens questions only with Δ > 0), with no none of them.
sec="$(awk '/^# A reader of the fixes/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"; [ -n "$sec" ] || { echo "no BASELINE section"; exit 1; }
k="$(printf '%s' "$sec" | grep -oE 'readers correct: [0-9]+ of 6' | head -1 | awk '{print $3}')"; e="$(printf '%s' "$sec" | grep -oE 'burn-down entered: (yes|no)' | head -1 | awk '{print $3}')"
j="$(printf '%s' "$sec" | grep -oE 'readers correct bare: [0-9]+ of 6' | head -1 | awk '{print $4}')"; dl="$(printf '%s' "$sec" | grep -oE 'reader text Δ: [+-]?[0-9]+' | head -1 | awk '{print $4}')"
[ -n "$k" ] && [ -n "$e" ] && [ -n "$j" ] && [ -n "$dl" ] || { echo "missing one of: count line, bare count line, Δ line, entered line"; exit 1; }
[ $((k - j)) -eq $((dl)) ] || { echo "Δ line $dl is not $k - $j"; exit 1; }
if [ "$k" -ge 5 ]; then [ "$e" = yes ] || { echo "count $k but entered: $e"; exit 1; }; else [ "$e" = no ] || { echo "count $k but entered: $e"; exit 1; }; fi
b=skills/build/SKILL.md; r=skills/review/SKILL.md; s=skills/ship/SKILL.md; t=skills/build/burndown.md
if [ "$e" = yes ]; then
  [ -f "$t" ] && [ "$(wc -l < "$t")" -le 15 ] || { echo "no $t or over 15 lines"; exit 1; }
  for p in closed open "new:"; do grep -qiF -- "$p" "$t" || { echo "$t lacks: $p"; exit 1; }; done
  if [ $((dl)) -gt 0 ]; then for p in contradict "without an error"; do grep -qiF -- "$p" "$t" || { echo "$t lacks: $p with Δ $dl"; exit 1; }; done
  else for p in contradict "without an error"; do grep -qiF -- "$p" "$t" && { echo "$t carries the lens question '$p' with Δ $dl"; exit 1; }; done; fi
  for p in "burndown.md" "fresh" "review.md" "once" "independent: false" "commit"; do grep -qiF -- "$p" "$b" || { echo "$b lacks: $p"; exit 1; }; done
  grep -qiE 'burn-?down' "$r" && grep -qiE 'not a second round' "$r" || { echo "$r lacks the burn-down sentence"; exit 1; }
  for p in "burndown.md" "new:" "Fixes: not independently read" "independent: false"; do grep -qF -- "$p" "$s" || { echo "$s lacks: $p"; exit 1; }; done
else
  [ ! -f "$t" ] || { echo "$t exists with entered: no"; exit 1; }
  grep -qiE 'burn-?down' "$b" "$r" "$s" && { echo "a skill names the burn-down with entered: no"; exit 1; }
fi
exit 0
