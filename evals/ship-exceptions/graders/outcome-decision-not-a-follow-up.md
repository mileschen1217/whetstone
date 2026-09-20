---
type: regex
target: { source: file, path: log.md }
pattern: 'FOLLOW-UP[^\n]*(decision|JSON)'
flags: i
match: not_contains
---
