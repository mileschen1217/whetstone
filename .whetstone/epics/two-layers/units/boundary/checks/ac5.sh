#!/usr/bin/env bash
# AC-5: brief 3 trials and intent 2 trials still pass unit line's form checks.
[ -n "${BRIEF_RUN:-}" ] && [ -n "${INTENT_RUN:-}" ] || { echo "BRIEF_RUN or INTENT_RUN not set"; exit 1; }
for i in 1 2 3; do
  g="$BRIEF_RUN/skill-t$i/grade.json"; b="$BRIEF_RUN/skill-t$i/work/brief.md"; [ -f "$g" ] && [ -f "$b" ] || { echo "brief trial $i missing"; exit 1; }
  python3 - "$g" <<'PY' || exit 1
import json, sys; d = json.load(open(sys.argv[1])); bad = []
if d["green_before_the_work"]: bad.append("green before")
if d["without_check"]: bad.append("without check")
if d["mutants_killed"] != d["mutants_total"]: bad.append("mutants %s/%s" % (d["mutants_killed"], d["mutants_total"]))
print("\n".join(bad)); sys.exit(1 if bad else 0)
PY
  bn="$(grep -cE '^- \**B-[0-9]+' "$b")"; ok="$(grep -E '^- \**B-[0-9]+' "$b" | grep -cE '\[(silent|state|reader|logged)\] *\[(AC-[0-9]+[^]]*|no check)\] *$')"
  [ "$bn" -ge 1 ] && [ "$ok" -eq "$bn" ] || { echo "brief trial $i: $ok of $bn B-n lines in form"; exit 1; }
done
for i in 1 2; do
  e="$(ls "$INTENT_RUN"/skill-epic-t$i/work/.whetstone/epics/*/epic.md 2>/dev/null | head -1)"; [ -n "$e" ] || { echo "intent trial $i: no epic.md"; exit 1; }
  grep -qE 'Decisions needed:\s*[0-9]+' "$e" && grep -q '^### Needs the owner' "$e" && grep -q '^### Record' "$e" || { echo "intent trial $i: no count line or headings"; exit 1; }
  grep -qE '^(- )?\**Outside\**:\s*\S' "$e" || { echo "intent trial $i: no Outside: line"; exit 1; }
  dn="$(grep -cE '^- \**D-[0-9]+' "$e")"; ok="$(grep -E '^- \**D-[0-9]+' "$e" | grep -cE '\[(silent|state|reader|logged)\] *$')"
  [ "$dn" -ge 1 ] && [ "$ok" -eq "$dn" ] || { echo "intent trial $i: $ok of $dn D-n lines tagged"; exit 1; }
done
