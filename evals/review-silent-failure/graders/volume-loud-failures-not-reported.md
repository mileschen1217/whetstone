---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- .*(KeyError|IndexError)'
flags: m
match: not_contains
---
