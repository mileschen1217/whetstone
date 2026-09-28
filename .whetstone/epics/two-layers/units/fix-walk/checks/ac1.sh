#!/usr/bin/env bash
# AC-1: build's After review.md part carries the walk sentence verbatim and is ≤ 10 lines.
part="$(awk '/^## After review.md/{on=1;next} /^## /{on=0} on' skills/build/SKILL.md)"
[ -n "$part" ] || { echo "no After review.md part"; exit 1; }
n="$(printf '%s\n' "$part" | grep -c '')"; [ "$n" -le 10 ] || { echo "After review.md is $n lines"; exit 1; }
for p in "After each fix: grep the repo for the name, value or format the fix changed and re-read every hit" "then re-read every file that states that behaviour (README, CHANGELOG, docs, tests) and change what no longer holds" "Stop when that list is walked"; do
  printf '%s' "$part" | grep -qF -- "$p" || { echo "lacks: $p"; exit 1; }
done
echo "After review.md: $n lines, walk sentence present"
