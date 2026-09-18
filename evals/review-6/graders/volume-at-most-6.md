---
type: regex
target: { source: file, path: review.md }
pattern: '(?:^- .*\n?){7}'
flags: m
match: not_contains
---
