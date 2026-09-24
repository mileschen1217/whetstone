#!/usr/bin/env bash
# AC-5: manifests 0.1.4; CHANGELOG Unreleased names the ship page's blocks; BACKLOG's Text entry says it is done in unit written-back.
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json; do grep -q '"version": *"0.1.4"' "$f" || { echo "$f not 0.1.4"; exit 1; }; done
awk '/^## Unreleased/{on=1;next} /^## /{on=0} on' CHANGELOG.md | grep -qi 'block' || { echo "CHANGELOG Unreleased does not name the blocks"; exit 1; }
awk '/^### The ship page.s Text column/{on=1;next} /^### /{on=0} on' BACKLOG.md | grep -qi 'written-back' || { echo "BACKLOG Text entry does not name unit written-back"; exit 1; }
