#!/usr/bin/env bash
# AC-3: lens/brief.md exists, ≤ 12 lines, names the four verdict words and clean; the assembled lens ≤ 80 lines.
f=skills/review/lens/brief.md; [ -f "$f" ] || { echo "no $f"; exit 1; }
[ "$(wc -l < "$f")" -le 12 ] || { echo "$f over 12 lines"; exit 1; }
for p in "under" "over" "no red AC" "live" "evidence" "clean"; do grep -qF -- "$p" "$f" || { echo "$f lacks: $p"; exit 1; }; done
t=$(( $(wc -l < skills/review/lens/generic.md) + $(wc -l < "$f") + $(wc -l < templates/REVIEW.md) )); [ "$t" -le 80 ] || { echo "assembled lens $t lines > 80"; exit 1; }
