#!/usr/bin/env bash
# AC-1: line.md exists, ≤ 30 lines, holds the fixed sentences; three skills read it; no SKILL.md holds a tag sentence.
f=skills/line.md; [ -f "$f" ] || { echo "no $f"; exit 1; }
[ "$(wc -l < "$f")" -le 30 ] || { echo "$f over 30 lines"; exit 1; }
for p in "carry on without an error and leave a wrong value or a lost record" "leaves state outside this diff" \
         "changes what a reader outside this diff sees" "which end" "a number or a threshold" "a name or a message a user sees" \
         "inside and outside" "not there or fails" "module" "algorithm" ".whetstone/memory/" "Today"; do
  grep -qF -- "$p" "$f" || { echo "$f lacks: $p"; exit 1; }
done
for s in intent brief ship; do grep -q 'line\.md' "skills/$s/SKILL.md" || { echo "$s does not name line.md"; exit 1; }; done
for p in "carry on without an error" "state outside this diff" "reader outside this diff sees"; do
  if grep -lF -- "$p" skills/*/SKILL.md; then echo "tag sentence still in a SKILL.md: $p"; exit 1; fi
done
