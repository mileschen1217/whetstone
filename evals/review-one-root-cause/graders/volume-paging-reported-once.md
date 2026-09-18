---
type: regex
target: { source: file, path: review.md }
pattern: '^- .*(paging|off.by.one|size ?- ?1)'
flags: im
match: "count:1"
---
