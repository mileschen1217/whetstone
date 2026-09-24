---
unit: read-before-signing
status: accepted
base: read-before-signing-accepted
checks: .whetstone/epics/two-layers/units/read-before-signing/checks/
---

## Goal

brief 簽名前由一位沒寫它的讀者做兩個有界的走訪（每條 AC 的 check 有沒有漏測或多測；每條決定與 REQ 有沒有一條會紅的 AC），只回報缺口；先量，找得到缺口才進 skill。

## Done looks like

- 之後每份 brief 交到你面前時，段落順序是這份的樣子：人讀的在前（Goal、Done looks like、Decisions 的問句與採用／不採用），給 builder 的在後。簽名前沒有 reader：量過了，這一步沒有 Δ，退役；check 對得上 AC 靠作者、每條 B-n 句尾的 `[AC-n]` 標籤與 verify.sh。
- 你讀三樣：Goal、Done looks like、Needs the owner。AC 表沒有人替你讀，這是你不讀它要付的代價；重新進場的條件在 BACKLOG。
- 這個 unit 出貨時，這件事量過三層：reader 找不找得到種進去的洞（6/6）；lens 有沒有比裸跑多找到（兩臂各約 11/12，沒有）；brief 有沒有 reader 這一步，簽出去的 check 殺得掉的缺陷有沒有差（3 對 3，沒有）。數字都在 BASELINE。
- 費用：讀本 1.43、回歸 5.72、brief 試跑三批約 9、intent 約 2、公開 case 四批約 6、真跑 1.51、AC-6 的消融與確認 17.5、reader 步驟的量測 4，合計約 47 美元（原估 14）。

## Decisions

Decisions needed: 7

### Needs the owner

- **B-1 用什麼量 reviewer 找不找得到缺口？** [silent] [AC-1]
  - 採用：既有六份 brief 產出（brief-reservations 的 skill arm，合成專案；埋的缺陷全被抓到，沒有天然的洞）各種兩個洞：一個 check 放寬到某個埋的缺陷過得了（漏測），一個 check 斷言 brief 沒定的東西（多測）；grader 重跑確認兩個洞都在。「找到」= brief-review.md 一行寫出那條 AC 與方向。
  - 不採用：用第一個真實專案 unit 2 簽名前的 brief（沒 commit，找不回來）；不種洞直接讀（量不到）。
- **B-2 門檻多少，沒過怎麼辦？** [silent] [AC-1, AC-2]
  - 採用：照 epic，6 份裡 4 份兩個洞都找到才進 `brief`；多報的缺口只記數不設上限；每次派工的費用記進 BASELINE。沒過：`brief` 不加那一步，lens 與 review 的受審物留著（量測要用），數字進 BASELINE，unit 照樣出貨。你讀 ship 頁後加的第二道門檻：這一步本身要有 Δ（brief 有／沒有這一步，簽出去的 check 殺得掉的缺陷數）；3 對 3 沒有 Δ，reader 步驟、lens 與 review 的 brief 受審物一起退役，決定 ↔ AC 的關聯已由 B-n 的 `[AC-n]` 標籤承接。
  - 不採用：只要求找到一個洞；6/6。
- **B-3 依你讀 pr-boundary-1.md 的結論再收一次線？** [silent] [AC-5]
  - 採用：第四格「不在或失敗時怎麼辦」只在跨邊界時算；讀者是 agent 的訊息不算「使用者看得到的訊息」。這推翻你對 boundary AC-3 的第一個裁定，採用讀完頁面後的第二個。「同一頁真跑線上 ≤ 2 列」的目標搬到系統頁面的 epic（BACKLOG）：沒有系統頁面，第二題只能猜每一列的另一端是誰，收線前真跑 5 與 5 列、收線後 7 與 4 列，兩句的效果量不出來；這裡只驗兩句在 line.md 裡。
  - 不採用：留到下一個 epic。
- **B-4 派不出 reviewer 時（Codex，或 harness 不能 dispatch）？** [silent] [AC-2]
  - 採用：brief-review.md 寫 `independent: false`，brief 照樣交出，作者不自己審。
  - 不採用：擋住不交。
