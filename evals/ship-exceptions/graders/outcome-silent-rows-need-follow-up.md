---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*api\.py(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?required'
flags: mi
---
