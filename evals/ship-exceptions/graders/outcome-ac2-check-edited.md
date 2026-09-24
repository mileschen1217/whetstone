---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*(?:AC-?2|test_ac2)(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:differs|changed|edited|modified|tightened)'
flags: m
---
