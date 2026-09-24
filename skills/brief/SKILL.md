---
name: brief
description: Write brief.md, the contract for one unit of work, with a runnable check for every acceptance criterion, for a person to read and sign before anything is built. Use when asked to write a brief, a contract, a spec or acceptance criteria for a unit of work, or to turn a request into something a builder can build from.
---

# brief

## Input

The unit's entry in an accepted `epic.md` with the requirements it names, or, with no epic, what the owner asked for in writing; and the repo. With neither: ask for it, and stop. `brief` does not interview: what is unclear becomes a decision to confirm.

## The file

`.whetstone/epics/<epic>/units/<unit>/brief.md`, with its check files in `checks/` beside it; with no epic, `brief.md` and `checks/` at the repo root. These parts, in this order, and nothing else. The first five are for the owner, in the owner's language, identifiers as they are; the last is for the builder.

1. Frontmatter: `unit:`, `status: draft`, `base: <unit>-accepted`, `checks:` the checks directory as a path from the repo root.
2. `## Goal`: one sentence, in the owner's words.
3. `## Done looks like`: three lines, what the owner will see, what they do, what they no longer do; then one line with the cost.
4. `## Decisions`: read `line.md` from this plugin (the `skills/` directory one level above this file). First the line `Decisions needed: <n>`, then the heading `### Needs the owner` and the heading `### Record`. Under them, one decision per item, `- **B-n <the question the owner answers>** [<tag>] [AC-n, …]` or `[<tag>] [no check]` (the epic's own decisions are `D-n`; the criteria that go red when the decision is ignored, or `no check`), with two sub-lines, `taken:` and `not taken:` (`採用:` / `不採用:` in Chinese), for each thing the criteria or the checks fix that the request does not state; the ones both tests admit go under the first heading, `none` when there are none. To find them, walk each criterion and each assertion in its check. Then, under `### Record`, walk these three and write, for each, what is fixed or the word `free`: a file or stored-data format; a name or signature code outside the unit will call; a message or exit code a user sees.
5. `## Out of scope`: one line.
6. `## For the builder`: the interface the unit adds or changes (names and signatures, no prose); then the table with the columns `AC`, `Behaviour`, `From`, `Check`, `Where`:
   - **AC**: `AC-1`, `AC-2`, and so on. `scripts/verify.sh` reads this table; its header says what it accepts.
   - **Behaviour**: what a caller or a user can observe. Every value in it is a number or a name, not an adjective.
   - **From**: the `REQ-n` of the epic that states this behaviour (`request` when there is no epic), otherwise the id of the decision in part 4 that carries it. A criterion with neither does not enter.
   - **Check**: one shell command, run from the repo root, that exits 0 when the criterion holds.
   - **Where**: `local`, or `live` when no command run here can decide it: it needs a target, a paid run, or a person's written decision, and the evidence file that records it.

   Then one line, `live inputs:`, naming what the `live` checks read (an environment name, a path); left out when no criterion is `live`.

## Before handing it over

- Run every `local` check now. Each must exit non-zero, because nothing is built. One that exits 0 tests nothing the unit adds: change it or drop its criterion.
- Do not build the unit, and do not write a helper the checks import that the builder could not replace.
- Review the draft brief before it is handed over: invoke the `review` skill with the brief as its subject (it dispatches a reader who did not write it, walks `lens/brief.md`, and writes `brief-review.md` beside the brief). Answer each finding under the reviewer's lines, one `answered: AC-n — <what changed in the brief or its check, or why not>` per finding; the reviewer's lines are not edited. When no agent can be dispatched, `brief-review.md` says `independent: false` and the brief is still handed over; do not review it yourself.
- Hand the owner `brief.md` with `brief-review.md`.

## Signing

The status stays `draft`. Hand the owner `brief.md` and the list of decisions; changes they ask for are made here. Only when the owner says it is accepted: set `status: accepted`, commit the brief and the checks, and tag that commit with the name in `base:`. Never set it on your own reading of their reply.
