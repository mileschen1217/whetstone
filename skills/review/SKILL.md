---
name: review
description: Review a finished change before it is merged. Use for every request to review a diff, a branch, a change or a PR, or to check work that was just built, also when the request names its own output file or format; invoke it before reading the diff. One reviewer who did not write the change, one round, findings with file and line, written to review.md.
---

# review

One reviewer, one round. The reviewer did not write the change.

## Subject

The diff the user names. When none is named: the current branch against its base. When the unit has a `brief.md`, it goes with the diff.

## Lens

Read these, in this order, as one text:

1. `lens/generic.md`
2. the project's `REVIEW.md` — when it exists

When the two together exceed 80 lines, stop and tell the user which file is over. Do not trim it yourself.

## Who reviews

- This session wrote none of the diff: this session is the reviewer.
- This session wrote any of the diff: dispatch one fresh agent. Give it the lens text, the diff, and `brief.md`. Give it nothing from this conversation.
- This session wrote some of the diff and the harness cannot dispatch an agent: do not review. Tell the user to run the review in a new session, and set `independent: false`.

The reviewer's answer is final. No second round. Add no finding to it and remove none.

## Output

`review.md` beside the unit's `brief.md` when there is one, otherwise at the repo root; or the file the user names:

```
---
subject: <what was reviewed>
independent: true
---
- path:line — what is wrong and why it matters
```

One finding per line. With nothing to report, the body is the single word `clean`. When the user gives a format for the file, the user's format wins.
