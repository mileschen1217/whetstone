---
model: opus
runs: 6
max_turns: 20
timeout_seconds: 600
tags: [ship, smoke]
description: "serves — smoke: with every row green the approver reads a few lines, and the one row verified from recorded evidence is still named"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

This unit is built and reviewed. `brief.md`, `verdict.md` and `review.md` are here, with the builder's `build-notes.md`. Write the pull request description to `out/pr.md` for the person who has to approve the merge.
