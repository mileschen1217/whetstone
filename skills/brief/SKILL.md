---
name: brief
description: Write brief.md, the contract for one unit of work, with a runnable check for every acceptance criterion, for a person to read and sign before anything is built. Use when asked to write a brief, a contract, a spec or acceptance criteria for a unit of work, or to turn a request into something a builder can build from.
---

# brief

## Input

The unit's entry in an accepted `epic.md` with the requirements it names, or, with no epic, what the owner asked for in writing; and the repo. With neither: ask for it, and stop. `brief` does not interview: what is unclear becomes a decision to confirm.

## The file

`.whetstone/epics/<epic>/units/<unit>/brief.md`, with its check files in `checks/` beside it; with no epic, `brief.md` and `checks/` at the repo root. These parts, in this order, and nothing else:

1. Frontmatter: `unit:`, `status: draft`, `base: <unit>-accepted`, `checks:` the checks directory as a path from the repo root.
2. `Goal:` one sentence, in the owner's words.
3. The interface the unit adds or changes: names and signatures, no prose.
4. A table with the columns `AC`, `Behaviour`, `From`, `Check`, `Where`:
   - **AC**: `AC-1`, `AC-2`, and so on. `scripts/verify.sh` reads this table; its header says what it accepts.
   - **Behaviour**: what a caller or a user can observe. Every value in it is a number or a name, not an adjective.
   - **From**: the `REQ-n` of the epic that states this behaviour (`request` when there is no epic), otherwise the id of the decision in part 5 that carries it. A criterion with neither does not enter.
   - **Check**: one shell command, run from the repo root, that exits 0 when the criterion holds.
   - **Where**: `local`, or `live` when the check needs a target or a deployment.
5. `Decisions to confirm`: one numbered line, `B-n` (the epic's own decisions are `D-n`), for each thing the criteria or the checks fix that the request does not state. To find them, walk each criterion and each assertion in its check. Then walk these three and write, for each, what is fixed or the word `free`: a file or stored-data format; a name or signature code outside the unit will call; a message or exit code a user sees.
6. `Out of scope`: one line.

## Before handing it over

- Run every `local` check now. Each must exit non-zero, because nothing is built. One that exits 0 tests nothing the unit adds: change it or drop its criterion.
- Do not build the unit, and do not write a helper the checks import that the builder could not replace.

## Signing

The status stays `draft`. Hand the owner `brief.md` and the list of decisions; changes they ask for are made here. Only when the owner says it is accepted: set `status: accepted`, commit the brief and the checks, and tag that commit with the name in `base:`. Never set it on your own reading of their reply.
