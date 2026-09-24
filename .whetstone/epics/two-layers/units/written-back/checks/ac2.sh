#!/usr/bin/env bash
# AC-2: the real run on the U2 unit directory at 6ee3167 (verdict rewritten by the changed verify.sh): blocks only, fixed lines in order,
# Decision line leads with From ids, carries the B-n question titles and REQ-n sentences and no taken line; Evidence carries the evidence file's line before exit:; Acceptance criterion whole.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"; p="$m/layered/pr-written-back-2.md"
[ -n "$m" ] && [ -f "$p" ] || { echo "no pr-written-back-2.md"; exit 1; }
t="$(mktemp -d)"; u=.whetstone/epics/two-layers/units/read-before-signing
git show 6ee3167:$u/brief.md > "$t/brief.md" 2>/dev/null || { echo "cannot read the brief at 6ee3167"; exit 1; }
git show 6ee3167:.whetstone/epics/two-layers/epic.md > "$t/epic.md"
mkdir -p "$t/evidence"; for a in 1 5 6 7; do git show 6ee3167:$u/evidence/AC-$a.log > "$t/evidence/AC-$a.log" 2>/dev/null; done
python3 - "$p" "$t/brief.md" "$t/epic.md" "$t/evidence" <<'PY'
import re, sys, os
page, brief, epic = [open(a, encoding="utf-8").read() for a in sys.argv[1:4]]; evdir = sys.argv[4]
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
LAB = [("決定", "Decision"), ("證據", "Evidence"), ("選項", "Options"), ("驗收條件", "Acceptance criterion")]
def line(block, i):
    m = re.search(r"^- (?:%s|%s)[：:]\s*(.*)$" % LAB[i], block, re.M); return m.group(1) if m else None
bad = False; n = 0
for bl in blocks:
    head = bl.splitlines()[0]; m = re.match(r"(AC-\d+) ", head)
    if not m: continue
    ac = m.group(1); n += 1
    dec, evd, opt, cr = (line(bl, i) for i in range(4))
    if None in (dec, evd, cr) or not re.search(r"^- (?:選項|Options)[：:]", bl, re.M): print(ac, "block lacks a fixed line"); bad = True; continue
    zh = "決定" in bl
    pos = [bl.find(x) for x in (("決定", "證據", "選項", "驗收條件") if zh else ("Decision", "Evidence", "Options", "Acceptance criterion"))]
    if pos != sorted(pos): print(ac, "lines out of order"); bad = True
    ids = frm.get(ac, [])
    if not dec.startswith(ids[0]): print(ac, "Decision line does not start with", ids[0]); bad = True
    for i in ids:
        if i.startswith("B-") and (i not in titles or titles[i][:12] not in dec): print(ac, "Decision line lacks the question of", i); bad = True
        if i.startswith("REQ-") and (i not in reqs or reqs[i][:20] not in dec): print(ac, "Decision line lacks the sentence of", i); bad = True
        if i.startswith("B-") and i in taken and taken[i][:15] in dec: print(ac, "Decision line copies the taken line of", i); bad = True
    ev = os.path.join(evdir, ac + ".log")
    if os.path.exists(ev):
        lines = [l for l in open(ev, encoding="utf-8").read().splitlines() if l.strip()]
        obs = lines[-2] if len(lines) >= 2 and lines[-1].startswith("exit:") else ""
        if obs and obs[:40] not in evd: print(ac, "Evidence line lacks the evidence file's line before exit:"); bad = True
    if crit.get(ac, "\0")[:40] not in cr: print(ac, "Acceptance criterion line lacks the criterion whole"); bad = True
    if "★" not in bl: print(ac, "no ★ option"); bad = True
print(n, "verdict blocks checked"); sys.exit(1 if bad or n == 0 else 0)
PY
