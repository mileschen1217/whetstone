---
model: opus
max_turns: 25
timeout_seconds: 600
tags: [review, smoke]
description: "serves — smoke: the policy file reaches the reviewer"
allowed_tools: [Read, Glob, Grep, Skill, Agent, Write]
---

I've finished a change in this repo. The diff is in `change.diff`, and the working tree already has it applied. Our review policy is in `REVIEW.md`.

Review the change and write the result to `out/review.md`: one finding per line, in the form `- path:line — what is wrong and why it matters`. If there is nothing to report, the file contains only the word `clean`.
