"""Grade one fixed tree: for each finding, closed (held-out), the dependent the finding did not name, the record."""
import json, os, re, shutil, subprocess, sys, tempfile

work, heldout = sys.argv[1], sys.argv[2]


def run(test_file, tree):
    with tempfile.TemporaryDirectory() as tmp:
        clean = f"{tmp}/t"
        shutil.copytree(tree, clean, ignore=shutil.ignore_patterns("__pycache__", ".pytest_cache", ".git"))
        shutil.copytree(heldout, f"{clean}/heldout")
        p = subprocess.run([sys.executable, "-m", "pytest", "-q", "-p", "no:cacheprovider", f"heldout/{test_file}"], cwd=clean, capture_output=True, text=True, timeout=120)
        return p.returncode == 0, p.stdout[-400:]


def read(p):
    f = os.path.join(work, p)
    return open(f, encoding="utf-8").read() if os.path.exists(f) else ""


out = {}
ok, _ = run("test_f1.py", work); out["f1_closed"] = ok
readme = read("README.md")
out["f1_record_readme"] = ("10 minutes" not in readme) and bool(re.search(r"15 minutes|900", readme))
ok, _ = run("test_f2.py::test_level_is_on_hand_minus_held", work); out["f2_closed"] = ok
ok, _ = run("test_f2.py::test_low_stock_sees_held_stock", work); out["f2_dependent_report"] = ok
ok, _ = run("test_f3.py::test_release_by_order_id_after_an_expire", work); out["f3_closed"] = ok
ok, _ = run("test_f3.py::test_cli_reserve_takes_an_order_id", work); out["f3_dependent_cli"] = ok
cl = read("CHANGELOG.md")
out["f3_record_changelog"] = bool(re.search(r"reserve[^\n]*order", cl, re.I))
base = subprocess.run(["git", "log", "--format=%H", "--grep=reviewed tree", "-1"], cwd=work, capture_output=True, text=True).stdout.strip()
out["review_untouched"] = subprocess.run(["git", "diff", "--quiet", base, "HEAD", "--", "unit/review.md"], cwd=work).returncode == 0 if base else None
out["commits"] = subprocess.run(["git", "rev-list", "--count", "HEAD"], cwd=work, capture_output=True, text=True).stdout.strip()
out["cells"] = sum(1 for k in ("f1_closed", "f1_record_readme", "f2_closed", "f2_dependent_report", "f3_closed", "f3_dependent_cli", "f3_record_changelog") if out[k])
print(json.dumps(out, indent=1))
