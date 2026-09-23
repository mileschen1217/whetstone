---
unit: line
status: accepted
base: line-accepted
checks: .whetstone/epics/two-layers/units/line/checks/
---

Goal: 三張要簽的頁面各分成「需要 owner」與「紀錄」兩層，線只寫一次，不刪任何東西，頁面不變長，我只讀線上的部分就能決定並說出理由。

## Interface

```
skills/line.md                new; intent, brief and ship read it. ≤ 30 lines. Sections, in order:
  ## Boundary                 the system page under .whetstone/memory/ when one exists; else the unit's diff
                              (brief, ship) or the modules under Today (epic); the other end is the owner, a user,
                              code outside the diff, a later epic, a thing outside the repo
  ## Above the line           test 1: the tag is required: silent | required: state | required: reader, defined by the
                              three sentences moved verbatim from ship ("carry on without an error and leave a wrong
                              value or a lost record" · "leaves state outside this diff" · "changes what a reader
                              outside this diff sees"); otherwise logged
                              test 2: the item fixes one cell of an exchange across the boundary: which end does it ·
                              what it carries (a number or a threshold; a name or a message a user sees) · what is
                              inside and outside · what happens when it is not there or fails
                              both hold: above. a module split, an internal file format, an algorithm: below
  ## The two parts            heading `Needs the owner`, then heading `Record`; fact line `Decisions needed: <n>`,
                              n = items under the first heading; n = 0: the first part is the one word `none`

epic.md   part 5: `Decisions needed: <n>`, the two headings; each D-n ends with `[silent|state|reader|logged]`
brief.md  part 5: the same; each B-n ends with `[<tag>] [AC-n, …]` or `[<tag>] [no check]`
pr.md     part 2 `Decisions needed:` = rows under `Needs the owner`; part 3 that table; part 4 the table under
          `Record` (every row ship lists today: verdicts not PASS, PASS with a note, findings, decisions.md, memory);
          part 5 the plain-pass line. Columns unchanged.

.claude-plugin/plugin.json, .codex-plugin/plugin.json   version 0.1.3;  CHANGELOG.md  ## 0.1.3

live inputs (B-9):  SHIP_RUN=<dir>   aggregate-result.json + pr/<case>-<run>.md (the kept out/pr.md of each run)
                    BRIEF_RUN=<dir>  skill-t<i>/grade.json + skill-t<i>/work/brief.md, i = 1..3
                    INTENT_RUN=<dir> skill-epic-t<i>/work/.whetstone/epics/*/epic.md, i = 1..2
                    evals-private/repos.env  TWO_LAYERS_MATERIAL=<dir>  original/{brief,pr}.md · layered/{brief,pr}.md · owner.md
```

## Criteria

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `skills/line.md` exists, is 30 lines or fewer, holds the three tag sentences, the four cells, the three builder kinds and the boundary sentence; `intent`, `brief` and `ship` each name `line.md`; no `SKILL.md` holds a tag sentence | REQ-2, REQ-3 | `bash .whetstone/epics/two-layers/units/line/checks/ac1.sh` | local |
| AC-2 | `intent`, `brief` and `ship` each name `Needs the owner`, `Record`, `Decisions needed:` and `none`; `ship` still names every non-green kind (a verdict other than PASS, a PASS with a note, each finding, each line of `decisions.md`, memory) | REQ-1, REQ-5 | `bash .whetstone/epics/two-layers/units/line/checks/ac2.sh` | local |
| AC-3 | `brief` says each `B-n` ends with the `AC-n` that go red when it is ignored, or `no check` | REQ-4 | `bash .whetstone/epics/two-layers/units/line/checks/ac3.sh` | local |
| AC-4 | `ship-exceptions`, `ship-all-green`, `ship-memory` with the skill, 6 runs each: every grader passes in every run; every kept `pr.md` has the two headings once each, `Decisions needed:` equal to the rows under the first, no line outside the five parts; on `ship-exceptions` every non-green item of the fixture (AC-2 to AC-6, each finding, each `decisions.md` line) is a row in one of the two tables | REQ-1, REQ-5, REQ-6, REQ-10 | `bash .whetstone/epics/two-layers/units/line/checks/ac4.sh` | live |
| AC-5 | `brief-reservations` with the skill, 3 trials: no check green before the work, no criterion without a check, 10 of 10 planted defects caught in each; every `B-n` line ends with a tag and `[AC-…]` or `[no check]` | REQ-4, REQ-10 | `bash .whetstone/epics/two-layers/units/line/checks/ac5.sh` | live |
| AC-6 | The first real project's unit 1 `brief.md` and `pr.md` in layered form: each has no more lines and no more prose lines than the signed page, and the two headings once each | REQ-6, REQ-1 | `bash .whetstone/epics/two-layers/units/line/checks/ac6.sh` | live |
| AC-7 | `owner.md` beside them holds, for each of the two pages, `decision:` (`accept`, `reject`, `merge` or `do not merge`), a `reason:` of 10 or more characters in the owner's words, `read-above-only: yes`; and one line `brief-foresaw-live: yes` or `no` | REQ-7 | `bash .whetstone/epics/two-layers/units/line/checks/ac7.sh` | live |
| AC-8 | Both manifests say `0.1.3`; `CHANGELOG.md` has a `## 0.1.3` entry that names `line.md` | D-10 | `bash .whetstone/epics/two-layers/units/line/checks/ac8.sh` | local |
| AC-9 | `intent-low-stock`, `skill-epic` arm, 2 trials: the `epic.md` written has `Decisions needed:`, the two headings once each, and every `D-n` line ends with a tag | REQ-1, REQ-5 | `bash .whetstone/epics/two-layers/units/line/checks/ac9.sh` | live |

