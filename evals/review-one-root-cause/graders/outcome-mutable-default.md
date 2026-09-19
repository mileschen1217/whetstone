---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- (?=.*orders\.py:\d+)(?=.*(mutable|shared|default))'
flags: im
---
