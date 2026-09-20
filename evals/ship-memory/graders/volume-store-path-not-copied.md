---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?=[^\n]*\|\s*`?memory)[^\n]*INVENTORY_STORE'
flags: im
match: not_contains
---
