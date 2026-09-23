#!/usr/bin/env bash
# AC-8: both manifests at 0.1.3; CHANGELOG has a 0.1.3 entry naming line.md.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do
  grep -qE '"version":\s*"0\.1\.3"' "$f" || { echo "$f not 0.1.3"; exit 1; }
done
awk '/^## 0\.1\.3/{on=1;next} /^## /{on=0} on' CHANGELOG.md | grep -q 'line\.md' || { echo "CHANGELOG: no 0.1.3 entry naming line.md"; exit 1; }
