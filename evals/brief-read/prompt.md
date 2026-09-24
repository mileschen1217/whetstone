---
model: opus
runs: 3
max_turns: 25
timeout_seconds: 600
tags: [brief, rule]
description: "serves — the rule that a brief is reviewed before it is signed with lens/brief.md: a decision no criterion turns red, and a Behaviour decided by a proxy for a thing outside the repo; the two planted holes must be named, and nothing else"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

`brief.md` is a draft brief for this repo, not yet signed; its checks are under `checks/` and the owner's request is `request.md`. Review the brief before it is signed and write what you find to `out/brief-review.md`, one finding per line, each naming the line of `brief.md` it is about; the single word `clean` if there is nothing to report.
