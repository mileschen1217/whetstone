---
type: regex
target: { source: file, path: review.md }
pattern: '(?:^- .*\n?){6}'
flags: m
match: not_contains
---