- **B-5 作者對缺口的回應寫在哪？** [reader] [AC-4]
  - 採用：brief-review.md 裡 reviewer 的行之下，一行一個 `answered:`；reviewer 的行不動；改的是 brief 與 check。
  - 不採用：回應寫在對話裡。
- **B-6 沒有指令能判的 AC 怎麼辦？** [silent] [AC-3]
  - 採用：寫進 `brief` skill 的 Where 欄定義（lens 退役後它是唯一的家）：一條沒有任何指令能判真假的 Behaviour 必須標 `live`，並指名由什麼來判（一個 target、一次付費的跑、一個人寫下的裁決）與記錄它的 evidence 檔；能拆出代理的部分另立 local 的 AC。「要人判斷」是其中一例。
  - 不採用：只寫「要人判斷」那一種；不允許語意的 AC（U1 的 REQ-7 就寫不出來）。
- **B-7 brief 的段落改成人讀的在前？** [reader] [AC-4, AC-6]
  - 採用：順序改為 Goal、Done looks like（三句加費用）、Decisions（標題是問句，採用與不採用各一子點，標籤與承接的 AC 在標題行尾）、Out of scope、For the builder（Interface、Criteria、live inputs）。這把 request 裡「範例這次先不做」拿回來一半（一段成功的樣子，不是完整走一遍）。epic.md 與 pr.md 不在這個 unit 改。
  - 不採用：維持 0.1.4 的順序。

### Record

- **B-8 版本** [logged] [AC-8]
  - 採用：不升。一個 epic 只在結束時升一次（結束時 0.2.0）；unit 只在 CHANGELOG 的 `## Unreleased` 下加一條。
  - 不採用：每個 unit 升一個 patch。
- **B-9 公開 case** [logged] [AC-7]
  - 採用：`evals/brief-read/` 的 brief 手寫（COLLECTING：agent 的原始輸出不進 evals/），兩個洞各一種；grader 只用 regex；tag rule；3 runs。退役：第一種洞兩臂 3/3，換成 lens 專有的兩種洞後兩臂 11/12 對 10/12，無 Δ；列在 BASELINE 的 Retired，可還原的 commit 在那裡。
- **B-10 reviewer 走 review 既有的規則** [logged] [AC-3, AC-4]
  - 採用：審的人不是寫的人、一輪、clean 合法、80 行；lens 依受審物選：diff 用 generic，brief 用 brief；REVIEW.md 兩者都走。U3 的 burn-down 走同一條路（受審物是修正）。退役後 `skills/review/SKILL.md` 回到 epic 分支的原文，只剩 diff 一種受審物。
- **B-11 live 輸入** [logged] [AC-1, AC-6]
  - 採用：`READ_RUN` 加既有三個；真跑的頁面存成 `layered/pr-read-1.md`；材料不在時 AC-1、AC-6 停在 UNVERIFIED；review 五個 case 的回歸因 review skill 改過（後來退回原文）而加進 AC-6。
- 檔案或儲存格式：`brief-review.md`、`plant.json` 如 Interface；`lens/brief.md` 新檔。
- unit 之外會呼叫的名字：`brief-review.md`、`lens/brief.md`、`Done looks like`、`reader entered:`。
- 使用者看得到的訊息與 exit code：無。

## Out of scope

burn-down（U3，會用同一條路）；系統頁面；epic.md 與 pr.md 的段落順序；ship 頁 Text 欄的排版；Codex 上 dispatch 的確認；完整走一遍的範例。

## For the builder

