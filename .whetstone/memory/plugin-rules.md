---
about: How page formats, the owner's line and rules enter this plugin, and what backs them
scope: skills/, evals/, CLAUDE.md
---

## Constraints

- Page format and the owner's line enter this plugin on the owner's ruling, with live evidence from a real project recorded (`Where: live`, an evidence file), not on a harness Δ; when the live target is not met, the sentences the owner ruled stay and the target moves to the backlog entry whose epic can decide it; a rule with a sentence that decides in or out still needs its case. check: none. from: two-layers read-before-signing B-3
- The tag on a decision line and on a ship row is the author's own word; no check, script or reader backs it, so a wrong tag moves an item below the line without a signal. check: none. from: two-layers line B-4

## Facts from the owner

- The first real project's unit 1 pages, their layered versions and the owner's decision on them live outside the public repo, under the `repos.env` name `TWO_LAYERS_MATERIAL`; without them AC-6 and AC-7 of unit `line` are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env`. from: two-layers line B-9
- The six planted brief materials (`read/m1..m6`), the real-page runs (`layered/pr-read-*.md`) and every harness, brief and intent run of unit `read-before-signing` (`runs-read/`, copies of the scratch directories the evidence logs name) live outside the public repo under the `TWO_LAYERS_MATERIAL` root; `READ_RUN` points at `read/`, and `SHIP_RUN`, `BRIEF_RUN`, `INTENT_RUN` at the copies under `runs-read/`; without them AC-1 and AC-6 of that unit are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env`. from: two-layers read-before-signing B-11
