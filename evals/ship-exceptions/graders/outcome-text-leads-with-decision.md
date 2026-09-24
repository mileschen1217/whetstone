---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*AC-?4(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:Decision|決定)[：:]\s*B-1\b[^\n]*expire(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:Criterion|條件)[：:][^\n]*exactly 600 is kept'
flags: m
---
