---
name: build
description: Build one unit of work from an accepted brief.md and produce its verdict. Use when asked to build, implement or carry out a brief, or to finish a unit whose brief has been accepted. The verdict comes from running each criterion's check in a clean checkout, not from the builder.
---

# build

## Input

One `brief.md` whose frontmatter says `status: accepted`. With no accepted brief: stop and say so. Do not write one here.

## Limits

- Do not edit the brief, or any path under the brief's `checks:` (default `checks/`).
- A criterion you cannot follow as written, because the brief contradicts itself, one of its checks, or the repo: build the rest, and add one line to `disputed.md` next to the brief: `AC-n — what conflicts with what, and which reading the code follows`. Nothing else goes in that file.
- Commit the work. The verdict is taken from the commit, not from the working tree.

## Verdict

Run `scripts/verify.sh <brief.md>` from this plugin (the `scripts/` directory two levels above this file). It checks out the commit on its own, runs every criterion's check there with the check files as they were when the brief was accepted, and writes `verdict.md` next to the brief.

- Do not write or edit `verdict.md`.
- It exits 2 when it cannot run (uncommitted changes, no base ref): fix that and run it again.
- A criterion whose check is marked `live` and cannot be run on this machine comes out `UNVERIFIED`. It stays that way until the check has been run on the target and recorded as the script's header describes. Do not run something else in its place.
- A `FAIL`, a `DISPUTED`, an `UNVERIFIED`, a "green before the change" or a "check file differs from base" in it is reported to the user as it stands. Fixing the code and running it again is allowed; rewording the result is not.

The report to the user is the verdict table, then the lines of `disputed.md`.