```
skills/brief/SKILL.md    the parts, in this order: frontmatter; ## Goal; ## Done looks like (three lines: what the owner will see,
                         what they do, what they no longer do; then one line of cost); ## Decisions (Decisions needed: n;
                         ### Needs the owner / ### Record; each `- **B-n <question>** [tag] [AC-n, …]` with sub-lines
                         `採用:`/`不採用:` in the owner's language, `taken:`/`not taken:` in English); ## Out of scope;
                         ## For the builder (the interface, the criteria table, then one `live inputs:` line when a criterion is live).
                         Where: `live` when no command run here can decide it: a target, a paid run, or a person's written
                         decision, and the evidence file that records it.  No review step before hand-over (retired, B-2).
skills/review/SKILL.md   byte-identical to the epic branch's; no lens/brief.md
skills/line.md           test 2, two changes (B-3): "not there or fails, across the boundary" ·
                         "a message whose reader is an agent is not a message a person sees";  no other change
evals/brief-read/        retired (B-9): absent from the tree, listed in BASELINE's Retired table with the model and the commit to restore from
evals/brief-reservations/grade.py   two mutants added for the step's measurement: expired-release-credits-again, save-drops-times
CHANGELOG.md ## Unreleased;  manifests unchanged (0.1.4)
evals/BASELINE.md        section `# A reader before the brief is signed`: the six reads, false lines, cost, the entry line
                         `reader entered: no`, the real-page counts, the ablation, the two-arm case, the step's own measurement
private material (B-1), evals-private/two-layers/read/m1..m6/:  brief.md, checks/, request.md (a skill-arm output of
  evals/brief-reservations with two holes planted), plant.json {"plants": [{"ac","kind":"under","mutant"},{"ac","kind":"over"}]},
  grade.json (grade.py on the planted brief: `survivors` names the under mutant, `fail_on_reference` names the over AC),
  brief-review.md (one fresh review per material), result.json (cost)
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | Six materials, each with two grader-confirmed plants; one fresh review per material through the review skill; `brief-review.md` names both plants with their kind in 4 or more of 6; finding lines that match no plant are counted per read; cost per read recorded | REQ-8, B-1, B-2 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac1.sh` | live |
| AC-2 | `evals/BASELINE.md`'s section records the six reads' count (`both plants found in N of 6`), the step's own measurement (with and without the step, killed of 12 mutants per trial) and `reader entered: no`; `skills/brief/SKILL.md` names no review step, no `brief-review.md` and no `independent: false` | REQ-8, B-2, B-4 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac2.sh` | local |
| AC-3 | `skills/review/lens/brief.md` is absent and `skills/review/SKILL.md` is byte-identical to the epic branch `two-layers-epic`; `skills/brief/SKILL.md`'s Where column says `live` is a criterion no command run here can decide, names a target, a paid run and a person's written decision, and the evidence file | B-6, B-10 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac3.sh` | local |
| AC-4 | `skills/brief/SKILL.md` fixes the part order of B-7, `Done looks like`, `For the builder`, the question-title decision form, the taken/not-taken sub-lines and the `live inputs:` line, and names no `brief-review.md` and no `answered:` line | B-5, B-7 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac4.sh` | local |
| AC-5 | `skills/line.md` test 2 says the fourth cell holds across the boundary and a message whose reader is an agent is not a message a person sees | B-3 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac5.sh` | local |
| AC-6 | `ship-exceptions`, `ship-all-green`, `ship-memory` 6 runs each, every grader; the five review cases with the skill, 3 runs each, every result grader; `brief-reservations` 3 trials (red first, 10 of 10 planted, the part order and decision form of B-7, and with `reader entered: yes` a `brief-review.md` beside each brief); `intent-low-stock` `skill-epic` 2 trials with the `Outside:` line | REQ-10, B-7 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac6.sh` | live |
| AC-7 | `evals/brief-read/` is absent from the tree; `evals/BASELINE.md`'s Retired table lists `brief-read` with the model it was retired on and the commit to restore it from | B-9 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac7.sh` | local |
| AC-8 | Both manifests still say `0.1.4`; `CHANGELOG.md` has a `## Unreleased` entry naming the brief reviewer; `evals/BASELINE.md` has the section with the six reads' counts, false lines, cost, `reader entered:` and the real-page count of AC-5 | B-8 | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac8.sh` | local |

live inputs: READ_RUN (AC-1); SHIP_RUN, BRIEF_RUN, INTENT_RUN (AC-6); TWO_LAYERS_MATERIAL (layered/pr-read-1.md, the record of the real-page runs)
