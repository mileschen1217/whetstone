#!/usr/bin/env bash
# AC-4: brief fixes the owner-first parts, the question-title decision form, the sub-lines and the live inputs: line; no review step.
b=skills/brief/SKILL.md
for p in "## Goal" "## Done looks like" "## Decisions" "## Out of scope" "## For the builder" "live inputs:"; do grep -qF -- "$p" "$b" || { echo "brief lacks: $p"; exit 1; }; done
python3 - "$b" <<'PY' || { echo "brief: parts out of order"; exit 1; }
import sys; t=open(sys.argv[1]).read(); idx=[t.find(h) for h in ("## Goal","## Done looks like","## Decisions","## Out of scope","## For the builder")]
sys.exit(0 if all(i>=0 for i in idx) and idx==sorted(idx) else 1)
PY
grep -qE 'B-n <question>|question' "$b" || { echo "brief lacks the question-title decision form"; exit 1; }
grep -qE 'taken:|採用' "$b" || { echo "brief lacks the taken/not taken sub-lines"; exit 1; }
grep -qF -- "brief-review.md" "$b" && { echo "brief still names brief-review.md"; exit 1; }
grep -qF -- "answered:" "$b" && { echo "brief still names the answered: line"; exit 1; }
exit 0
