---
type: regex
target: { source: file, path: out/brief-review.md }
pattern: '(?:^- [^\n]*\n?){5}'
flags: m
match: not_contains
---
