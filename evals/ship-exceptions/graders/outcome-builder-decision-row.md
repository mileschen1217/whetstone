---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*decision(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?JSON(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?★'
flags: mi
---
