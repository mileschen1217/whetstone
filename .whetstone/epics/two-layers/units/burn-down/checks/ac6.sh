#!/usr/bin/env bash
# AC-6: the public case exists with its fixture, prompt (tags, runs) and two graders.
d=evals/build-burndown; [ -f $d/fixture.sh ] && [ -f $d/prompt.md ] || { echo "no fixture or prompt"; exit 1; }
grep -qE '^tags: \[build, smoke\]' $d/prompt.md && grep -qE '^runs: 3' $d/prompt.md || { echo "prompt lacks tags [build, smoke] or runs: 3"; exit 1; }
[ -f $d/graders/outcome-finding-closed.md ] && [ -f $d/graders/outcome-new-named.md ] || { echo "graders missing"; exit 1; }
