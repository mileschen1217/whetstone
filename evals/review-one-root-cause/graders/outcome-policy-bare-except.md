---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- (?=.*pricing\.py:\d+)(?=.*except)'
flags: im
---
