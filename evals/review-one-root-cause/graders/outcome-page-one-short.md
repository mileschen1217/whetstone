---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- (?=.*paging\.py:\d+)(?=.*(size ?- ?1|one (item|fewer|short|less)|off.by.one|drops|last item|missing))'
flags: im
---
