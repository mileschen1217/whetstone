---
type: regex
target: { source: file, path: out/pr.md }
pattern: 'Recommendation[^\n]*(JSON|decision)'
flags: i
match: not_contains
---
