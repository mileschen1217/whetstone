#!/usr/bin/env bash
# AC-6: manifests 0.1.4; CHANGELOG names the walk after each fix; BASELINE section has the skill-arm line and `one in, no out`.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do grep -q '"version": *"0.1.4"' "$f" || { echo "$f not 0.1.4"; exit 1; }; done
awk '/^## Unreleased/{on=1;next} /^## /{on=0} on' CHANGELOG.md | grep -qiE 'walk after each fix|after each fix' || { echo "CHANGELOG Unreleased does not name the walk after each fix"; exit 1; }
sec="$(awk '/^# A walk after each fix/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"; [ -n "$sec" ] || { echo "no BASELINE section"; exit 1; }
printf '%s' "$sec" | grep -qE 'skill arm: [0-9] of 6' || { echo "no skill arm line"; exit 1; }
printf '%s' "$sec" | grep -qF 'one in, no out' || { echo "no one-in-no-out note"; exit 1; }
