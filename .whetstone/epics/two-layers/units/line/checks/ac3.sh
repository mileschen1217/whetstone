#!/usr/bin/env bash
# AC-3: brief says each B-n ends with the AC ids that go red when it is ignored, or `no check`.
grep -qF -- "no check" skills/brief/SKILL.md || { echo "brief lacks: no check"; exit 1; }
grep -qE -- 'B-n.*(AC-n|\[AC-)' skills/brief/SKILL.md || { echo "brief does not tie B-n to AC-n"; exit 1; }
