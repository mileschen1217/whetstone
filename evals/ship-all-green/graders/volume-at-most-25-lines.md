---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?:[^\n]*\n){26}'
flags: m
match: not_contains
---
