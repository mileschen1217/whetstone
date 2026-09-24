---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*AC-?5(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:evidence|recorded|not run here|on the target)'
flags: mi
---
