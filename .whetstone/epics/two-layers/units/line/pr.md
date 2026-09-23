**Goal**: 三張要簽的頁面各分成「需要 owner」與「紀錄」兩層，線只寫一次，不刪任何東西，頁面不變長，我只讀線上的部分就能決定並說出理由。

- Recommendation: do not merge yet — AC-6, skills/ship/SKILL.md:25, AC-7
- Result: 8 of 9 PASS · 1 DISPUTED
- Range: 19d08d0..8aeff75
- Decisions needed: 3

## Needs the owner

| Item | Text | Evidence | Options | Follow-up |
|---|---|---|---|---|
| AC-6 DISPUTED (FAIL) | The first real project's unit 1 `brief.md` and `pr.md` in layered form: each has no more lines and no more prose lines than the signed page, and the two headings once each | exit 1: evidence/AC-6.log at 152c721 — from recorded evidence, not run here; the Interface puts two headings and a second table header on every ship page (6 to 8 lines more than one table), and the signed unit 1 pr.md has no line to spare, so the layered pr.md written by `ship` is 38 lines against 36 (with 6 fewer rows: the memory statements already existed in the copy it ran on); the page follows the Interface. The prose half of AC-6 holds (0 prose lines, as before). | ★ 接受兩張表的格式，REQ-6 只留 prose 那一半（分層版 prose 行數不多於原頁），行數那一半撤回 · 改成一張表加一條分隔線，重跑 AC-4 與 AC-6 | required: reader |
| skills/ship/SKILL.md:25 | skills/ship/SKILL.md:25 — two headings and a second table header on every ship page contradict AC-6 (REQ-6: the layered page has no more lines than the signed one): on the first real project's unit 1 `pr.md` the layered page is 38 lines against 36 with 6 fewer rows, AC-6 is `DISPUTED (FAIL)` in `verdict.md` and recorded in `disputed.md`. The Interface and AC-6 of the signed brief cannot both hold on that page; one of them needs the owner's ruling before the unit ships. | | ★ 同 AC-6 那一列的裁決（burndown.md：open，等這個裁決） · 要求再看一次 | required: reader |
| AC-7 PASS | `owner.md` beside them holds, for each of the two pages, `decision:` (`accept`, `reject`, `merge` or `do not merge`), a `reason:` of 10 or more characters in the owner's words, `read-above-only: yes`; and one line `brief-foresaw-live: yes` or `no` | exit 0: evidence/AC-7.log at 8aeff75 — from recorded evidence, not run here | ★ 接受這個 unit，並在 U2 之前開一個 unit `boundary`：`line.md` 第二題的邊界改為系統對人的邊界（系統頁面第 1–3 步；沒有頁面時，另一端只能是 owner、使用者或 repo 之外的東西），內部元素之間的格式改由 `REVIEW.md` 規則守，重量 REQ-7 · 留到系統頁面那個 epic 一起做 | required: silent |

## Record

| Item | Text | Evidence | Options | Follow-up |
|---|---|---|---|---|
| AC-4 PASS | `ship-exceptions`, `ship-all-green`, `ship-memory` with the skill, 6 runs each: every grader passes in every run; every kept `pr.md` has the two headings once each, `Decisions needed:` equal to the rows under the first, no line outside the five parts; on `ship-exceptions` every non-green item of the fixture (AC-2 to AC-6, each finding, each `decisions.md` line) is a row in one of the two tables | exit 0: evidence/AC-4.log at 152c721 — from recorded evidence, not run here | ★ 接受（18/18 run、180/180 grader，3.36 USD）· 要求在 verify 裡重跑一次 | logged |
| AC-5 PASS | `brief-reservations` with the skill, 3 trials: no check green before the work, no criterion without a check, 10 of 10 planted defects caught in each; every `B-n` line ends with a tag and `[AC-…]` or `[no check]` | exit 0: evidence/AC-5.log at 152c721 — from recorded evidence, not run here | ★ 接受（3/3，1.21 USD）· 要求重跑 | logged |
| AC-9 PASS | `intent-low-stock`, `skill-epic` arm, 2 trials: the `epic.md` written has `Decisions needed:`, the two headings once each, and every `D-n` line ends with a tag | exit 0: evidence/AC-9.log at 152c721 — from recorded evidence, not run here | ★ 接受（2/2）· 要求重跑 | logged |
| skills/ship/SKILL.md:23 | skills/ship/SKILL.md:23 — `Decisions needed:` is defined as "the number of rows in part 3", and part 3 now holds both tables (`Needs the owner` and `Record`); the brief's Interface (pr.md part 2 = rows under `Needs the owner`), B-7, `skills/line.md:21` and `checks/shape.py --count` (run by ac4.sh) all define n as the rows under the first heading only. A ship run that follows this sentence writes n = all non-green rows on any page with a `Record` row; ac4's shape test goes red on an eval page, and on a real project's page no check runs, so the wrong count stands in front of the approver. | | ★ 接受 0a54008 的修正（burndown.md：closed）· 要求再看一次 | logged |
| skills/line.md:21 | skills/line.md:21 — "Each decision line (`D-n`, `B-n`) ends with its tag in brackets" contradicts the form fixed for `B-n` by `skills/brief/SKILL.md:25`, the brief's Interface and `checks/ac5.sh:15`, where the line ends with `[AC-n, …]` or `[no check]` after the tag. `brief` reads both files and gets two different line endings; a brief written to line.md's form fails AC-5, and a `B-n` written to brief's form violates the sentence line.md fixes for every signed page. | | ★ 接受 0a54008 的修正（burndown.md：closed）· 要求再看一次 | logged |
| decision | A `B-n` line in a brief is a bullet line `- B-n …`, not a numbered one (the brief skill said "numbered"; the check and every real page use bullets) — a file format | | ★ 接受 · 改回編號行並改 ac5.sh | logged |
| memory | Page format and the owner's line enter this plugin on the owner's ruling plus live evidence from a real project (`Where: live`, an evidence file), not on a harness Δ; a rule with a sentence that decides in or out still needs its case. check: none from: two-layers D-8 | | ★ accept · drop | logged |
| memory | The tag on a decision line and on a ship row is the author's own word; no check, script or reader backs it, so a wrong tag moves an item below the line without a signal. check: none from: two-layers line B-4 | | ★ accept · drop | logged |
| memory | The first real project's unit 1 pages, their layered versions and the owner's decision on them live outside the public repo, under the `repos.env` name `TWO_LAYERS_MATERIAL`; without them AC-6 and AC-7 of unit `line` are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env` from: two-layers line B-9 | | ★ accept · drop | logged |

Memory candidates that did not enter: D-1, D-2, D-3, D-4, D-5, D-13 and the decisions.md line (each is read from `skills/line.md` or a skill); D-10 (code); B-1, B-2, B-3, B-5, B-6, B-7, B-8, B-10 (read from the brief's checks or the skills); B-11 (a later author need not know it); D-6, D-7, D-9, D-11, D-12 (not made true by this unit or not a statement of what holds).

PASS with an empty note: AC-1, AC-2, AC-3, AC-8
