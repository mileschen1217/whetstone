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

Your project keeps three standing files: `ARCHITECTURE.md`, `REVIEW.md` (your quality policy), and `log.md`. All artifacts are markdown with frontmatter.

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

Skill wording is evaluated on Claude Code only, with `claude plugin eval` (with and without the plugin; the difference is the evidence), and tuned for one model, Claude Opus. Claude Sonnet is measured and its numbers are published in `evals/BASELINE.md`, but nothing is tuned for it. On Codex, what is checked is that the plugin installs, a skill can be invoked, and whether a fresh reviewer can be dispatched. The same wording may behave differently on another model; that is not measured. The two scripts are deterministic and verified by fixtures.

## Status

0.1.0, under construction. One skill exists, `review`. Its measured results, including a known failure of its dispatched review, are in `evals/BASELINE.md`. The other four skills are not written. See `CHANGELOG.md`.
