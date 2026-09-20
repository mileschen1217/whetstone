# whetstone

A minimal workflow plugin for Claude Code. The agent does the work; you make three decisions and read three pages.

## What you do

| When | You read | You decide |
|---|---|---|
| Once per epic | intent, assumptions, requirement list, unit list | Accept, or correct |
| Once per unit, before build | `brief.md` — one page: requirements covered, acceptance criteria with their checks, design items, assumptions | Accept, or correct |
| Once per unit, before merge | the PR's exception summary — only the rows that are not green | Approve, or send back |

A **unit** is one brief → build → review → ship pass, and one PR. For a small unit the second decision can fold into the third.

You answer interview questions only where the answer cannot be looked up and the work depends on it. Everything else the agent writes down as an assumption you can overrule.

## What the agent does

| Skill | Output |
|---|---|
| `/whetstone:intent` | `epic.md` — intent, requirements, unit split |
| `/whetstone:brief` | `brief.md` — the unit's contract |
| `/whetstone:build` | the change, tests first, and `verdict.md` from a clean worktree |
| `/whetstone:review` | `review.md` — one fresh reviewer, one round |
| `/whetstone:ship` | PR body and one line in `log.md` |

Your project keeps `REVIEW.md`, your quality policy (start from `templates/REVIEW.md`), and a `.whetstone/` directory the skills write: `epics/<epic>/` with `epic.md` and each unit's brief, verdict, review and ship page; `memory/`, pages of what later epics must know and cannot read from the code, integrated when a unit ships; `log.md`, one line a unit. All of it is markdown with frontmatter, and all of it is committed.

## What it guarantees

- **Claims do not exceed evidence.** Each acceptance criterion carries a runnable check. `verdict.md` comes from running those checks in a clean worktree the builder could not edit.
- **Work converges.** Review is one reviewer and one round. Findings must carry evidence. A clean result is a legal result.
- **The reviewer is not the builder, and only you sign.**

Whether the work is *good* is your call, written in your `REVIEW.md`. whetstone checks that the policy exists and that findings meet its evidence bar.

## Install

Claude Code:

    /plugin marketplace add mileschen1217/whetstone
    /plugin install whetstone@whetstone

Codex:

    codex plugin marketplace add mileschen1217/whetstone
    codex plugin add whetstone@whetstone

The skills are plain markdown and name no harness-specific tools, so other harnesses can be added with a manifest alone.

## What is verified where

Skill wording is evaluated on Claude Code only, with `claude plugin eval` (with and without the plugin; the difference is the evidence), and tuned for one model, Claude Opus. Claude Sonnet is measured and its numbers are published in `evals/BASELINE.md`, but nothing is tuned for it. On Codex, what was checked (codex-cli 0.154.0): the plugin installs, and `review` runs headless through `codex exec` and writes its format. That Codex dispatched a fresh reviewer is its own account and has not been confirmed from a trace. The same wording may behave differently on another model; that is not measured. The one script, `scripts/verify.sh`, is deterministic and verified by fixtures.

## Status

0.1.0, under construction. All five skills exist: `intent`, `brief`, `build` with `scripts/verify.sh`, `review` for diffs only, and `ship`. Its measured results are in `evals/BASELINE.md`, with what was tried and dropped, what is not measured, and one known gap: in some runs the skill is not picked up from a plain request, and the review then behaves as if the plugin were absent. Invoke it by name. See `CHANGELOG.md`.
