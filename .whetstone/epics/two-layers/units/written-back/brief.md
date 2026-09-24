---
unit: written-back
status: accepted
base: written-back-accepted
checks: .whetstone/epics/two-layers/units/written-back/checks/
---

## Goal

ship 頁上每一列不綠的 AC，先寫它替我哪個決定服務、我採用的是什麼，AC 原文退到後面；我不讀 AC 表也能從那一列知道紅掉的是什麼。

## Done looks like

- 之後 ship 頁上每一列不綠的東西是一個區塊，不分線上線下：標題行是 Item 加 follow-up 標籤，子行固定是決定（B-n 的問句與你採用的那一行，或 epic 的 REQ 句）、證據、選項（★ 第一個）、條件（AC 原文整條）；finding、建置決定、memory 列各有自己的第一行，沒有「條件」。表格不再出現。
- 你讀那一列就知道紅掉的是你哪個決定的哪一部分，直接在 Options 裡選；不讀 AC 表。
- 你不再需要問「這條 AC 要做什麼」。
- 費用：真跑一次約 0.7 美元、harness ship 三個 case 各六次約 3.6 美元（grader 改成區塊範圍後跑），加你讀一頁，合計約 5 美元。

## Decisions

Decisions needed: 5

### Needs the owner

- **B-1 Text 欄寫回什麼？** [reader] [AC-1, AC-2]
  - 採用：AC 的 From 欄有幾個 id 就依序寫幾段：`B-n` 給它的問句標題與「採用」那一行；`REQ-n` 給 epic.md 裡那一句；`request` 給 brief 的 Goal 句。然後 `AC:` 接 AC 原文整條（raw text 留給 agent，ADR 0008）。全部是抄的，ship 不發明一句話。
  - 不採用：換成 ship 自己寫的一句人話（會是 agent 的解讀）；把 AC 原文拿掉。
- **B-2 哪些列？** [reader] [AC-1, AC-2]
  - 採用：所有 verdict 列：FAIL、DISPUTED、UNVERIFIED，與帶註記的 PASS。finding 列與 decision 列不動，它們本來就是句子。
  - 不採用：只有 FAIL 列。
- **B-3 用什麼材料真跑、你讀什麼？** [silent] [AC-2, AC-3]
  - 採用：U2 自己在 5/8 時的輸入（commit 217d28e：brief 已有 From 欄與問句標題；verdict 是 AC-5、AC-6 FAIL，AC-7 DISPUTED，AC-1、AC-7 帶註記）。headless 跑一次 ship，頁面存私有目錄；你只讀那一頁的 verdict 列，每一列寫一行「知道紅掉的是什麼：yes 或 no」與一句理由。
  - 不採用：第一個真實專案的頁面（它的 brief 是 0.1.2 格式，沒有 From 欄、沒有問句標題，寫不回去）。
- **B-4 門檻？** [silent] [AC-3]
  - 採用：每一列都 yes 才算進；有一列 no，數字記進 BASELINE，skill 的改動照樣留著（格式依 D-8 以你的裁決加真跑紀錄進場），no 的那列成為下一次的材料。
  - 不採用：過半就算。
- **B-8 ship 頁的列改成區塊？** [reader] [AC-1, AC-2, AC-6]
  - 採用：每一列一個區塊，線上線下同一個形狀：標題 `### <Item> · <follow-up>`；verdict 列四個子行，固定標籤與順序：決定／Decision、證據／Evidence、選項／Options（清單，★ 第一個）、條件／Criterion（AC 原文整條）；finding 列第一行「發現／Finding」、decisions.md 列「建置決定／Builder's decision」、memory 列「陳述／Statement」，這三種沒有「條件」行；標籤依 owner 的語言二選一，ship 不自己取名。事實清單、兩個標題、「Memory candidates」行與最後一行不變。這是三張簽名頁共用的項目形狀（epic 的 D-n、brief 的 B-n 已是標題加子行）。記一頁 ADR：表格對區塊，表格用過、三次真實閱讀說難讀。
  - 不採用：線上區塊、線下表格（同一種東西兩個形狀，parser 與 grader 各寫兩份）；留表格另外產生一份給人看的 view（第二份要同步的 artifact，多一支 script）。

### Record

- **B-5 harness** [logged] [AC-4]
  - 採用：`ship-exceptions` 的 fixture brief 加 From 欄與兩條 B-n（問句標題、採用行），AC-4 的 From 指向其中一條；新 grader 一個：AC-4 那個區塊的「決定」行以那條 `B-n` 開頭並含它的問句，「條件」行仍含 AC 原文；既有 grader 裡以「同一行」找 Item 與 verdict、★、decision 的，改成「同一區塊」（標題行到下一個 `###` 或標題之前）；grader 數不變。
