---
type: regex
target: { source: file, path: out/brief-review.md }
pattern: '(?:^(?:- |\d+[.)] )[\s\S]*?){4}^(?:- |\d+[.)] )'
flags: m
match: not_contains
---
