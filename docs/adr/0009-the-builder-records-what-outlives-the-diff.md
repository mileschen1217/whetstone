# 0009 — The builder records the choices that outlive the diff, and no others

2026-09-20. Accepted.

**Context.** Where the brief leaves something open the builder chooses. Recording nothing was the state before: the chosen file format went unreported by the bare arm and by the skill. Recording every choice was the other option: it has no end, and the owner would read a design diary. The owner's test for what deserves attention is what it costs to undo.

**Decision.** `build` walks three kinds of thing the change adds or alters (a stored format, a name or signature callable from outside the diff, a message or exit code a user sees) and writes one line for each that the brief left open, to `decisions.md`. `ship` gives each line a row that does not block the merge. A deviation from the brief is not a decision: it goes to `disputed.md` and does block.

**Overturned by.** A decision the owner learns of after a merge (an event in `evals/RETRO.md`) that is none of the three kinds; or `decisions.md` files in real use that the owner stops reading.
