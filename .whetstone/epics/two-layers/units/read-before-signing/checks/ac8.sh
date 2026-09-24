#!/usr/bin/env bash
# AC-8: manifests stay 0.1.4; CHANGELOG Unreleased names the reader; BASELINE section with the numbers.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do grep -qE '"version":\s*"0\.1\.4"' "$f" || { echo "$f not 0.1.4 (the version is bumped at the epic's end, not here)"; exit 1; }; done
awk '/^## Unreleased/{on=1;next} /^## /{on=0} on' CHANGELOG.md | grep -qiE 'review|reader' || { echo "CHANGELOG: no Unreleased entry naming the brief reviewer"; exit 1; }
s="$(awk '/^# A reader before the brief is signed/{on=1;next} /^# /{on=0} on' evals/BASELINE.md)"; [ -n "$s" ] || { echo "BASELINE: no section"; exit 1; }
for p in "both plants found in" "false gaps" "USD" "reader entered:" "rows above the line"; do printf '%s' "$s" | grep -qF -- "$p" || { echo "section lacks: $p"; exit 1; }; done
