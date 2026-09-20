---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- (?!.*[\w/]+\.\w+:\d+)'
flags: m
match: not_contains
---
