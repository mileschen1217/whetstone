#!/usr/bin/env bash
# AC-3: the brief lens is retired; review's SKILL.md is the epic branch's; brief's Where column carries the live definition (B-6).
[ ! -e skills/review/lens/brief.md ] || { echo "skills/review/lens/brief.md still exists"; exit 1; }
git diff --quiet two-layers-epic -- skills/review/SKILL.md || { echo "skills/review/SKILL.md differs from two-layers-epic"; exit 1; }
b=skills/brief/SKILL.md
grep -qE '`live` when no command run here can decide it' "$b" || { echo "brief Where column lacks the live definition"; exit 1; }
for p in "a target" "a paid run" "person's written decision" "evidence file"; do grep -qF -- "$p" "$b" || { echo "brief Where column lacks: $p"; exit 1; }; done
