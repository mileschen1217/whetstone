# 0005 — The contract lens was retired

2026-09-19. Accepted.

**Context.** `lens/contract.md` was a closed walk over a spec's requirements and criteria with five questions. On one real spec it cut findings from 23–29 to 16–24 and found a textual inconsistency the bare arm missed 4/4. But recall on labelled defects did not move, each row was 4 runs, and the answer key (28 findings, 27 marked fixed) had been labelled and dispositioned by the agent that ran that review, not by the owner. The owner could not label the extra findings after the fact, for the same reason. It was also tuned on another project's contract format, not on the `brief.md` this plugin will produce.

**Decision.** Retired without a confirmation run. `review` takes diffs only. Its structure was right and came back as the diff lens (0002); what was missing was evidence. The private case stays for when `brief` produces a contract.

**Overturned by.** A contract case with an oracle the reviewing agent did not write: owner-labelled findings, or defects that later bit a build.
