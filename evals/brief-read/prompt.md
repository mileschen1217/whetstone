---
model: opus
runs: 3
max_turns: 25
timeout_seconds: 600
tags: [brief, rule]
description: "serves — the rule that a brief is reviewed before it is signed: a reader who did not write it walks each check for under- and over-testing and each decision for a criterion that goes red; the two planted holes must be named, and nothing else"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

`brief.md` is a draft brief for this repo, not yet signed; its checks are under `checks/` and the owner's request is `request.md`. Review the brief before it is signed and write the findings to `out/brief-review.md`: one per line, `- brief.md:<line> — AC-n under|over — <what>` or `- brief.md:<line> — B-n no red AC — <what>`; the single word `clean` if there is nothing to report.
