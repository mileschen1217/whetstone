#!/usr/bin/env bash
# AC-1: line.md ≤ 30 lines; Boundary holds the fixed sentences; the diff/Today fallback is gone; U1's phrases stay.
f=skills/line.md; [ -f "$f" ] || { echo "no $f"; exit 1; }
[ "$(wc -l < "$f")" -le 30 ] || { echo "$f over 30 lines"; exit 1; }
b="$(awk '/^## Boundary/{on=1;next} /^## /{on=0} on' "$f")"
for p in "read from the system page under .whetstone/memory/ when the project has one; otherwise from the Outside: line of the accepted epic.md" \
         "code in this repo, another unit and a later epic are inside the boundary" \
         "with neither page, the other end of an exchange is a person or a thing outside the repo, and the page says which it took"; do
  printf '%s' "$b" | grep -qF -- "$p" || { echo "Boundary lacks: $p"; exit 1; }
done
grep -qF -- "a format or a name that only code inside the boundary reads fixes no cell" "$f" || { echo "lacks: only code inside the boundary reads"; exit 1; }
grep -q 'Outside:' skills/intent/SKILL.md && grep -qi 'round one' skills/intent/SKILL.md || { echo "intent lacks the Outside: line"; exit 1; }
for p in "the unit's diff" "modules under Today"; do
  if printf '%s' "$b" | grep -qF -- "$p"; then echo "Boundary still names: $p"; exit 1; fi
done
for p in "carry on without an error and leave a wrong value or a lost record" "leaves state outside this diff" \
         "changes what a reader outside this diff sees" "which end" "a number or a threshold" "a name or a message a user sees" \
         "inside and outside" "not there or fails" "module" "algorithm"; do
  grep -qF -- "$p" "$f" || { echo "$f lost U1's phrase: $p"; exit 1; }
done
