# Changelog

## 0.1.0 — unreleased

- Repo skeleton: Claude Code and Codex plugin and marketplace manifests, guardrails in `CLAUDE.md`, `evals/`.
- `evals/METRICS.md` v1: three measures per stage (outcome, honesty, volume), arms, per-stage cases, interview scenarios.
- Review eval cases 1–6 with fixtures; bare baseline recorded in `evals/BASELINE.md`.
- `evals/COLLECTING.md`: real history stays private; defect classes are re-written as synthetic public cases.
- Eval budget and retirement rules; review cases cut from six to four, each tagged `rule` or `smoke`.
- Eval budget revised: cases tied to failure modes, two graders per case by default, non-discriminating graders deleted. Baseline recorded per model (opus, sonnet, haiku).
- `review` skill: one reviewer who did not write the change, one round, lens = generic + project `REVIEW.md`. Two lens sentences, each with its evidence in `evals/BASELINE.md`.
- Model tiers and run schedule in `evals/README.md`. The existing-data rule and its case were retired for lack of Δ on the reference model.
- `evals/review-self-vs-fresh/`: multi-turn driver comparing self-review, fresh review and the skill's dispatched review. Result recorded in `evals/BASELINE.md`: the dispatched review currently loses a defect that both others catch. Open.
- Eval cases write to `out/review.md` (a file named `review.md` collides with `REVIEW.md` on case-insensitive filesystems).
- `review` also takes a contract (spec or brief): `lens/contract.md`, a closed walk with five decidable questions. Evidence and two rejected variants in `evals/BASELINE.md`.
- `lens/contract.md` retired and `review` is back to diffs only: weak Δ (4 runs, recall unchanged) and an answer key labelled by an agent, not the owner. Restore from commit d90f028. Reasons in `evals/BASELINE.md`.
- `lens/generic.md`: wrong behaviour is defined by a counter-example already in the repo or the brief, not by a path that breaks today. The dispatched review went from 1/6 to 6/6 on the defect it used to drop.
- `evals/review-silent-failure`: a rule case for the finding definition. Bare reports raised-error inputs as findings (5/6), the skill does not (1/6); a silent state-corrupting input is reported by both (5/6). No sentence was added for it.
- `lens/generic.md` is now two closed walks (changed functions × two questions, `REVIEW.md` rules × one) that end when the lists end. It fixes a policy violation masking a behaviour defect in the same change (3/6 to 6/6; bare 1/6). New rule case `evals/review-policy-masks-defect`, sharing the `review-silent-failure` fixture.
