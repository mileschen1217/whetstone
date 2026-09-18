---
type: regex
target: { source: file, path: review.md }
pattern: '^- (?=.*(shipping\.py|CHANGELOG\.md):\d+)(?=.*requests)'
flags: im
---
