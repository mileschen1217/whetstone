---
unit: written-back
status: accepted
base: written-back-accepted
checks: .whetstone/epics/two-layers/units/written-back/checks/
---

## Goal

ship 頁上每一列不綠的 AC，先寫它替我哪個決定服務、我採用的是什麼，AC 原文退到後面；我不讀 AC 表也能從那一列知道紅掉的是什麼。

## Done looks like

- 之後 ship 頁上每一列不綠的東西是一個區塊，不分線上線下：標題行是 Item 加 follow-up 標籤，子行固定是決定（B-n 的問句、epic 的 REQ 句；不抄採用行）、選項（一行一個，★ 第一個）、驗收條件（AC 原文整條，給要動手的 agent）；verdict 的 Note 去掉出處後還有話的列（改動前就綠、check 被改、disputed）多一行註記；沒有證據行（你不看它就能判，agent 有 verdict.md）。finding、建置決定、memory 列各有自己的第一行，沒有「驗收條件」。表格不再出現。
- 你讀那一列就知道紅掉的是你哪個決定的哪一部分，直接在 Options 裡選；不讀 AC 表。
- 你不再需要問「這條 AC 要做什麼」。
- 費用：真跑一次約 0.9 美元、harness ship 三個 case 各六次約 3.8 美元（grader 改成區塊範圍後跑），加你讀一頁；第一輪 5.0 美元（你讀了一次：大概懂一半）、第二輪 6.0（3 of 4；選項擠在一行、證據行的出處擋在觀測前面），第三輪再約 5 美元，合計約 16 美元。

## Decisions

Decisions needed: 6

### Needs the owner

- **B-1 決定行寫回什麼？** [reader] [AC-1, AC-2]
  - 採用：AC 的 From 欄有幾個 id 就依序寫幾段：`B-n` 只給它的問句標題（你讀過、答過的那一句）；`REQ-n` 給 epic.md 裡那一句；`request` 給 brief 的 Goal 句。AC 原文整條在最後一行「驗收條件」（raw text 留給 agent，ADR 0008）。全部是抄的，ship 不發明一句話。
  - 不採用：連「採用」那一行也抄（第一次閱讀：三個來源就三百字，「參雜很多資訊」）；換成 ship 自己寫的一句人話（會是 agent 的解讀）；把 AC 原文拿掉。
- **B-2 哪些列？** [reader] [AC-1, AC-2]
  - 採用：所有 verdict 列：FAIL、DISPUTED、UNVERIFIED，與帶註記的 PASS。finding 列與 decision 列不動，它們本來就是句子。
  - 不採用：只有 FAIL 列。
- **B-3 用什麼材料真跑、你讀什麼？** [silent] [AC-2, AC-3]
  - 採用：U2 自己在 5/8 時的 unit 目錄（commit 6ee3167：brief 已有 From 欄與問句標題，與 217d28e 逐位元組相同；verdict 是 AC-5、AC-6 FAIL，AC-1、AC-7 帶註記；review.md、disputed.md、burndown.md 在，ship 才不會因沒有 review 停下）。verdict.md 先由改過的 verify.sh 在那棵樹上重寫（evidence 列的 Output 才有觀測行），再 headless 跑一次 ship，頁面存私有目錄；你只讀那一頁的 verdict 列，每一列寫一行「知道紅掉的是什麼：yes 或 no」與一句理由。
  - 不採用：第一個真實專案的頁面（它的 brief 是 0.1.2 格式，沒有 From 欄、沒有問句標題，寫不回去）。
- **B-4 門檻？** [silent] [AC-3]
  - 採用：每一列都 yes 才算進；有一列 no，數字記進 BASELINE，skill 的改動照樣留著（格式依 D-8 以你的裁決加真跑紀錄進場），no 的那列成為下一次的材料。
  - 不採用：過半就算。
