# evals

What the graders measure, the arms, and the case order: see `METRICS.md`.
The bare baseline per case: `BASELINE.md`. How cases are mined from real history: `COLLECTING.md`.

One directory per case: `evals/<skill>-<n>/prompt.md` plus `graders/*.md`, and a
`case.yaml` with a fixture script where the case needs a workspace. Interview
stages use scenario files instead. whetstone ships no harness of its own.

    claude plugin eval . --scaffold --no-publish --max-cost-usd 5

A rule enters a skill only with a case that reproduces the failure it prevents
(see `CLAUDE.md`).

## Budget and retirement

Eval material has its own budget, separate from the shipped plugin's. These are trigger values; exceeding one means a cut.

| Per skill | Limit |
|---|---|
| Cases | ≤ 5, of which smoke ≤ 2 |
| Fixture script lines | ≤ 600 |
| One two-arm run of the skill's cases | ≤ 10 USD |

Every case names who uses it, in `description`, and carries the matching tag:

- `rule` — it reproduces the failure one named rule prevents. It enters only if it is red on the bare arm. When the rule goes, the case goes; when the case shows no Δ, the rule goes and the case with it.
- `smoke` — it is green bare and guards a channel (the policy file is read, `clean` is a legal answer).

A case with neither is deleted. A `rule` case that is green on both arms after a model change is deleted or becomes the skill's smoke case, replacing one. All cases share one synthetic project; a case is a change on top of it, not a project of its own.
