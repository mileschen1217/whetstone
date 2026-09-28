#!/usr/bin/env bash
# AC-3: with the step entered, line.md's test 1 tags an open-after-second-read finding required: silent and a closed one logged; else line.md unchanged.
e="$(awk '/^# A reader of the fixes/{on=1;next} /^# /{on=0} on' evals/BASELINE.md | grep -oE 'burn-down entered: (yes|no)' | head -1 | awk '{print $3}')"
[ -n "$e" ] || { echo "no entered line"; exit 1; }
if [ "$e" = yes ]; then
  t1="$(awk '/^1\. /{on=1} /^2\. /{on=0} on' skills/line.md)"
  printf '%s' "$t1" | grep -qiE 'open' && printf '%s' "$t1" | grep -qiE 'second read' && printf '%s' "$t1" | grep -qF 'required: silent' && printf '%s' "$t1" | grep -qiE 'closed finding[^.;]*logged' || { echo "line.md test 1 lacks the open-finding sentence"; exit 1; }
else
  git diff --quiet burn-down-accepted -- skills/line.md || { echo "line.md changed with entered: no"; exit 1; }
fi
exit 0