- **B-8 ship 頁的列改成區塊？** [reader] [AC-1, AC-2, AC-6]
  - 採用：每一列一個區塊，線上線下同一個形狀：標題 `### <Item> · <follow-up>`；verdict 列三個固定子行，標籤與順序：決定／Decision、選項／Options（縮排清單，一行一個，★ 第一個；第二次閱讀：同一行分不出第二個選項從哪開始）、驗收條件／Acceptance criterion（AC 原文整條；第一次閱讀時標籤「條件」讀不出它是綠的定義）；決定與選項之間，只在 verdict 的 Note 去掉「from evidence/… not run here」那一句之後還有話時，多一行註記／Note 抄那些話（改動前就綠、check 檔被改、disputed 的原因：這些列在頁上的理由只在 Note 裡）。沒有證據行：第二次閱讀你不看它就能判，agent 讀 verdict.md；ship 不寫摘要（2026-09-20），★ 選項裡的數字是 agent 從 verdict 的 Output 讀來的；finding 列第一行「發現／Finding」、decisions.md 列「建置決定／Builder's decision」、memory 列「陳述／Statement」，這三種沒有「驗收條件」行；標籤依 owner 的語言二選一，ship 不自己取名。事實清單、兩個標題、「Memory candidates」行與最後一行不變。這是三張簽名頁共用的項目形狀（epic 的 D-n、brief 的 B-n 已是標題加子行）。記一頁 ADR：表格對區塊，表格用過、三次真實閱讀說難讀。
  - 不採用：線上區塊、線下表格（同一種東西兩個形狀，parser 與 grader 各寫兩份）；留表格另外產生一份給人看的 view（第二份要同步的 artifact，多一支 script）；固定的證據行（第二版有，第二次閱讀：不需要）。

- **B-10 證據行的內容從哪裡來？** [reader] [AC-7, AC-2]
  - 採用：verify.sh 對 evidence 列的 Output 欄寫 `exit N: <evidence 檔 exit: 前的那一行>`（依既有慣例那是 check 印的最後一行；verify.sh 的說明寫明這個慣例），與 local 列同形、一行、160 字；出處「from evidence/AC-n.log at <sha>, not run here」寫在 Note。頁面沒有證據行，但 ship 寫 ★ 選項時讀的是 verdict 的 Output，live 列沒有這一句就只有 exit code；輸入清單不開。fixture 加一個 case。
  - 不採用：ship 自己去讀 evidence 檔（輸入清單要開一個口）；把 evidence 檔整段抄上（AC-6.log 一段兩百字）；維持只寫 exit code（第一次閱讀：「跟 pass / failed 差不多，沒有幫助」）；另開一行由 agent 整理證據（ship 不寫摘要，2026-09-20 的裁決；agent 的字只在選項）。

### Record

- **B-5 harness** [logged] [AC-4]
  - 採用：`ship-exceptions` 的 fixture brief 加 From 欄與兩條 B-n（問句標題、採用行），AC-4 的 From 指向其中一條；新 grader 一個：AC-4 那個區塊的「決定」行以那條 `B-n` 開頭並含它的問句，「驗收條件」行仍含 AC 原文；既有 grader 裡以「同一行」找 Item 與 verdict、★、decision 的，改成「同一區塊」（標題行到下一個 `###` 或標題之前）；grader 數不變；`ship-all-green` 的 volume grader 由 25 行放寬到 30 行（選項分行後，一列 evidence 的全綠頁剛好 25 行）。
- **B-6 版本與 BACKLOG** [logged] [AC-5, AC-6]
  - 採用：不升版；BACKLOG「Text 欄是 raw data」那條由這個 unit 做掉（寫回決定加區塊形狀），加一行 Seen 後結案；ADR 0012 的 Context 記第一次區塊閱讀的結果。
- **B-7 沒有 From 欄的 brief** [logged] [AC-1]
  - 採用：0.1.2 格式的 brief（沒有 From 欄）Text 維持 AC 原文整條，跟現在一樣。
- 檔案或儲存格式：pr.md 的區塊（B-1、B-8）；verdict.md 的 Output 欄與 evidence 檔 `exit:` 前一行的慣例（B-10）。unit 之外會呼叫的名字：無。使用者看得到的訊息與 exit code：無。

## Out of scope

epic.md 與 brief 頁（已是標題加子行）；ship 頁以外的頁面；finding、建置決定、memory 列的內容（只換形狀）。

## For the builder

