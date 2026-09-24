**Goal**: ship 頁上每一列不綠的 AC，先寫它替我哪個決定服務、我採用的是什麼，AC 原文退到後面；我不讀 AC 表也能從那一列知道紅掉的是什麼。

- Recommendation: merge
- Result: 7 of 7 PASS
- Range: 19945cb..a4ba53a
- Decisions needed: 0
- Boundary: none: a person or a thing outside the repo

## Needs the owner

none

## Record

### AC-1 PASS · logged
- 決定：B-1 決定行寫回什麼？ · B-2 哪些列？ · B-7 沒有 From 欄的 brief · B-8 ship 頁的列改成區塊？
- 註記：green before the change
- 選項：
  - ★ 接受（base 上就綠，是因為 brief 在建置之後重簽了三次、base 移到建置之後；不是 check 沒測到改動）
  - 以第一次接受的 commit 9062d47 為 base 重跑 verify
- 驗收條件：`skills/ship/SKILL.md` says each row is a block headed `### <Item> · <tag>` with the fixed labelled lines Decision (the From ids with the B-n question title only, the REQ-n sentence or the Goal for `request`; no taken line), Options (one per line, ★ first) and Acceptance criterion (copied whole), a Note line only when the verdict's Note without its evidence-provenance clause is not empty, and no Evidence line, in the owner's language from the fixed set; finding, builder's-decision and memory rows have their own first line and no Acceptance criterion; a brief without a From column has no Decision line; no table under the two headings; the file is 70 lines or fewer

### AC-5 PASS · logged
- 決定：B-6 版本與 BACKLOG
- 註記：green before the change
- 選項：
  - ★ 接受（base 上就綠，是因為 brief 在建置之後重簽了三次、base 移到建置之後；不是 check 沒測到改動）
  - 以第一次接受的 commit 9062d47 為 base 重跑 verify
- 驗收條件：Both manifests still say `0.1.4`; `CHANGELOG.md`'s `## Unreleased` names the ship page's blocks; `BACKLOG.md`'s Text-column entry says it is done in this unit

### AC-6 PASS · logged
- 決定：B-6 版本與 BACKLOG · B-8 ship 頁的列改成區塊？
- 註記：green before the change
- 選項：
  - ★ 接受（base 上就綠，是因為 brief 在建置之後重簽了三次、base 移到建置之後；不是 check 沒測到改動）
  - 以第一次接受的 commit 9062d47 為 base 重跑 verify
- 驗收條件：`docs/adr/0012-*.md` exists with the three parts (Context naming the table, the three readings and the first block reading, Decision, Overturned by naming an observable event), `docs/adr/README.md` lists it, and `docs/adr/` holds 10 pages or fewer

### AC-7 PASS · logged
- 決定：B-10 證據行的內容從哪裡來？
- 註記：green before the change
- 選項：
  - ★ 接受（base 上就綠，是因為 brief 在建置之後重簽了三次、base 移到建置之後；不是 check 沒測到改動）
  - 以第一次接受的 commit 9062d47 為 base 重跑 verify
- 驗收條件：`scripts/verify.sh` writes an evidence row's Output as `exit <code>: <the line before exit:>` and its Note starting `from evidence/AC-n.log at <sha>, not run here`, its header names that convention, and `evals/verify-fixtures/run.sh` has a case that asserts both reach `verdict.md` and passes with every other case

### AC-2 PASS · logged
- 決定：B-1 決定行寫回什麼？ · B-2 哪些列？ · B-3 用什麼材料真跑、你讀什麼？ · B-8 ship 頁的列改成區塊？ · B-10 證據行的內容從哪裡來？
- 選項：
  - ★ 接受（第四次真跑，0.78 USD；四個 verdict 區塊、選項分行、沒有證據行、只有 AC-7 有註記）
  - 要求重跑
- 驗收條件：One headless `ship` run on the U2 unit directory at 6ee3167 with its verdict rewritten by the changed verify.sh, saved as `layered/pr-written-back-3.md`: no table under the two headings; every block has the fixed lines in order; each verdict block's Decision line starts with the criterion's From ids, contains each named B-n's question title and each REQ-n's sentence and no B-n's taken line; no verdict block has an Evidence line; a verdict block has a Note line when and only when its verdict Note, without the provenance clause, is not empty, and that line contains it; every option is on its own line and the ★ one first; the Acceptance criterion line contains the criterion whole

### AC-3 PASS · logged
- 決定：B-3 用什麼材料真跑、你讀什麼？ · B-4 門檻？
- 選項：
  - ★ 接受（你的第三次閱讀：4 of 4；第一次約一半、第二次 3 of 4）
  - 要求再讀一次
- 驗收條件：`owner-written-back.md`, written by the owner after reading only `pr-written-back-3.md`'s verdict blocks, has one `AC-n: yes\|no — <reason>` line per verdict row and `understood: k of n` with k = n

### AC-4 PASS · logged
- 決定：REQ-10 改到的 skill 的既有 eval case 全綠。 · B-5 harness
- 選項：
  - ★ 接受（最終文字 18/18，3.78 USD；同一 unit 內較早的文字上 ship-memory 曾 3/6，原因是 skill 記憶段仍寫「under the table」，已修）
  - 要求重跑
