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
