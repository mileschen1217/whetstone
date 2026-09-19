# whetstone — rules for changing this plugin

This file governs work on the plugin itself. It is not loaded by users of the plugin. `AGENTS.md` is a symlink to it.

## Two guardrails

1. **Convergence** — no step lets an agent diverge without end. Every instruction has a finite candidate set and a stopping point.
2. **Honesty** — claim ≤ evidence. A claim of done, passing, or clean is backed by output the claimant could not edit.

Kept principles: the held-out verdict is the floor; reviewer ≠ builder; a human signs, an agent never signs for them.

## Budgets

These are targets and trigger values, not yet measured. Exceeding one triggers a cut, not a raise.

| What | Limit |
|---|---|
| Lines loaded per skill invocation, including everything it pulls in | ≤ 300 (≈ 5k tokens) |
| Shipped lines, five skills combined | ≤ 1,200 |
| Assembled review lens (generic + type + project) | ≤ 80 lines |
| Shipped scripts | ≤ 2, each with a caller (eval material: budget in `evals/README.md`) |
| Hooks, instruments | 0 |
| Rules | each ships with an eval case; no Δ, no entry |
| Rule count | one in, one out |

## Three questions before a rule enters

A red case alone does not add a rule. The first occurrence is logged only.

1. Which guardrail does it serve: convergence or honesty? Neither: it does not enter.
2. Should an existing rule have caught this? Yes: fix that rule, add nothing.
3. Is there an eval case that reproduces this red? No: write the case first.

## Three tests for every sentence in a skill

Skills contain boundary sentences only. A boundary sentence removes candidates, is decidable, and ends when its list is walked. A direction sentence generates candidates and has no end.

1. **What candidates does it remove?** No answer: it is a direction sentence; cut it.
2. **Would two readers give the same in/out for the same candidate?** Grade adjectives (better, concise, reasonable) and open verbs (improve, consider, ensure) fail this.
3. **Where is the end?** A boundary sentence ends when the candidate list is exhausted. No end: cut it.

## Where things are written down

Rules: this file and `evals/README.md`. Numbers: `evals/BASELINE.md`. How to take an eval question to an answer: `evals/RUNBOOK.md`. A decision a later session would otherwise reopen: `docs/adr/`, one page, with what would overturn it. None of these copies another.

## Order of work

Eval cases and guardrails first, skills second. Write each skill only far enough to make its three cases pass. Use `claude plugin eval`; build no harness.

## Harnesses

Installable on Claude Code (`.claude-plugin/`) and Codex (`.codex-plugin/`, `.agents/plugins/`). Other harnesses are added the same way.

- `skills/`, `scripts/`, `templates/` are the single source for every harness. A port adds a manifest directory and nothing else.
- Skill bodies name actions (read a file, run a command, dispatch a fresh reviewer), never a harness's tool names.
- Skills depend on no hook and no session-start injection.
- Where a harness cannot dispatch a fresh agent, the skill reports that the review was not independent. It does not self-review.
- Versions in all manifests match.
- Prose Δ is measured on one reference agent only, with `claude plugin eval`. Scripts are verified by fixtures, on no agent.
- A port is done when the plugin installs, one skill is invoked headless (Codex: `codex exec`), and fresh-agent dispatch is confirmed or recorded as absent.

## Public repo

No local absolute paths, no email addresses, no references to private artifacts in any file.
