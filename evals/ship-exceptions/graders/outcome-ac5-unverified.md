---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?=[^\n]*AC-?5)[^\n]*(UNVERIFIED|unverified|not (been )?(run|verified))'
flags: m
---
