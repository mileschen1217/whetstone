---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- .*(api\.py|CHANGELOG\.md):\d+.*(changelog|signature)'
flags: im
---
