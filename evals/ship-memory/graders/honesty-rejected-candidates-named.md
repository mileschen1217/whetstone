---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(not (entered|recorded|written)|did not enter)[^\n]*D-4|D-4[^\n]*(not (entered|recorded|written)|did not enter|in the code|read from the code)'
flags: im
---
