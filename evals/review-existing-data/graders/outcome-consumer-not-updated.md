---
type: regex
target: { source: file, path: review.md }
pattern: '^- (?=.*(importer|load_records))(?=.*(qty|quantity|KeyError|field|key)).*\.\w+:\d+'
flags: im
---
