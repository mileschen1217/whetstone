"""Shared shape test for a layered page. Usage: shape.py <page.md> [--count] [--require <id> ...]
Passes when: heading `Needs the owner` once, heading `Record` once; with --count, the `Decisions needed: n`
line equals the table rows under the first heading; no line outside the parts (fenced blocks, frontmatter,
headings, list items, table rows, `Goal:`/`**Goal**`, `Decisions needed:`, `PASS with`, `none`, `Out of scope`,
prose lines are allowed only in a brief's Goal and worked-example parts, counted by prose_lines());
with --require, each id appears in some table row. Prints prose line count."""
import re, sys
args = sys.argv[1:]; path = args[0]; count = "--count" in args
req = [a for i, a in enumerate(args) if i > 0 and args[i - 1] == "--require"]
lines = open(path).read().splitlines()

def prose_lines(lines):
    n, fence, fm = 0, False, False
    for i, l in enumerate(lines):
        if l.startswith("```"): fence = not fence; continue
        if fence: continue
        if l.strip() == "---" and (i == 0 or fm): fm = not fm; continue
        if fm or not l.strip(): continue
        if re.match(r"^(#|\||- |\d+\. |\*\*Goal\*\*|Goal:|Decisions needed:|PASS with|none$|Out of scope|Memory candidates)", l): continue
        n += 1
    return n

def rows_under(heading):
    out, on = [], False
    for l in lines:
        if l.startswith("#"): on = heading in l; continue
        if on and l.startswith("|") and not re.match(r"^\|\s*-", l) and not re.match(r"^\|\s*(Item|AC)\s*\|", l): out.append(l)
    return out

ok = True
for h in ("Needs the owner", "Record"):
    c = sum(1 for l in lines if l.startswith("#") and h in l)
    if c != 1: print(f"heading {h!r} appears {c} times"); ok = False
if count:
    m = [re.search(r"Decisions needed:\s*(\d+)", l) for l in lines]; m = [x for x in m if x]
    n = int(m[0].group(1)) if m else None
    rows = rows_under("Needs the owner")
    if n is None: print("no Decisions needed line"); ok = False
    elif n == 0 and not any(l.strip() == "none" for l in lines): print("n=0 but no `none`"); ok = False
    elif n != len(rows): print(f"Decisions needed {n} but {len(rows)} rows above the line"); ok = False
allrows = rows_under("Needs the owner") + rows_under("Record")
for r in req:
    if not any(r in l for l in allrows): print(f"{r} in no table row"); ok = False
print("prose", prose_lines(lines))
sys.exit(0 if ok else 1)
