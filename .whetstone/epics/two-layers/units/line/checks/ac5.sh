#!/usr/bin/env bash
# AC-5: brief-reservations skill arm, 3 trials: red first, every criterion has a check, 10/10 mutants; B-n lines carry tag and AC ids.
[ -n "${BRIEF_RUN:-}" ] || { echo "BRIEF_RUN not set"; exit 1; }
for i in 1 2 3; do
  g="$BRIEF_RUN/skill-t$i/grade.json"; b="$BRIEF_RUN/skill-t$i/work/brief.md"
  [ -f "$g" ] && [ -f "$b" ] || { echo "trial $i missing"; exit 1; }
  python3 - "$g" <<'PY' || exit 1
import json, sys; d = json.load(open(sys.argv[1])); bad = []
if d["green_before_the_work"]: bad.append("green before: %s" % d["green_before_the_work"])
if d["without_check"]: bad.append("without check: %s" % d["without_check"])
if d["mutants_killed"] != d["mutants_total"]: bad.append("mutants %s/%s" % (d["mutants_killed"], d["mutants_total"]))
print("\n".join(bad)); sys.exit(1 if bad else 0)
PY
  bn="$(grep -cE '^- \**B-[0-9]+' "$b")"; [ "$bn" -ge 1 ] || { echo "trial $i: no B-n lines"; exit 1; }
  ok="$(grep -E '^- \**B-[0-9]+' "$b" | grep -cE '\[(silent|state|reader|logged)\] *\[(AC-[0-9]+[^]]*|no check)\] *$')"
  [ "$ok" -eq "$bn" ] || { echo "trial $i: $ok of $bn B-n lines end with [tag] [AC-…|no check]"; exit 1; }
done
