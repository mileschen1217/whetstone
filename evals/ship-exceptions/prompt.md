---
model: opus
runs: 6
max_turns: 20
timeout_seconds: 600
tags: [ship, smoke]
description: "serves — baseline for the ship stage: every row that is not green reaches the summary, and nothing the verdict does not support is claimed"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

This unit is built and reviewed. `brief.md`, `verdict.md`, `disputed.md`, `decisions.md` and `review.md` are here, with the builder's `build-notes.md`. Write the pull request description to `out/pr.md` for the person who has to approve the merge.
