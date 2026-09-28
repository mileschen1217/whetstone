#!/usr/bin/env bash
# AC-8: manifests 0.1.4; CHANGELOG Unreleased names the burn-down reader; BASELINE section with its table, three counts, entered line, the natural-rate sentence and the real burn-downs.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do grep -q '"version": *"0.1.4"' "$f" || { echo "$f not 0.1.4"; exit 1; }; done
awk '/^## Unreleased/{on=1;next} /^## /{on=0} on' CHANGELOG.md | grep -qiE 'burn-?down' || { echo "CHANGELOG Unreleased does not name the burn-down"; exit 1; }
sec="$(awk '/^# A reader of the fixes/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"; [ -n "$sec" ] || { echo "no BASELINE section"; exit 1; }
[ "$(printf '%s\n' "$sec" | grep -cE '^\| m[1-6] \|')" -eq 6 ] || { echo "table lacks six material rows"; exit 1; }
printf '%s' "$sec" | grep -qE 'readers correct: [0-9]+ of 6' && printf '%s' "$sec" | grep -qE 'readers correct bare: [0-9]+ of 6' && printf '%s' "$sec" | grep -qE 'reader text Δ: [+-]?[0-9]+' && printf '%s' "$sec" | grep -qE 'burn-down entered: (yes|no)' || { echo "missing a count line, the Δ line or the entered line"; exit 1; }
printf '%s' "$sec" | grep -qiE 'natural rate.*not measured|not measured.*natural rate' || { echo "no sentence saying the natural rate is not measured"; exit 1; }
printf '%s' "$sec" | grep -qiE 'line|boundary' && printf '%s' "$sec" | grep -qiE 'read-before-signing' && printf '%s' "$sec" | grep -qiE 'written-back' || { echo "the three real burn-downs are not named"; exit 1; }
