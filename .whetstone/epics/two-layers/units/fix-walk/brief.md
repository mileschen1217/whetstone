---
unit: fix-walk
status: accepted
base: fix-walk-accepted
checks: .whetstone/epics/two-layers/units/fix-walk/checks/
---

## Goal

修 finding 的時候，把 finding 沒點名、但依賴改到的東西的檔案一起修掉，讓 burn-down 讀者要抓的東西變少。

## Done looks like

- 之後每個 unit 的 builder 每修一條 finding 就 grep 改到的名字或值、重讀每個命中處，再重讀陳述那個行為的每個檔案，改掉不再成立的；走完就停。
- 你在 ship 頁上看到的 burn-down 列變少；量過的案子 `evals/build-fix-walk` 在 build skill 裡跑六次，五次以上七格全綠。
- 你不再需要在 review 之後自己追「修正有沒有連帶改到別處」。
- 費用：skill 臂六次約 2 美元；回歸 build 兩個 trial 約 2、build-burndown 三次約 0.7；合計約 5 美元。

## Decisions

Decisions needed: 2

### Needs the owner

- **B-1 一進一出，出哪一條？** [silent] [AC-6]
  - 採用：這一句進、不出：記為第二個沒有對應退出的規則（第一個是 intent 第一輪的依賴走訪，2026-09-21），BASELINE 這一段寫明 `one in, no out`，CLAUDE.md 的「Rule count: one in, one out」由系統頁面 epic 一併裁。
  - 不採用：退掉 build 或讀者指令裡的一句（目前沒有一句是沒有 Δ 或沒有結構作用的）。
- **B-2 走訪的句子逐字用量過的那一段？** [reader] [AC-1]
  - 採用：逐字放進 build 的 After review.md，在「commit the fixes」之後：「After each fix: grep the repo for the name, value or format the fix changed and re-read every hit; then re-read every file that states that behaviour (README, CHANGELOG, docs, tests) and change what no longer holds. Stop when that list is walked.」；After review.md 仍 ≤ 10 行。
  - 不採用：改短或改通用（改字就要重量）。

### Record

- **B-3 build 單獨接「修 finding」的請求** [logged] [AC-2]
  - 採用：Input 多一句：只被要求修一份 review 的 finding 時，After review.md 從第一步起適用（先例：單獨 burn-down）；量測的 skill 臂靠它進 skill。
- **B-4 case 的身分** [logged] [AC-3, AC-4]
  - 採用：`evals/build-fix-walk` 留在公開 evals，driver 型（如 build-reservations）；tag `rule`（裸跑七格全綠 2/6、句子 Δ +4）；三臂 bare／walk／skill，skill 臂的請求與 bare 逐字相同、加載 plugin；run.sh 檔頭寫明誰在用它。
- **B-5 回歸與紀錄** [logged] [AC-5, AC-6]
  - 採用：build-reservations skill arm 2 trials（held-out ≥ 12/13、無 false green、check 未改）、build-burndown 3/3；CHANGELOG `## Unreleased` 一行；不升版；BASELINE `# A walk after each fix` 段加 `skill arm: k of 6`。
- 檔案或儲存格式：free。unit 之外會呼叫的名字：`evals/build-fix-walk/run.sh` 的三個 arm 名 `bare`、`walk`、`skill`。使用者看得到的訊息：free。

## Out of scope

修正自然帶進缺陷的頻率；reviewer 端點名依賴的句子；系統頁面；`required:` 的詞彙；burn-down 讀者指令不動。

## For the builder

```
skills/build/SKILL.md        Input: one sentence — asked only to fix the findings of a review: review.md and the tree; the part After review.md
                             applies from its first step.  After review.md: after "commit the fixes", the walk sentence verbatim (B-2); the part
                             stays 10 lines or fewer
evals/build-fix-walk/        arms/skill.md identical to arms/bare.md; run.sh: with PLUGIN_DIR set the session loads that plugin (as
                             build-reservations/run.sh does), otherwise --safe-mode; the header names the user: a rule case for the walk sentence
CHANGELOG.md ## Unreleased;  manifests unchanged (0.1.4);  evals/BASELINE.md section `# A walk after each fix`: a line `skill arm: k of 6` and
                             the words `one in, no out` (B-1)
live inputs: FIXWALK_RUN=<dir with skill-t1..skill-t6, each grade.json> (AC-4); BUILD_RUN=<dir with skill-t1, skill-t2>, CASE_RUN=<dir with aggregate-result.json> (AC-5)
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `skills/build/SKILL.md`'s After review.md part holds the walk sentence verbatim (`grep the repo for the name, value or format the fix changed and re-read every hit`, `re-read every file that states that behaviour`, `Stop when that list is walked`) and is 10 lines or fewer | REQ-9, B-2 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac1.sh` | local |
| AC-2 | `skills/build/SKILL.md`'s Input says a request to fix the findings of a review alone goes to After review.md from its first step | B-3 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac2.sh` | local |
| AC-3 | `evals/build-fix-walk/arms/skill.md` is byte-identical to `arms/bare.md`; `run.sh` loads the plugin when `PLUGIN_DIR` is set and its header names the case `rule` | B-4 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac3.sh` | local |
| AC-4 | The skill arm of `build-fix-walk`, 6 trials with the plugin: 7 of 7 cells in 5 or more, `review_untouched` true in all 6 | request, B-4 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac4.sh` | live |
| AC-5 | `build-reservations` skill arm 2 trials, each `heldout_passed` ≥ 12 of 13, no `false_green`, `checks_edited` empty; `build-burndown` 3 of 3 runs every grader | REQ-10, B-5 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac5.sh` | live |
| AC-6 | Both manifests say `0.1.4`; `CHANGELOG.md`'s `## Unreleased` names the walk after each fix; `evals/BASELINE.md`'s section `# A walk after each fix` has a `skill arm: k of 6` line and the words `one in, no out` | B-1, B-5 | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac6.sh` | local |
