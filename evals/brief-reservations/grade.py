"""Grade one brief. Shape: every criterion has a check command, and the check is red before the
work. Thickness: the checks pass on a reference implementation (under the reading of the open
points that suits them best) and each planted defect makes at least one of them fail. Open points:
for each thing the request left open, is it in the brief at all, and is it flagged for the owner."""
import itertools, json, os, re, shutil, subprocess, sys, tempfile

out, ref = sys.argv[1], sys.argv[2]
work = f"{out}/work"
POLICIES = ["edge-released", "unknown-silent", "reserved-raises", "load-missing-raises"]
MUTANTS = ["reserve-keeps-level", "reserve-not-recorded", "dup-overwrites", "release-keeps-stock", "repeat-raises",
           "repeat-credits-again", "expire-nothing", "expire-young", "expire-keeps-stock", "save-drops-holds"]
OPEN = {  # what the request leaves open: a pattern that shows the brief speaks of it
    "exactly-600": r"exactly (600|ten|10)|(600|ten minutes)[^.\n|]{0,40}(exactly|boundary|inclusive|or more|at least|strictly)|boundary|>= ?600|> ?600",
    "release-unknown-id": r"(never|not|no such|unknown|unrecogni[sz]ed)[^.\n|]{0,40}(reserved|held|hold|order)[^.\n|]{0,80}(raise|error|LookupError|KeyError|silent|no-op|nothing)",
    "duplicate-order-id": r"(already|duplicate|same|second|existing)[^.\n|]{0,60}(order_id|order id|hold|reserv)[^.\n|]{0,80}(raise|error|ValueError|reject|replace|overwrit)",
    "load-missing-path": r"(missing|does not exist|nonexistent|non-existent|absent|no such)[^.\n|]{0,60}(path|file)|(path|file)[^.\n|]{0,40}(missing|does not exist|not exist)",
    "file-format": r"(file |on-disk |storage |save )format|\bJSON\b|serialis|serializ",
    "expired-then-release": r"expire[ds]?[^.\n|]{0,80}(then|later|after|subsequent)[^.\n|]{0,40}release|release[^.\n|]{0,60}(expired|already expired)",
}
brief = open(f"{work}/brief.md").read() if os.path.exists(f"{work}/brief.md") else ""
rows = [[c.strip() for c in l.strip().strip("|").split("|")] for l in brief.splitlines() if re.match(r"\s*\|\s*\**AC-?\d+", l)]
checks = {}
for r in rows:
    m = re.findall(r"`([^`]+)`", r[-1]) or re.findall(r"`([^`]+)`", " ".join(r[2:]))
    checks[re.sub(r"\*", "", r[0])] = m[-1] if m else None
flagged = "\n".join(re.findall(r"(?ims)^#+[^\n]*(?:assum|open|question|decision|unknown|confirm|ambig)[^\n]*\n(.*?)(?=^#+ |\Z)", brief))
flagged += "\n".join(l for l in brief.splitlines() if re.match(r"(?i)\s*\**(assum|open question|to confirm|owner to decide)", l))


def run_all(tree, env):
    res = {}
    for ac, cmd in checks.items():
        if not cmd: res[ac] = None; continue
        try:
            p = subprocess.run(cmd, shell=True, cwd=tree, capture_output=True, text=True, timeout=60, env={**os.environ, "PYTHONPATH": ".", "PYTHONDONTWRITEBYTECODE": "1", **env})
            res[ac] = p.returncode == 0
        except subprocess.TimeoutExpired:
            res[ac] = False
    return res


with tempfile.TemporaryDirectory() as tmp:
    t = f"{tmp}/t"; shutil.copytree(work, t, ignore=shutil.ignore_patterns("__pycache__", ".pytest_cache", ".git"))
    at_base = run_all(t, {})
    shutil.copy(ref, f"{t}/inventory/api.py")
    best, best_pol = None, None
    for n in range(len(POLICIES) + 1):
        for pol in itertools.combinations(POLICIES, n):
            r = run_all(t, {"POLICY": ",".join(pol)})
            if best is None or sum(map(bool, r.values())) > sum(map(bool, best.values())): best, best_pol = r, pol
    good = [ac for ac, ok in best.items() if ok]
    killed = {}
    for mut in MUTANTS:
        r = run_all(t, {"POLICY": ",".join(best_pol), "MUT": mut})
        killed[mut] = [ac for ac in good if not r[ac]]

result = {}
try: result = json.load(open(f"{out}/result.json"))
except Exception: pass
print(json.dumps({
    "criteria": len(rows), "without_check": [ac for ac, c in checks.items() if not c],
    "green_before_the_work": [ac for ac, ok in at_base.items() if ok],
    "reference_policy": best_pol, "fail_on_reference": [ac for ac, ok in best.items() if ok is False],
    "mutants_killed": sum(1 for v in killed.values() if v), "mutants_total": len(MUTANTS), "survivors": [m for m, v in killed.items() if not v],
    "open_points": {k: {"in_brief": bool(re.search(p, brief, re.I)), "flagged": bool(re.search(p, flagged, re.I))} for k, p in OPEN.items()},
    "brief_lines": len(brief.splitlines()), "brief_words": len(brief.split()),
    "check_lines": sum(len(open(os.path.join(d, f)).read().splitlines()) for d, _, fs in os.walk(f"{work}/checks") for f in fs if not f.endswith(".pyc")),
    "cost_usd": result.get("total_cost_usd"), "turns": result.get("num_turns"), "duration_s": round((result.get("duration_ms") or 0) / 1000),
}, indent=1))
