#!/usr/bin/env bash
# AC-7: the public case exists with the fixed parts; 3/3 runs pass every grader.
d=evals/brief-read; [ -f $d/fixture.sh ] && [ -f $d/prompt.md ] || { echo "no $d/fixture.sh or prompt.md"; exit 1; }
grep -qE '^tags:.*\bbrief\b' $d/prompt.md && grep -qE '^tags:.*\brule\b' $d/prompt.md && grep -qE '^runs:\s*3' $d/prompt.md || { echo "prompt.md lacks tags [brief, rule] or runs: 3"; exit 1; }
ls $d/graders/outcome-*.md >/dev/null 2>&1 && ls $d/graders/volume-*.md >/dev/null 2>&1 || { echo "graders outcome-* and volume-* missing"; exit 1; }
[ -n "${CASE_RUN:-}" ] && [ -f "$CASE_RUN/aggregate-result.json" ] || { echo "CASE_RUN not set"; exit 1; }
python3 - "$CASE_RUN/aggregate-result.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); bad = False; seen = False
for c in d["cases"]:
    if c["name"] != "brief-read": continue
    seen = True; runs = c["arms"].get("with", [])
    if len(runs) != 3: print("runs", len(runs)); bad = True
    for i, r in enumerate(runs):
        for g in r.get("graders", []):
            if not g["passed"]: print("run", i, g["name"], "failed"); bad = True
if not seen: print("case brief-read not in the run"); bad = True
sys.exit(1 if bad else 0)
PY
