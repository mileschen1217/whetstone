#!/usr/bin/env bash
# AC-2: the real run on the U2 unit directory at 6ee3167 (verdict rewritten by the changed verify.sh): blocks only, fixed lines in order,
# Decision line leads with From ids, carries the B-n question titles and REQ-n sentences and no taken line; no Evidence line; a Note line iff the verdict Note minus provenance is not empty; options one per line, ★ first; Acceptance criterion whole.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"; p="$m/layered/pr-written-back-3.md"
[ -n "$m" ] && [ -f "$p" ] || { echo "no pr-written-back-3.md"; exit 1; }
t="$(mktemp -d)"; u=.whetstone/epics/two-layers/units/read-before-signing
git show 6ee3167:$u/brief.md > "$t/brief.md" 2>/dev/null || { echo "cannot read the brief at 6ee3167"; exit 1; }
git show 6ee3167:.whetstone/epics/two-layers/epic.md > "$t/epic.md"
v="$m/runs-written-back/real-run/verdict-6ee3167-rewritten-3.md"; [ -f "$v" ] || { echo "no rewritten verdict beside the run"; exit 1; }
python3 - "$p" "$t/brief.md" "$t/epic.md" "$v" <<'PY'
import re, sys, os
page, brief, epic, verdict = [open(a, encoding="utf-8").read() for a in sys.argv[1:5]]
notes = {}
for l in verdict.splitlines():
    m = re.match(r"\| (AC-\d+) \| [^|]* \| [^|]* \| [^|]* \| ([^|]*)\|", l)
    if m: notes[m.group(1)] = re.sub(r"from evidence/[^;]*not run here;?\s*", "", m.group(2)).strip()
crit = {}; frm = {}
for l in brief.splitlines():
    m = re.match(r"\| (AC-\d+) \| (.*?) \| ([^|]*) \| `", l)
    if m: crit[m.group(1)] = m.group(2).strip(); frm[m.group(1)] = [x.strip() for x in m.group(3).split(",")]
titles = {m.group(1): m.group(2) for m in re.finditer(r"\*\*(B-\d+) ([^*]+)\*\*", brief)}
taken = {m.group(1): m.group(2).strip() for m in re.finditer(r"\*\*(B-\d+) [^*]+\*\*[^\n]*\n\s*- (?:採用|taken)[：:]\s*(.*)", brief)}
reqs = {m.group(1): m.group(2).strip() for m in re.finditer(r"^- (REQ-\d+)[：:]\s*(.*)$", epic, re.M)}
body = page.split("## Needs the owner", 1)[1] if "## Needs the owner" in page else ""
if not body: print("no Needs the owner heading"); sys.exit(1)
if re.search(r"^\|", body, re.M): print("a table under the headings"); sys.exit(1)
blocks = re.split(r"^### ", body, flags=re.M)[1:]
if not blocks: print("no blocks"); sys.exit(1)
LAB = [("決定", "Decision"), ("註記", "Note"), ("選項", "Options"), ("驗收條件", "Acceptance criterion")]
def line(block, i):
    m = re.search(r"^- (?:%s|%s)[：:]\s*(.*)$" % LAB[i], block, re.M); return m.group(1) if m else None
bad = False; n = 0
for bl in blocks:
    head = bl.splitlines()[0]; m = re.match(r"(AC-\d+) ", head)
    if not m: continue
    ac = m.group(1); n += 1
    dec, note, opt, cr = (line(bl, i) for i in range(4))
    if None in (dec, cr) or not re.search(r"^- (?:選項|Options)[：:]", bl, re.M): print(ac, "block lacks a fixed line"); bad = True; continue
    if re.search(r"^- (?:證據|Evidence)[：:]", bl, re.M): print(ac, "block has an Evidence line"); bad = True
    want = notes.get(ac, "")
    if want and (note is None or want[:30] not in note): print(ac, "Note line missing or lacks the verdict note"); bad = True
    if not want and note is not None: print(ac, "Note line present with nothing to note"); bad = True
    zh = "決定" in bl
    pos = [bl.find(x) for x in (("決定", "選項", "驗收條件") if zh else ("Decision", "Options", "Acceptance criterion"))]
    if pos != sorted(pos): print(ac, "lines out of order"); bad = True
    if note is not None and not (pos[0] < bl.find("註記" if zh else "Note") < pos[1]): print(ac, "Note line not between Decision and Options"); bad = True
    ids = frm.get(ac, [])
    if not dec.startswith(ids[0]): print(ac, "Decision line does not start with", ids[0]); bad = True
    for i in ids:
        if i.startswith("B-") and (i not in titles or titles[i][:12] not in dec): print(ac, "Decision line lacks the question of", i); bad = True
        if i.startswith("REQ-") and (i not in reqs or reqs[i][:20] not in dec): print(ac, "Decision line lacks the sentence of", i); bad = True
        if i.startswith("B-") and i in taken and taken[i][:15] in dec: print(ac, "Decision line copies the taken line of", i); bad = True
    opts = re.findall(r"^[ \t]+- (.*)$", bl, re.M)
    if len(opts) < 2 or not opts[0].lstrip().startswith("★"): print(ac, "options not one per line with ★ first"); bad = True
    if re.search(r"^- (?:選項|Options)[：:]\s*\S", bl, re.M): print(ac, "an option on the Options label line"); bad = True
    if crit.get(ac, "\0")[:40] not in cr: print(ac, "Acceptance criterion line lacks the criterion whole"); bad = True
    if "★" not in bl: print(ac, "no ★ option"); bad = True
print(n, "verdict blocks checked"); sys.exit(1 if bad or n == 0 else 0)
PY
