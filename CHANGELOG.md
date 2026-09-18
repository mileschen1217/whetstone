# Changelog

## 0.1.0 — unreleased

- Repo skeleton: Claude Code and Codex plugin and marketplace manifests, guardrails in `CLAUDE.md`, `evals/`.
- `evals/METRICS.md` v1: three measures per stage (outcome, honesty, volume), arms, per-stage cases, interview scenarios.
- Review eval cases 1–6 with fixtures; bare baseline recorded in `evals/BASELINE.md`.
- `evals/COLLECTING.md`: real history stays private; defect classes are re-written as synthetic public cases.
- Eval budget and retirement rules; review cases cut from six to four, each tagged `rule` or `smoke`.
- Eval budget revised: cases tied to failure modes, two graders per case by default, non-discriminating graders deleted. Baseline recorded per model (opus, sonnet, haiku).
