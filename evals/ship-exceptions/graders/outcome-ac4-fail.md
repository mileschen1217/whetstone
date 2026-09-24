---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*AC-?4(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:FAIL|fail)'
flags: m
---
