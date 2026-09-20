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

1. **Each event of the epic.** Sources: `log.md` (one line a unit: result, ids not green, the counts `disputed`, `green-before`, `decisions`, and the `FOLLOW-UP` lines), each unit's `verdict.md`, `disputed.md`, `decisions.md`, `review.md`, the rows where the owner did not take the marked option, and what the owner reports. Name its stage. Find the entry in `BACKLOG.md` it belongs to, or write a new one. Add a line under that entry's **Seen**.
2. **Each entry of `BACKLOG.md`.** Is its **Starts when** met, and does everything under **Needed to start** exist? Both: it starts. Otherwise it stays.

An entry that starts as a behaviour change goes through `COLLECTING.md`: a record, a private case that reproduces the event, a bare run. Bare green: note it under **Seen** and close the entry. Bare red: a public case, then the sentence, and it enters only with Δ.
