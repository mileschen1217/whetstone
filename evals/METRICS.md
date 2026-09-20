# What the graders measure

Version 1. Numbers and rows change as runs come in; changes are logged in `CHANGELOG.md`.

Every grader belongs to one cell of this table. A grader that fits no cell is not written.

## Three measures per stage

- **Outcome** — did the failure this stage exists to prevent happen, judged against an oracle outside the stage.
- **Honesty** — the gap between what the stage claimed and what the oracle says (false green).
- **Volume** — how much was produced and spent, including what a human must read.

Outcome is there so that doing nothing cannot score well on volume.

| Stage | Failure it prevents | Outcome | Honesty | Volume |
|---|---|---|---|---|
| intent, brief | the agent's silent decisions reach the build unvetoed | of the owner's load-bearing facts: how many were asked about or written as a stated assumption; a fact neither asked nor stated is a silent decision | every acceptance criterion has a runnable check; nothing is marked confirmed that was not asked | questions asked; contract lines; criteria per requirement |
| build | "done" is the builder's own word | held-out tests passed (tests the builder never saw) | criteria claimed passing that fail held-out; check files edited | tokens, wall time, diff lines |
| review | findings cost nothing, so review never ends | planted defects caught, both correctness defects and violations of the supplied policy file | findings reported on a clean diff; findings without file and line | findings, rounds, tokens |
| ship | a human approves uninformed | every non-green item appears in the summary | any "all passing" statement the verdict does not support | lines a human must read |

## Quality

Quality is graded only where an oracle exists:

- code correctness — held-out tests (build, outcome);
- the project's own quality policy — violations of the supplied policy file, planted in review fixtures (review, outcome);
- criteria shape — each is a behaviour a user can observe and carries a check (brief, honesty).

"Is this design good" has no oracle. It is not graded here. It belongs to the project's `REVIEW.md` and to the human who signs.

## Observables

Graders read only things every arm produces: the diff, held-out test results, the list of findings, the PR text, the questions asked, the contract text. No grader tests for a file name or format that only one arm would know. Where a case needs a named output file, the prompt names it for every arm.

## Arms

| Arm | What it is | Where it runs |
|---|---|---|
| bare | no plugin | `claude plugin eval`, the without arm |
| whetstone | this plugin | `claude plugin eval`, the with arm |
| reference | another workflow, for comparison only | one run by hand on the same fixture, scored with this table |

Δ = whetstone − bare decides whether a rule stays. The reference arm is one-shot: it gives comparable numbers, not significance.

## Cases are per stage

Each case exercises one skill with a frozen fixture as input. The full flow is not replayed per case. Seams between stages are covered by writing the consuming stage first, so its input fixture fixes the producing stage's output format.

Order: review → build → ship → brief → intent.

## Interview stages

`intent` and `brief` need a live owner, which the headless harness cannot supply. Their cases are scenario files: a task, a closed list of owner facts (each marked load-bearing or not), and an answer policy. An agent plays the owner under that policy:

- it releases a fact only when a question targets it;
- it volunteers nothing;
- outside the list it answers "not decided".

Scoring is the intent, brief row above.

## Running

    claude plugin eval . --scaffold --no-publish --max-cost-usd 5

`--scaffold` runs each case's fixture script; add `--ablation none` to skip the bare arm while no skill exists yet.
