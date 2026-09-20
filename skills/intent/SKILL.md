---
name: intent
description: Work out with the owner what an epic is for before any unit is briefed or built, and write epic.md - what is there today, the requirements, how much structural change the owner is buying, and the split into units. Use when asked to plan an epic or a feature with the owner, to work out the intent or the requirements, or to split work into units.
---

# intent

## Input

What the owner asked for, in writing, and the repo. This is the one stage with a conversation; `brief` does not interview again.

## Two rounds of questions, then the file

Read the repo first. A question is asked only when its answer changes a line of `epic.md`; give with it the answer you will take if the owner has none.

**Round one**: the questions about behaviour; anything the request assumes about the repo that is not so, with the file that shows it; and this one, always: "What do you expect to ask for next in this part of the system? 'Nothing' is an answer."

**Round two**, always, one question: how much structural change this epic buys. Offer these rungs, smallest first, and mark the one you would choose `★`:

1. the smallest change inside the structure that is there;
2. restructuring the modules this epic touches so that the new behaviour fits;
3. a new component or layer.

For each rung offered: what it touches beyond the requested behaviour; whether it leaves state, or a name other code will call, outside this epic; and which requirement, in the request or named by the owner as coming, it makes cheaper. A rung above the first that serves no such requirement is not offered. When only the first is offered, say so in one line: `no larger structural option: <reason>`.

## epic.md

These parts, in this order, and nothing else:

1. Frontmatter: `epic:`, `status: draft`.
2. `Intent:` what the owner wants and why, in their words. One paragraph.
3. `Today`: one line for each module the epic touches: what it does now. A file location only on a line that contradicts what the owner said or assumed.
4. `Requirements`: `REQ-n`, each an outcome a user or a caller can observe. The rung the owner chose is a requirement here, written as a property that can be checked (what adding the next channel may touch), not as a description of the design.
5. `Decisions`: `D-n`, one line for each thing fixed here that the owner did not state, with the alternative not taken.
6. `Units`: each a change that can be built, reviewed and merged alone; each names the `REQ-n` it covers; every requirement is in one.
7. `Out of scope`: one line.

## Signing

The status stays `draft`. Only when the owner says it is accepted: set `status: accepted` and commit. Never set it on your own reading of their reply.
