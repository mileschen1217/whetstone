#!/usr/bin/env bash
# Fixture test for scripts/verify.sh: no agent involved. Builds throwaway repos and asserts on verdict.md.
set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; verify="$here/../../scripts/verify.sh"; bad=0
ok() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; bad=1; fi; }
mk() { d="$(mktemp -d)"; cd "$d"; git init -q .; git config user.name t; git config user.email t@example.invalid
  mkdir checks; printf 'def f():\n    return 0\n' > m.py
  printf 'from m import f\nassert f() == 1\n' > checks/ac1.py; printf 'from m import f\nassert f() is not None\n' > checks/ac2.py
  printf -- '---\nstatus: accepted\n---\n| AC | Behaviour | Check |\n|---|---|---|\n| AC-1 | f returns 1 | `PYTHONPATH=. python3 checks/ac1.py` |\n| AC-2 | f returns something | `PYTHONPATH=. python3 checks/ac2.py` |\n' > brief.md
  git add -A; git commit -qm base; git tag base; }
mk; printf 'def f():\n    return 1\n' > m.py; git commit -qam change; "$verify" brief.md base >/dev/null; c=$?
ok "all checks pass exits 0"            "[ $c -eq 0 ]"
ok "AC-1 PASS"                         "grep -q '| AC-1 | PASS |' verdict.md"
ok "AC-2 flagged green before change"  "grep -q 'AC-2 .*green before the change' verdict.md"
mk; printf 'def f():\n    return 2\n' > m.py; git commit -qam change; "$verify" brief.md base >/dev/null; c=$?
ok "failing check exits 1"             "[ $c -eq 1 ] && grep -q '| AC-1 | FAIL |' verdict.md"
mk; printf 'from m import f\nassert f() == 0\n' > checks/ac1.py; git commit -qam gamed; "$verify" brief.md base >/dev/null; c=$?
ok "edited check: base version is run and it fails" "[ $c -eq 1 ] && grep -q 'AC-1 | FAIL' verdict.md && grep -q 'differs from base' verdict.md"
mk; printf 'def f():\n    return 1\n' > m.py; "$verify" brief.md base >/dev/null 2>&1; c=$?
ok "uncommitted change refuses to run" "[ $c -eq 2 ]"
mk; printf 'def f():\n    return 1\n' > m.py; printf 'AC-1 — the brief and its check disagree\n' > disputed.md; git add -A; git commit -qm change; "$verify" brief.md base >/dev/null; c=$?
ok "disputed is shown and is not a pass" "[ $c -eq 1 ] && grep -q 'AC-1 | DISPUTED (PASS)' verdict.md"
live() { mk; printf -- '---\nstatus: accepted\n---\n| AC | Behaviour | Check | Where |\n|---|---|---|---|\n| AC-1 | f returns 1 | `PYTHONPATH=. python3 checks/ac1.py` | local |\n| AC-2 | works on the device | `ssh target run-ac2` | live |\n' > brief.md
  git add -A; git commit -qm brief; git tag -f base >/dev/null; printf 'def f():\n    return 1\n' > m.py; git commit -qam change; }
live; "$verify" brief.md base >/dev/null; c=$?
ok "live check without evidence is UNVERIFIED, not a pass" "[ $c -eq 1 ] && grep -q '| AC-2 | UNVERIFIED |' verdict.md && grep -q '| AC-1 | PASS |' verdict.md"
live; mkdir evidence; printf 'commit: %s\ndevice output\nexit: 0\n' "$(git rev-parse HEAD)" > evidence/AC-2.log; git add -A; git commit -qm evidence; "$verify" brief.md base >/dev/null; c=$?
ok "evidence for this commit passes and says so" "[ $c -eq 0 ] && grep -q 'AC-2 | PASS .*recorded evidence' verdict.md"
printf 'def f():\n    return 1  # changed after the device run\n' > m.py; git commit -qam later; "$verify" brief.md base >/dev/null; c=$?
ok "evidence older than a code change is UNVERIFIED" "[ $c -eq 1 ] && grep -q '| AC-2 | UNVERIFIED |' verdict.md"
live; VERIFY_LIVE=1 "$verify" brief.md base >/dev/null; c=$?
ok "VERIFY_LIVE=1 runs the live check here (and it fails: no target)" "[ $c -eq 1 ] && grep -q '| AC-2 | FAIL |' verdict.md"
exit $bad
