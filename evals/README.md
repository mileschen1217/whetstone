# evals

What the graders measure, the arms, and the case order: see `METRICS.md`.
The bare baseline per case: `BASELINE.md`. How cases are mined from real history: `COLLECTING.md`.

One directory per case: `evals/<skill>-<n>/prompt.md` plus `graders/*.md`, and a
`case.yaml` with a fixture script where the case needs a workspace. Interview
stages use scenario files instead. whetstone ships no harness of its own.

    claude plugin eval . --scaffold --no-publish --max-cost-usd 5

A rule enters a skill only with a case that reproduces the failure it prevents
(see `CLAUDE.md`).

## Models

| Tier | Model | What it decides |
|---|---|---|
| reference | `opus` (pinned in each case) | everything: a rule enters on Δ here, a case retires when green bare here |
| observed | `sonnet` | nothing. Its numbers are recorded in `BASELINE.md` and stated in the project README. No rule is added or reworded for it |

A rule that helps only the observed model does not enter. A rule with Δ on the reference model stays even if the observed model gets worse; the drop is recorded.

Other vendors' models cannot run in this harness. For them the plugin is checked for install and invocation only (see `CLAUDE.md`).

## When to run what

| Moment | Run | Arms | Models |
|---|---|---|---|
| writing a rule | that rule's case, until bare is red and the rule turns it green | both | reference |
| any edit to a skill file | that skill's cases — this is the regression run | with only (`--ablation none`) | reference |
| before a release tag | every case | both | reference, observed |
| a new reference model, or a new Claude model ships | every case, and every retired case restored once | both | reference, observed |

The two-arm runs double as the ablation: a rule whose case has gone green on the bare arm has lost its Δ and leaves with its case.

## Budget and retirement

Eval material has its own budget, separate from the shipped plugin's. These are trigger values; exceeding one means a cut.

| Per skill | Limit |
|---|---|
| Cases | one per observed failure mode, plus smoke ≤ 2 |
| Graders per case | 2 by default: one on the result, one on how it was reached. Each further grader names its cell in `METRICS.md` |
| Fixture script lines | ≤ 600 |
| One two-arm run of the skill's cases | ≤ 10 USD |

A new case enters only for a failure mode no existing case covers; otherwise it merges into, or replaces, the case that does.

Every case names who uses it, in `description`, and carries the matching tag:

- `rule` — it reproduces the failure one named rule prevents. It enters only if it is red on the bare arm. When the rule goes, the case goes; when the case shows no Δ, the rule goes and the case with it.
- `smoke` — it is green bare and guards a channel (the policy file is read, `clean` is a legal answer).

A case with neither is deleted. A retired case is listed in `BASELINE.md` with the model it was retired on and the commit to restore it from; retirement holds for that model only. A grader that passes on both arms, or on every run of every arm, discriminates nothing and is deleted.

Graders are code (regex, tool use, file checks) wherever a deterministic rule can decide. A judge model is used only on short output, with a rubric written as concrete PASS and FAIL conditions and no condition about format.

Interview cases are scored on the contract the agent hands over, not on the dialogue. The simulated owner's turns are spot-checked for facts it volunteered and for drift from its answer policy.

All cases share one synthetic project; a case is a change on top of it, not a project of its own.
