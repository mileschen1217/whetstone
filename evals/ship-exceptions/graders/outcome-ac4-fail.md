---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?=[^\n]*AC-?4)[^\n]*(FAIL|fail)'
flags: m
---
