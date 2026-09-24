#!/usr/bin/env bash
# AC-5: the two test-2 changes are in line.md (the real-page count moved to the system-page epic, see BACKLOG).
f=skills/line.md
grep -qF -- "not there or fails, across the boundary" "$f" || { echo "line.md lacks: across the boundary on the fourth cell"; exit 1; }
grep -qF -- "a message whose reader is an agent is not a message a person sees" "$f" || { echo "line.md lacks the agent-reader sentence"; exit 1; }
