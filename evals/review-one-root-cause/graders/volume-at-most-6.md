---
type: regex
target: { source: file, path: out/review.md }
pattern: '(?:^- .*\n?){7}'
flags: m
match: not_contains
---
