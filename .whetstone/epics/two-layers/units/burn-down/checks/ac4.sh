#!/usr/bin/env bash
# AC-4: ship's blocking rule counts only rows under Needs the owner.
grep -qE 'blocks when it is under `Needs the owner`, its follow-up is `required` and it is not a decision' skills/ship/SKILL.md || { echo "ship's blocking rule does not name Needs the owner"; exit 1; }