- 驗收條件：`ship-exceptions` (fixture brief with From and two B-n, new grader `outcome-text-leads-with-decision`), `ship-all-green`, `ship-memory`: 6 runs each with the skill, every grader passes in every run

### scripts/verify.sh:58 · logged
- 發現：scripts/verify.sh:58 — the awk at lines 59–60 now keeps a `\|` inside a cell and hands the Check cell back with a bare `|` restored, but this line writes `$cmd` into verdict.md's table unescaped, so a brief whose Check cell holds an escaped pipe (tried: `` `printf "a\nb\n" \| wc -l \| grep -q 2` ``) exits 0 and leaves a verdict row with seven cells (`| AC-1 | PASS | \`printf "a\nb\n" | wc -l | grep -q 2\` | exit 0:  | green before the change |`); every reader of verdict.md by column (ship's Note for the block's 註記 line, the five-cell regex at checks/ac2.sh:14) then reads the wrong cell for that row, and the fixture case at evals/verify-fixtures/run.sh:23 puts the escaped pipe only in the Behaviour cell, so it cannot catch it.
- 選項：
  - ★ 接受 2a62853 的修正（burndown.md：closed）
  - 要求再看一次

### .whetstone/epics/two-layers/units/written-back/checks/ac3.sh:9 · logged
- 發現：.whetstone/epics/two-layers/units/written-back/checks/ac3.sh:9 — B-4 (every row `yes`) is decided only by the owner's own `understood: k of n` line: line 5 counts `yes` and `no` lines alike and nothing reads the answers, so a file with `AC-7: no — …` and `understood: 4 of 4` (tried, two rows: one `yes`, one `no`, `understood: 2 of 2`) exits 0; two lines for the same AC and none for another also pass the count.
- 選項：
  - ★ 接受 2a62853 的修正（burndown.md：closed）
  - 要求再看一次

### docs/adr/0012-a-ship-row-is-a-block.md:7 · logged
- 發現：docs/adr/0012-a-ship-row-is-a-block.md:7 — the Decision says a verdict block carries "then the evidence" between the decision and the options; the brief (Done, AC-1: no Evidence line) and skills/ship/SKILL.md:32–37 give the block no evidence line (a Note line only when the verdict's Note minus provenance is not empty), so the page the ADR records is the first shape, not the one shipped; its Context (line 5) stops at the second shape and never names the third.
- 選項：
  - ★ 接受 2a62853 的修正（burndown.md：closed）
  - 要求再看一次

### CHANGELOG.md:5 · logged
- 發現：CHANGELOG.md:5 — the entry's first sentence states the shipped block as carrying "the `B-n` question and its taken line" and "then the evidence"; skills/ship/SKILL.md:33 copies the question title "and nothing more of it" and SKILL.md:32–37 has no evidence line, and the same entry says so three sentences later, so the Unreleased entry describes two contradictory shapes as current.
- 選項：
  - ★ 接受 2a62853 的修正（burndown.md：closed）
  - 要求再看一次

### CHANGELOG.md:5 · logged
- 發現：CHANGELOG.md:5 — "From the owner's three readings of the page on a real unit:" is followed by four outcomes, and the first (a FAIL row's text told him nothing about which signed decision had gone red) is the reading of the table page on unit `read-before-signing`, which ADR 0012's Context lists apart from the three block readings; the entry miscounts the readings and places a table reading among the block readings; nothing a check catches, but the ADR and the entry now disagree on what the three readings were.（burndown.md 的 new）
- 選項：
  - ★ 接受 19945cb 的修正
  - 要求再看一次

### memory · logged
- 陳述：plugin-rules.md · Facts from the owner（新）：The owner decides a verdict row from its verdict and the options, and reads the decision line to know which signed decision the row is about; he does not read the criterion's text, the check's output or an evidence file, and he reads a number only inside the recommended option. A Record decision with a bare title (`B-9 公開 case`) and a dispute copied as a paragraph told him nothing. check: none. from: two-layers written-back B-8
- 選項：
  - ★ 接受
  - 拿掉

### memory · logged
- 陳述：plugin-rules.md · Facts from the owner（新）：The three block pages of unit `written-back` (`layered/pr-written-back-1.md`, `-2.md`, `-3.md`, plus `-3-rowcopy.md`), the owner's three readings (`owner-written-back-1.md`, `-2.md`, `owner-written-back.md`) and its harness and real runs (`runs-written-back/`) live outside the public repo under the `TWO_LAYERS_MATERIAL` root; the AC-4 evidence is `SHIP_RUN=runs-written-back/harness-run-4`; without them AC-2, AC-3 and AC-4 of that unit are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env`. from: two-layers written-back B-3
- 選項：
  - ★ 接受
  - 拿掉

Memory candidates that did not enter: B-1、B-2、B-5、B-7、B-8、B-10（程式碼說得出來：skills/ship/SKILL.md、scripts/verify.sh、fixture 與 grader）；B-4（plugin-rules.md 第一條已涵蓋：live 目標沒達到時字句留、目標移到 backlog）；B-6（release.md 已涵蓋）；B-3 的材料部分（只對這個 unit 的量測有意義）；沒有 decisions.md、沒有 disputed.md；這個 unit 不在 epic 的 Units 清單裡，沒有它獨自成真的 D-n。

PASS with an empty note: none