## Decisions to confirm

Decisions needed: 5

### Needs the owner

- B-1 頁面上的固定字串是英文：`Needs the owner`、`Record`、`Decisions needed: n`、`none`。其餘文字照 owner 的語言（第一個真實專案的頁面是中文配英文欄名）。未採用：中文標題；grader 與三個 skill 都要配合，且 evals 的 fixture 全是英文。〔reader〕〔AC-2, AC-4〕
- B-2 ship 三個 case 的回歸門檻：每個 grader 6/6；brief 三個 trial 的 planted defects 30/30、綠在前 0；intent 兩個 trial。未採用：5/6（一次不 fire 的 run 會過）。〔silent〕〔AC-4, AC-5, AC-9〕
- B-3 REQ-7 你要做的事：只讀兩頁的 `Needs the owner` 段，寫 `owner.md`：每頁一組 `page:`、`decision:`、`reason:`（自己的話）、`read-above-only: yes`；另加 `brief-foresaw-live: yes|no`（這份 brief 有沒有想到量尺不是本機 check）。未採用：在對話裡口頭裁決，沒有檔案。〔silent〕〔AC-7〕
- B-4 第一題靠的是作者自己寫的標籤，沒有任何 check 驗標籤對不對；標錯一個，該項目無聲地落到線下。這個 unit 不補這個洞，只記下。未採用：每個標籤必須引用一條會紅的 check（今天沒有這種 check）。〔silent〕〔no check〕
- B-5 REQ-7 的 ship 頁由改過的 `ship` 在 unit 1 的真實輸入上 headless 跑出，只跑一次、取第一次；brief 由作者手套。未採用：跑三次取最好的一份。〔silent〕〔AC-6〕

### Record

- B-6 `line.md` 30 行以內；三個 skill 各多讀它一次，都在每次呼叫 300 行的預算內（今天最長的 `ship` 57 行）。〔logged〕〔AC-1〕
- B-7 ship 第 2 部分的 `Decisions needed:` 今天數第 3 部分所有列，改為只數線上的列；擋 merge 的規則不變（`required` 且不是 decision）。〔logged〕〔AC-4〕
- B-8 pr.md 的 Options 與 Follow-up 欄兩張表都保留；`memory` 列依 epic D-5 分層。〔logged〕〔AC-4〕
- B-9 live 輸入的位置由環境變數 `SHIP_RUN`、`BRIEF_RUN`、`INTENT_RUN` 給，私有材料由 `evals-private/repos.env` 的 `TWO_LAYERS_MATERIAL` 給；`verify.sh` 在乾淨 checkout 裡讀不到它們，這五條 AC 靠 `evidence/AC-n.log`。〔logged〕〔AC-4, AC-5, AC-6, AC-7, AC-9〕
- B-10 三個 ship case 裡被新格式弄壞的 regex grader 在同一個 commit 改寫，名字不變；新的形狀測試在 `ac4.sh`，不進 grader。〔logged〕〔AC-4〕
- B-11 brief 與 intent 的 driver 只跑 skill arm；bare arm 不重跑（bare 不讀 line.md，格式測試對它沒有意義）。〔logged〕〔AC-5, AC-9〕
- 檔案或儲存格式：固定，見 Interface（`line.md` 的三節、三頁的分層、`owner.md` 的欄位）。
- unit 之外會呼叫的名字：`skills/line.md`、兩個標題、`Decisions needed:`、每條決定句尾的 `[tag]`。U2、U3 與 long run 會讀。
- 使用者看得到的訊息與 exit code：無（沒有 runtime）。
- 記錄：這份 brief 有想到 REQ-7 不是本機 check：AC-6、AC-7 是 `live`，證據是 `evidence/AC-n.log` 與 `owner.md`。

## Out of scope

簽名前的讀者（U2）、burn-down（U3）、系統頁面、每頁一個走過一遍的範例、Codex 的 dispatch 確認。
