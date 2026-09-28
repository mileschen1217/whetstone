---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*AC-?3(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:DISPUTED|disput)'
flags: m
---