- **B-6 版本與 BACKLOG** [logged] [AC-5]
  - 採用：不升版；BACKLOG「Text 欄是 raw data」那條由這個 unit 做掉（寫回決定加區塊形狀），加一行 Seen 後結案。
- **B-7 沒有 From 欄的 brief** [logged] [AC-1]
  - 採用：0.1.2 格式的 brief（沒有 From 欄）Text 維持 AC 原文整條，跟現在一樣。
- 檔案或儲存格式：pr.md 的 verdict 列 Text 欄（B-1）。unit 之外會呼叫的名字：無。使用者看得到的訊息與 exit code：無。

## Out of scope

epic.md 與 brief 頁（已是標題加子行）；ship 頁以外的頁面；finding、建置決定、memory 列的內容（只換形狀）。

## For the builder

```
skills/ship/SKILL.md   part 3: under each heading, one block per row, no table:
                       `### <Item> · <follow-up tag>`
                       `- 決定：` (Decision) the criterion's From ids in order, each with its text: B-n → the question title and the
                         taken (採用) line copied from the brief; REQ-n → the sentence copied from epic.md; request → the Goal sentence;
                         a brief with no From column: this line left out
                       `- 證據：` (Evidence) the verdict's output and note, in their words
                       `- 選項：` (Options) a list, the ★ one first
                       `- 條件：` (Criterion) the criterion copied whole
                       a finding row: `- 發現：` (Finding) the line copied whole, then Options;  a decisions.md row: `- 建置決定：`
                       (Builder's decision);  a memory row: `- 陳述：` (Statement);  these three have no Criterion line.
                       Labels in the owner's language, from this fixed set.  Fact list, headings, the candidates line and the
                       last line unchanged.  The file stays ≤ 70 lines.
docs/adr/0012-*.md     the ship row is a block, not a table row (context: table used since 0.1.0, three real readings; decision;
                       overturned by: a real reading where the owner cannot decide from the blocks); README table gains the row
evals/ship-exceptions/fixture.sh   the brief gains a From column and a Decisions part with two B-n in the question form; AC-4's From is one of them
evals/ship-exceptions/graders/outcome-text-leads-with-decision.md   regex: in the AC-4 FAIL block, the Decision line starts with that B-n and contains its question, and the Criterion line contains "exactly 600 is kept"
evals/ship-*/graders/*.md   same-line lookaheads (Item with verdict, ★, decision) rewritten to block scope; count unchanged
private material:  <TWO_LAYERS_MATERIAL>/layered/pr-written-back-1.md   one headless ship run on the U2 inputs at 217d28e
                   <TWO_LAYERS_MATERIAL>/owner-written-back.md   the owner's reading: one line per verdict row `AC-n: yes|no — <reason>`, then `understood: k of n`
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `skills/ship/SKILL.md` says each row is a block headed `### <Item> · <tag>` with the fixed labelled lines Decision (the From ids with the B-n question and taken line, the REQ-n sentence or the Goal for `request`), Evidence, Options (★ first) and Criterion (copied whole), in the owner's language from the fixed set; finding, builder's-decision and memory rows have their own first line and no Criterion; a brief without a From column has no Decision line; no table under the two headings; the file is 70 lines or fewer | B-1, B-2, B-7, B-8 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac1.sh` | local |
| AC-2 | One headless `ship` run on the U2 inputs at 217d28e, saved as `layered/pr-written-back-1.md`: no table under the two headings; every block has the fixed lines in order; each verdict block's Decision line starts with the criterion's From ids and contains each named B-n's question title and each REQ-n's sentence, and its Criterion line contains the criterion whole | B-1, B-2, B-3, B-8 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac2.sh` | live |
| AC-3 | `owner-written-back.md`, written by the owner after reading only that page's verdict blocks, has one `AC-n: yes\|no — <reason>` line per verdict row and `understood: k of n` with k = n | B-3, B-4 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac3.sh` | live |
| AC-4 | `ship-exceptions` (fixture brief with From and two B-n, new grader `outcome-text-leads-with-decision`), `ship-all-green`, `ship-memory`: 6 runs each with the skill, every grader passes in every run | REQ-10, B-5 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac4.sh` | live |
| AC-5 | Both manifests still say `0.1.4`; `CHANGELOG.md`'s `## Unreleased` names the ship page's blocks; `BACKLOG.md`'s Text-column entry says it is done in this unit | B-6 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac5.sh` | local |
| AC-6 | `docs/adr/0012-*.md` exists with the three parts (Context naming the table and the three readings, Decision, Overturned by naming an observable event), `docs/adr/README.md` lists it, and `docs/adr/` holds 10 pages or fewer | B-8 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac6.sh` | local |

live inputs: SHIP_RUN=<dir with aggregate-result.json> (AC-4); TWO_LAYERS_MATERIAL from evals-private/repos.env (AC-2, AC-3)
