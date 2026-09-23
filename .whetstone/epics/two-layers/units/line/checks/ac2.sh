#!/usr/bin/env bash
# AC-2: the three skills name the two headings, the count line and `none`; ship still names every non-green kind.
for s in intent brief ship; do
  for p in "Needs the owner" "Record" "Decisions needed:" "none"; do
    grep -qF -- "$p" "skills/$s/SKILL.md" || { echo "$s lacks: $p"; exit 1; }
  done
done
for p in "other than \`PASS\`" "note is not empty" "each finding" "decisions.md" "memory"; do
  grep -qF -- "$p" skills/ship/SKILL.md || { echo "ship lacks: $p"; exit 1; }
done
