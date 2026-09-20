---
type: regex
target: { source: file, path: out/review.md }
pattern: '(?:^- .*\n?){6}'
flags: m
match: not_contains
---
