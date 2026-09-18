# evals

What the graders measure, the arms, and the case order: see `METRICS.md`.
The bare baseline per case: `BASELINE.md`. How cases are mined from real history: `COLLECTING.md`.

One directory per case: `evals/<skill>-<n>/prompt.md` plus `graders/*.md`, and a
`case.yaml` with a fixture script where the case needs a workspace. Interview
stages use scenario files instead. whetstone ships no harness of its own.

    claude plugin eval . --scaffold --no-publish --max-cost-usd 5

A rule enters a skill only with a case that reproduces the failure it prevents
(see `CLAUDE.md`).
