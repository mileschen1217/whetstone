---
type: regex
target: { source: file, path: out/brief-review.md }
pattern: '(?:^- [\s\S]*?){4}^- '
flags: m
match: not_contains
---
