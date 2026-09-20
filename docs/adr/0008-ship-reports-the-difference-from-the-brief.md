# 0008 — The ship page reports the difference from the signed brief, not a summary of the work

2026-09-20. Accepted.

**Context.** The approver signed the brief and has since lost its detail. Two ways to give it back were on the table. A wrap-up of the brief or of the build on the ship page was proposed by the owner and weighed: nothing decides what belongs in such a summary or when it is complete. The other: only the things that are not green, each carrying the text of its criterion copied whole, so that a row can be decided without opening the brief. The bare arm lists every exception too; it is long, and no shorter when nothing is wrong.

**Decision.** The page is a closed list: the goal line, a short list of facts, one row for each thing that is not green (verdicts other than `PASS`, passes with a note, review findings, builder decisions), and the ids of the plain passes. Each row gives options with one marked, and a follow-up tag from three conditions (silent, state outside the diff, a reader outside the diff). No summary of the brief or of the build.

**Overturned by.** A reader who has not seen the brief cannot take the merge decision from the page alone: observed in real use (an event in `evals/RETRO.md`), or in a cold-reader case.
