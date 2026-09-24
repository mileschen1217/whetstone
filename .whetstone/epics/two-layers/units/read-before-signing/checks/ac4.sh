#!/usr/bin/env bash
# AC-4: review names a brief as a subject, picks lens/brief.md, writes brief-review.md in the fixed line form; brief has Done looks like: and answered:.
r=skills/review/SKILL.md; b=skills/brief/SKILL.md
for p in "brief.md" "lens/brief.md" "brief-review.md" "no red AC"; do grep -qF -- "$p" "$r" || { echo "review lacks: $p"; exit 1; }; done
grep -qE 'brief\.md:<line>|brief\.md:[0-9]' "$r" || { echo "review lacks the brief.md:<line> form"; exit 1; }
grep -qF -- "Done looks like" "$b" || { echo "brief lacks: Done looks like"; exit 1; }
grep -qF -- "For the builder" "$b" || { echo "brief lacks: For the builder"; exit 1; }
grep -qE 'B-n <question>|question' "$b" || { echo "brief lacks the question-title decision form"; exit 1; }
grep -qE 'taken:|採用' "$b" || { echo "brief lacks the taken/not taken sub-lines"; exit 1; }
grep -qF -- "answered:" "$b" || { echo "brief lacks: answered:"; exit 1; }
