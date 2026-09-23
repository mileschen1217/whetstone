#!/usr/bin/env bash
# AC-7: both manifests at 0.1.4; CHANGELOG has a 0.1.4 entry naming line.md and the boundary.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do
  grep -qE '"version":\s*"0\.1\.4"' "$f" || { echo "$f not 0.1.4"; exit 1; }
done
e="$(awk '/^## 0\.1\.4/{on=1;next} /^## /{on=0} on' CHANGELOG.md)"
printf '%s' "$e" | grep -q 'line\.md' && printf '%s' "$e" | grep -qi 'boundary' || { echo "CHANGELOG: no 0.1.4 entry naming line.md and the boundary"; exit 1; }
