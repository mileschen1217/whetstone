---
model: opus
max_turns: 25
timeout_seconds: 600
tags: [review, rule]
description: "serves — rule: each new constraint in the diff is checked against data already in the repo"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

I've finished a change in this repo. The diff is in `change.diff`, and the working tree already has it applied. Our review policy is in `REVIEW.md`.

Review the change and write the result to `review.md`: one finding per line, in the form `- path:line — what is wrong and why it matters`. If there is nothing to report, the file contains only the word `clean`.