```
skills/ship/SKILL.md   part 3: under each heading, one block per row, no table:
                       `### <Item> · <follow-up tag>`
                       `- 決定：` (Decision) the criterion's From ids in order, each with its text: B-n → its question title copied
                         from the brief, and nothing more of it; REQ-n → the sentence copied from epic.md; request → the Goal sentence;
                         a brief with no From column: this line left out
                       `- 註記：` (Note) only when the verdict's Note, without its `from evidence/… not run here` clause, is not empty:
                         that remainder copied (green before the change, check file differs from base, the disputed reason)
                       `- 選項：` (Options) an indented list, one option per line, the ★ one first
                       `- 驗收條件：` (Acceptance criterion) the criterion copied whole
                       a finding row: `- 發現：` (Finding) the line copied whole, then Options;  a decisions.md row: `- 建置決定：`
                       (Builder's decision);  a memory row: `- 陳述：` (Statement);  these three have no Acceptance criterion line.
                       Labels in the owner's language, from this fixed set.  Fact list, headings, the candidates line and the
                       last line unchanged.  The file stays ≤ 70 lines.
scripts/verify.sh      an evidence row's Output: `exit <code>: <the line before exit:>`, cut as a local row's is; its Note starts
                       `from evidence/AC-n.log at <sha>, not run here`; the header says the line before `exit:` is the check's last
                       output line;  evals/verify-fixtures/run.sh gains one case: that line reaches verdict.md's Output, the path its Note
docs/adr/0012-*.md     the ship row is a block, not a table row (context: table used since 0.1.0, three real readings, the first block
                       reading; decision;
                       overturned by: a real reading where the owner cannot decide from the blocks); README table gains the row
evals/ship-exceptions/fixture.sh   the brief gains a From column and a Decisions part with two B-n in the question form; AC-4's From is one of them
evals/ship-exceptions/graders/outcome-text-leads-with-decision.md   regex: in the AC-4 FAIL block, the Decision line starts with that B-n and contains its question, and the Criterion line contains "exactly 600 is kept"
evals/ship-*/graders/*.md   same-line lookaheads (Item with verdict, ★, decision) rewritten to block scope; count unchanged
private material:  <TWO_LAYERS_MATERIAL>/layered/pr-written-back-1.md   the first shape (read once: about half);  pr-written-back-2.md
                   the second (read once: 3 of 4);  pr-written-back-3.md  the third shape: verify.sh rerun on the U2 unit directory at
                   6ee3167, then one headless ship run there
                   <TWO_LAYERS_MATERIAL>/owner-written-back.md   the owner's reading of pr-written-back-3.md: one line per verdict row `AC-n: yes|no — <reason>`,
                   then `understood: k of n`  (owner-written-back-1.md and -2.md hold the earlier readings, verbatim)
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `skills/ship/SKILL.md` says each row is a block headed `### <Item> · <tag>` with the fixed labelled lines Decision (the From ids with the B-n question title only, the REQ-n sentence or the Goal for `request`; no taken line), Options (one per line, ★ first) and Acceptance criterion (copied whole), a Note line only when the verdict's Note without its evidence-provenance clause is not empty, and no Evidence line, in the owner's language from the fixed set; finding, builder's-decision and memory rows have their own first line and no Acceptance criterion; a brief without a From column has no Decision line; no table under the two headings; the file is 70 lines or fewer | B-1, B-2, B-7, B-8 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac1.sh` | local |
| AC-2 | One headless `ship` run on the U2 unit directory at 6ee3167 with its verdict rewritten by the changed verify.sh, saved as `layered/pr-written-back-3.md`: no table under the two headings; every block has the fixed lines in order; each verdict block's Decision line starts with the criterion's From ids, contains each named B-n's question title and each REQ-n's sentence and no B-n's taken line; no verdict block has an Evidence line; a verdict block has a Note line when and only when its verdict Note, without the provenance clause, is not empty, and that line contains it; every option is on its own line and the ★ one first; the Acceptance criterion line contains the criterion whole | B-1, B-2, B-3, B-8, B-10 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac2.sh` | live |
| AC-3 | `owner-written-back.md`, written by the owner after reading only `pr-written-back-3.md`'s verdict blocks, has one `AC-n: yes\|no — <reason>` line per verdict row and `understood: k of n` with k = n | B-3, B-4 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac3.sh` | live |
| AC-4 | `ship-exceptions` (fixture brief with From and two B-n, new grader `outcome-text-leads-with-decision`), `ship-all-green`, `ship-memory`: 6 runs each with the skill, every grader passes in every run | REQ-10, B-5 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac4.sh` | live |
| AC-5 | Both manifests still say `0.1.4`; `CHANGELOG.md`'s `## Unreleased` names the ship page's blocks; `BACKLOG.md`'s Text-column entry says it is done in this unit | B-6 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac5.sh` | local |
| AC-6 | `docs/adr/0012-*.md` exists with the three parts (Context naming the table, the three readings and the first block reading, Decision, Overturned by naming an observable event), `docs/adr/README.md` lists it, and `docs/adr/` holds 10 pages or fewer | B-6, B-8 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac6.sh` | local |
| AC-7 | `scripts/verify.sh` writes an evidence row's Output as `exit <code>: <the line before exit:>` and its Note starting `from evidence/AC-n.log at <sha>, not run here`, its header names that convention, and `evals/verify-fixtures/run.sh` has a case that asserts both reach `verdict.md` and passes with every other case | B-10 | `bash .whetstone/epics/two-layers/units/written-back/checks/ac7.sh` | local |

live inputs: SHIP_RUN=<dir with aggregate-result.json> (AC-4); TWO_LAYERS_MATERIAL from evals-private/repos.env (AC-2, AC-3)
