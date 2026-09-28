#!/usr/bin/env bash
# AC-6: ship 3 cases 6/6; review 5 cases 3/3 result graders; brief 3 trials (form, Done looks like, brief-review.md when entered); intent 2 trials.
[ -n "${SHIP_RUN:-}" ] && [ -n "${BRIEF_RUN:-}" ] && [ -n "${INTENT_RUN:-}" ] || { echo "SHIP_RUN, BRIEF_RUN or INTENT_RUN not set"; exit 1; }
python3 - "$SHIP_RUN/aggregate-result.json" <<'PY' || exit 1
import json, sys
d = json.load(open(sys.argv[1])); bad = False; want = {"ship-exceptions": 6, "ship-all-green": 6, "ship-memory": 6, "review-one-root-cause": 3, "review-smoke-clean": 3, "review-smoke-policy": 3, "review-silent-failure": 3, "review-policy-masks-defect": 3}
seen = {}
for c in d["cases"]:
    if c["name"] not in want: continue
    runs = c["arms"].get("with", []); seen[c["name"]] = len(runs)
    for i, r in enumerate(runs):
        for g in r.get("graders", []):
            if g["name"].startswith("path-"): continue
            if not g["passed"]: print(c["name"], "run", i, g["name"], "failed"); bad = True
for k, v in want.items():
    if seen.get(k, 0) < v: print(k, "runs", seen.get(k, 0), "need", v); bad = True
sys.exit(1 if bad else 0)
PY
sec="$(awk '/^# A reader before the brief is signed/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"; e="$(printf '%s' "$sec" | grep -oE 'reader entered: (yes|no)' | head -1)"
for i in 1 2 3; do
  g="$BRIEF_RUN/skill-t$i/grade.json"; b="$BRIEF_RUN/skill-t$i/work/brief.md"; [ -f "$g" ] && [ -f "$b" ] || { echo "brief trial $i missing"; exit 1; }
  python3 -c "import json,sys; d=json.load(open('$g')); sys.exit(0 if not d['green_before_the_work'] and not d['without_check'] and d['mutants_killed']==d['mutants_total'] else 1)" || { echo "brief trial $i: grade failed"; exit 1; }
  bn="$(grep -cE '^- \**B-[0-9]+' "$b")"; ok="$(grep -E '^- \**B-[0-9]+' "$b" | grep -cE '\[(silent|state|reader|logged)\] *\[(AC-[0-9]+[^]]*|no check)\] *$')"
  [ "$bn" -ge 1 ] && [ "$ok" -eq "$bn" ] || { echo "brief trial $i: $ok of $bn B-n title lines in form"; exit 1; }
  tk="$(grep -cE '^\s+- (taken|採用)[:：]' "$b")"; [ "$tk" -ge "$bn" ] || { echo "brief trial $i: $tk taken sub-lines for $bn decisions"; exit 1; }
  for h in "## Goal" "## Done looks like" "## Decisions" "## Out of scope" "## For the builder"; do grep -qF -- "$h" "$b" || { echo "brief trial $i: no $h"; exit 1; }; done
  python3 - "$b" <<'PY2' || { echo "brief trial $i: parts out of order"; exit 1; }
import sys; t=open(sys.argv[1]).read(); idx=[t.find(h) for h in ("## Goal","## Done looks like","## Decisions","## Out of scope","## For the builder")]
sys.exit(0 if all(i>=0 for i in idx) and idx==sorted(idx) else 1)
PY2
  if [ "$e" = "reader entered: yes" ]; then r="$BRIEF_RUN/skill-t$i/work/brief-review.md"; [ -f "$r" ] && grep -qE '^independent:' "$r" || { echo "brief trial $i: no brief-review.md"; exit 1; }; fi
done
for i in 1 2; do
  e2="$(ls "$INTENT_RUN"/skill-epic-t$i/work/.whetstone/epics/*/epic.md 2>/dev/null | head -1)"; [ -n "$e2" ] || { echo "intent trial $i: no epic.md"; exit 1; }
  grep -qE '^(- )?\**Outside\**:\s*\S' "$e2" && grep -qE 'Decisions needed:\s*[0-9]+' "$e2" || { echo "intent trial $i: no Outside: or count line"; exit 1; }
done
