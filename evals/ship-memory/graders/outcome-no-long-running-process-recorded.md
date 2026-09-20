---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?=[^\n]*memory)[^\n]*(long-running|background|next CLI run)'
flags: im
---
