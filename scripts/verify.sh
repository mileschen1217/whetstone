#!/usr/bin/env bash
# verify.sh <brief.md> [base-ref]
# Runs every criterion's check from the brief in a clean checkout of HEAD and writes verdict.md.
# The builder does not write the verdict; this does. It also reports two things a builder's word
# cannot: a check file that differs from the base, and a check that was already green at the base.
#   brief.md     a table with rows  | AC-n | behaviour | `command` |  ; frontmatter may carry
#                `base: <ref>` (the commit the brief was accepted on) and `checks: <path>` (default checks/)
#   disputed.md  optional, next to the brief: lines  AC-n — what conflicts ; shown as DISPUTED
# Exit: 0 every criterion PASS, 1 otherwise, 2 cannot run (not a git repo, uncommitted changes, no base).
set -uo pipefail
brief="${1:?usage: verify.sh <brief.md> [base-ref]}"
root="$(git -C "$(dirname "$brief")" rev-parse --show-toplevel 2>/dev/null)" || { echo "verify: not a git repository" >&2; exit 2; }
brief_rel="$(cd "$(dirname "$brief")" && pwd -P)/$(basename "$brief")"; brief_rel="${brief_rel#"$(cd "$root" && pwd -P)"/}"
cd "$root"
fm() { awk -v k="$1" 'NR==1&&$0!="---"{exit} NR>1&&$0=="---"{exit} $1==k":"{sub(/^[^:]*:[ \t]*/,"");print;exit}' "$brief_rel"; }
base="${2:-$(fm base)}"; checks="$(fm checks)"; checks="${checks:-checks/}"
[ -n "$base" ] && git rev-parse -q --verify "$base^{commit}" >/dev/null || { echo "verify: no base ref (argument or 'base:' in the brief)" >&2; exit 2; }
if [ -n "$(git status --porcelain --untracked-files=all -- . ":(exclude)verdict.md" ":(exclude)$(dirname "$brief_rel")/verdict.md")" ]; then
  echo "verify: uncommitted changes; commit first, the verdict is taken from HEAD" >&2; exit 2
fi
tmp="$(mktemp -d)"; trap 'git worktree remove --force "$tmp/head" >/dev/null 2>&1; git worktree remove --force "$tmp/base" >/dev/null 2>&1; rm -rf "$tmp"' EXIT
git worktree add -q --detach "$tmp/head" HEAD && git worktree add -q --detach "$tmp/base" "$base" || { echo "verify: cannot create worktrees" >&2; exit 2; }
# the checks always come from the base, in both trees
for t in head base; do rm -rf "$tmp/$t/$checks"; mkdir -p "$tmp/$t/$checks"; git archive "$base" -- "$checks" 2>/dev/null | tar -x -C "$tmp/$t" 2>/dev/null; done
edited="$(git diff --name-only "$base" HEAD -- "$checks")"
disputed="$(dirname "$brief_rel")/disputed.md"
out="$(dirname "$brief_rel")/verdict.md"; fail=0; rows=""
while IFS=$'\t' read -r ac cmd; do
  [ -n "$ac" ] || continue
  res="$(cd "$tmp/head" && bash -c "$cmd" 2>&1)"; code=$?
  (cd "$tmp/base" && bash -c "$cmd" >/dev/null 2>&1); basecode=$?
  verdict=PASS; note=""
  [ $code -eq 0 ] || verdict=FAIL
  [ $basecode -eq 0 ] && note="green before the change; "
  for f in $edited; do case "$cmd" in *"$f"*) note="${note}check file differs from base ($f), base version was run; ";; esac; done
  if [ -f "$disputed" ] && d="$(grep -m1 -E "^[-* ]*$ac\b" "$disputed")"; then verdict="DISPUTED ($verdict)"; note="${note}${d#*—}; "; fi
  case "$verdict" in PASS) ;; *) fail=1;; esac
  tail="$(printf '%s' "$res" | tail -n 1 | tr '|' '/' | cut -c1-160)"
  rows="${rows}| $ac | $verdict | \`$cmd\` | exit $code: $tail | ${note%; } |"$'\n'
done < <(awk -F'|' '$2 ~ /^[ \t]*AC-[0-9]+[ \t]*$/ { ac=$2; gsub(/[ \t]/,"",ac); cmd=$NF=="" ? $(NF-1) : $NF; gsub(/^[ \t`]+|[ \t`]+$/,"",cmd); print ac "\t" cmd }' "$brief_rel")
[ -n "$rows" ] || { echo "verify: no criteria rows found in $brief_rel" >&2; exit 2; }
{ printf -- '---\nbrief: %s\nbase: %s\nhead: %s\nresult: %s\n---\n' "$brief_rel" "$(git rev-parse --short "$base")" "$(git rev-parse --short HEAD)" "$([ $fail -eq 0 ] && echo pass || echo 'not pass')"
  printf '| AC | Verdict | Check | Output | Note |\n|---|---|---|---|---|\n%s' "$rows"
  [ -n "$edited" ] && printf '\nCheck files changed since the base: %s\n' "$(echo $edited)"
} > "$out"
cat "$out"; exit $fail
