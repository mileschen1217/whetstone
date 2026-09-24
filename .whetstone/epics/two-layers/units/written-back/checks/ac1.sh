#!/usr/bin/env bash
# AC-1: ship's part 3 is blocks with the fixed labelled lines (Decision = question title only); no table; ≤ 70 lines.
f=skills/ship/SKILL.md
[ "$(wc -l < "$f")" -le 70 ] || { echo "$f over 70 lines"; exit 1; }
for p in "### " "決定" "Decision" "選項" "Options" "驗收條件" "Acceptance criterion" "發現" "Finding" "建置決定" "陳述" "Statement" "From" "question title" "REQ-n" "Goal" "copied whole" "one option per line" "註記" "Note" "not run here"; do grep -qF -- "$p" "$f" || { echo "ship lacks: $p"; exit 1; }; done
grep -qiE 'no From column|without a From column' "$f" || { echo "ship does not say what a brief without From gets"; exit 1; }
grep -qiE 'no table|not a table' "$f" || { echo "ship does not rule out the table"; exit 1; }
grep -qi "taken" "$f" && { echo "ship still copies the taken line"; exit 1; }
grep -qE "證據|Evidence" "$f" && { echo "ship still has an Evidence line"; exit 1; }
exit 0
