---
type: regex
target: { source: file, path: review.md }
pattern: '^- (?=.*(seed\.json|seed data|existing|shipped|legacy))(?=.*warehouse).*\.\w+:\d+'
flags: im
---
