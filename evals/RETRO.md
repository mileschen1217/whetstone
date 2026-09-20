# Looking back at an epic

Once an epic has shipped on a real project, this decides two things: did the workflow fail anywhere, and does any entry in `BACKLOG.md` now have the evidence to start. It reads what the workflow already wrote and what the owner reports. It adds no hook and no instrument, and no skill reads it.

## What counts as a failure of the workflow

The workflow makes the owner four promises. An event is one of these being broken, and nothing else is an event.

| Promise | The event | Guardrail |
|---|---|---|
| A claim is no larger than its evidence | after a `PASS`, a `clean` or a merge, evidence turns up that contradicts it: a defect that got out, a check that tested nothing | honesty |
| A decision is seen before it is signed | the owner learns of a decision after the merge | honesty |
| The owner is asked a thing once | a brief or a ship page asks what `epic.md` already answers | convergence |
| Every stage ends, and the owner reads one page | a review that took more than one round; a brief re-opened after it was accepted; a merge decision the owner could not take from the ship page alone | convergence |

Cost is not an event: an inline session records neither spend nor the owner's time. What can be counted is noted and judged by no threshold: runs of `verify.sh`, review rounds, times a brief was re-signed, rows on the ship page.

## Which stage an event belongs to

For a defect that got out, the first question answered "yes" names the stage:

1. Was there no criterion for the behaviour? → `intent` or `brief`.
2. Was there a criterion whose check did not test it? → `brief`.
3. Did the check test it, and was it edited, or green before the change, or `UNVERIFIED`? → `build`, unless the ship page showed that row, in which case 5.
4. Was the defect in the diff, and would one of the review's questions have been answered "yes" for it? → `review`.
5. Was it on the ship page and accepted? → the owner's decision. Not an event.

The other three events name their stage by where they happened.

## The walk

It runs in two places, because the project's files may not leave the project (`COLLECTING.md`) and the backlog lives here.

**In the project**, once an epic has shipped. Ask an agent there to read this file and write `.whetstone/epics/<epic>/retro.md`. It reads, and nothing else:

- `.whetstone/log.md`: one line a unit (result, ids not green, `disputed`, `green-before`, `decisions`) and the `FOLLOW-UP` lines;
- each unit's directory under `.whetstone/epics/<epic>/units/`: `brief.md`, `verdict.md`, `disputed.md`, `decisions.md`, `review.md`, the ship page;
- `.whetstone/memory/`, and the git history of those pages within the epic's commits;
- what the owner reports, which the agent asks for once, in these words: "Since this epic merged: a defect that got out; a decision you learned of only afterwards; something you were asked twice; a merge you could not decide from the ship page. One line each, or none."

`retro.md` has three parts and nothing else:

1. **Counts**, one row a unit, from the files: criteria; `PASS` / `FAIL` / `DISPUTED` / `UNVERIFIED`; green before the change; review findings; rows on the ship page; rows where the owner did not take the marked option; lines of `decisions.md`; memory statements written, rewritten, listed; runs of `verify.sh` when the history shows them. No threshold is applied.
2. **Events**, one row each: which promise, the stage (by the questions above), the evidence as a file and line or the owner's words, and the defect class in one line with no project nouns. A report from the owner that breaks no promise is listed under the table with the reason, and is not an event. When the reason is that the thing was shown before it was signed, the line also gives the page it was on and how many words and rows that page had: a decision that was shown and not taken in is what the length entries in `BACKLOG.md` wait for.
3. **Nothing found**: the promises with no event, named, so that an empty table is a finding and not an omission.

**Here**, with that `retro.md` (or, from a project whose files may not be copied, only its counts and its events table):

1. For each event: find the entry in `BACKLOG.md` whose **What** it is an instance of, or write a new entry in the form at the top of that file. Add one line under **Seen**: the date, a unit label with no project nouns, the defect class.
2. For each entry of `BACKLOG.md`: is its **Starts when** met, and does everything under **Needed to start** exist? Both: it starts. Otherwise it stays.

An entry that starts as a behaviour change goes through `COLLECTING.md`: a record, a private case that reproduces the event, a bare run. Bare green: note it under **Seen** and close the entry. Bare red: a public case, then the sentence, and it enters only with Δ.
