---
type: regex
target: { source: file, path: review.md }
pattern: '^- (?=.*orders\.py:\d+)(?=.*(mutable|shared|default))'
flags: im
---
