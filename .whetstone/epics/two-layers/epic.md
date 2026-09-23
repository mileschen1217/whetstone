---
epic: two-layers
status: accepted
---

Intent: 最根本的目的是解決人注意力稀缺的問題，讓 agent 受信任地執行越大的工作項目越好。第一個真實 epic 之後，epic.md、brief.md、pr.md 把每一件被固定的事（決定、AC、finding、memory 句子）以同等地位列出，我看不出哪些需要我判斷；brief 不知從何 review 起，ship 時不懂簽 pr.md 的目的，兩個 unit 的 merge 決定都是從對話摘要做的。我要的是每一頁自己分出「需要 owner」與「紀錄」兩層，不刪任何東西，線的判準不另外發明。同一件事的另外三個部件一起做：brief 的每條決定標由哪條 AC 承接；簽名前由沒寫它的讀者查 AC；review 的修正之後由沒寫修正的讀者做 burn-down。後兩者先量再接。

## Today

- `skills/intent`：epic.md 的 Decisions 是一份 `D-n` 清單，每條同等地位，沒有標籤。
- `skills/brief`：AC 表的 `From` 欄只保證往上追溯；`B-n` 是一份清單；交出前唯一的檢查是 local check 全紅；沒有第二個讀者。
- `skills/review`：一位 reviewer、一輪；`skills/review/SKILL.md` 寫「No second round. Add no finding to it and remove none」，review 之後的修正沒有讀者。
- `skills/build`：verdict 之後直接 review、再 ship；沒有修 finding 的步驟。
- `skills/ship`：pr.md 一張表列出所有不綠的列，`required` 在前；三個 follow-up 標籤只定義在 `skills/ship/SKILL.md` 第 3 部分（silent、state、reader），不是 request 說的「能不能復原、effort、爆炸半徑」；decision 與 memory 列不擋 merge。第一個真實 unit 的頁面 23 列。
- `skills/review/lens/generic.md`：唯一一個由 skill 讀入的共用檔案，是 rung 2 的先例。
- `evals/ship-exceptions`、`ship-all-green`、`ship-memory`：以 regex 讀 pr.md 的列（例如 `outcome-decision-does-not-block`），分層後要跟著改。
- `CLAUDE.md` 預算：五個 skill 目前共 209 行（上限 1,200）；每次呼叫含拉入的檔案 ≤ 300 行；規則要有 eval case。
- 系統分析：0.1.2 的六步分析已存在於私有紀錄；owner 在邊界外，跨邊界的交換是接受 epic、接受 brief、批准 merge、訪談答案、把一頁交到 owner 面前。這個 epic 不重做，取用它。
- `evals-private/repos.env`：只有一個 repo 名；第一個真實專案的 unit 1 檔案沒有對應的名字。

## Requirements

- REQ-1：epic.md、brief.md、pr.md 各有兩段：線上是需要 owner 判斷的項目，線下標「紀錄」。今天格式裡的每一個項目都出現在其中一段，沒有一個被拿掉。
- REQ-2：線只寫一次，在一個檔案裡，`intent`、`brief`、`ship` 各自讀它；skill 本文不含兩題的文字。第四個讀它的地方（long run 的停止條件）不動任何 skill 本文。
- REQ-3：線的第一題：項目的 follow-up 標籤是 `required: silent`、`state` 或 `reader` 其中之一（定義照 ship 的原文）。第二題：項目定的是跨邊界交換的一格：哪一端做、內容（一個數字或門檻、一個使用者看得到的名字或訊息）、什麼在內什麼在外、不在或失敗時怎麼辦。兩題都成立才在線上；模組怎麼切、檔案內部格式、演算法在線下。邊界從哪裡讀：專案的 `.whetstone/memory/` 有系統頁面時，用它的邊界與交換表；沒有時，brief 與 pr 的邊界是這個 unit 的 diff，epic 的邊界是 Today 列的模組，另一端是 owner、使用者、diff 之外的程式碼、之後的 epic、repo 之外的東西。
- REQ-4：brief 的每條 `B-n` 標出被無視時會紅的 `AC-n`，或明寫 `no check`。
- REQ-5：每頁的事實清單有一行「需要你決定：n」，n 是線上項目數；n 為 0 時線上段寫一行「沒有一列」。
- REQ-6：分層版的頁面行數不多於今天的版本；每層只有一個標題，沒有說明欄位怎麼讀的段落。
- REQ-7：第一個真實專案 unit 1 的 brief 與 ship 頁改成分層版後，owner 只讀線上段就做出接受／merge 的決定並用自己的話寫下理由（`live`；證據是 owner 寫下的決定與理由）。
- REQ-8：brief 交出前，一位沒寫它的讀者走兩份清單（每條 AC 的 check 漏測或多測；每條 `B-n` 與 `REQ-n` 有沒有會紅的 AC），只寫缺口；作者逐條回應後才交出；派不出讀者時 brief 標明沒有獨立讀過。先量：在既有六份 brief 產出上，讀者找到 grader 確認的缺口 ≥ 4/6，費用記進 BASELINE，才進 skill。
- REQ-9：review.md 之後 builder 先修 finding。每個修正 commit 由一位沒寫它的讀者讀，候選清單是 review.md 的 finding 與修正動到的函式，走完就停：每個 finding 判 closed／open，動到的函式裡的新缺陷回報為新 finding。修正若定了跨邊界交換的一格，builder 寫進 `decisions.md`，它依線落在 ship 頁線上。open 且關掉它不需要線上決定的退回 builder 一次、再讀一次；第二次仍 open、或關掉它需要線上決定的，在 ship 頁線上並擋 merge；closed 的在線下。派不出讀者時 ship 頁寫「修正沒有獨立讀過」，不擋。先量：讀者對「關掉 finding 並帶進一個新缺陷」的修正判對 ≥ 5/6，才進 skill。
- REQ-10：改到的 skill 的既有 eval case 全綠。

## Decisions

需要你決定：5

### 需要 owner

- D-3：第二題以跨邊界交換的四格定義，五種 owner 的事（含「一個步驟由誰做，當選項之一是 owner 或某個人」）是它的例子；未採用：只列舉五種。〔silent：線畫錯，沒有 check 會紅〕
- D-5：memory 列只有從 `decisions.md` 新寫或改寫既有陳述的在線上，來自已簽的 `B-n`／`D-n` 的算紀錄（只問一次）；未採用：memory 列全在線上。〔reader：之後的 epic 讀它〕
- D-8：分層與線依 `From` 欄與 ship v2 的先例，以 owner 裁決加 REQ-7 的 live 證據進場，不等 harness 上的 Δ；REQ-8、REQ-9 只依量測進場。這偏離 `CLAUDE.md`「Rules: each ships with an eval case; no Δ, no entry」對頁面格式的讀法。未採用：全部等 Δ。〔silent〕
- D-13：邊界的來源如 REQ-3：有系統頁面用它，沒有用 diff／Today；未採用：線只在有系統頁面的專案生效。〔silent〕
- D-14：修正的 guardrail 如 REQ-9：讀者的清單有限、修正裡的決定走同一條線、退回一次；未採用：open 直接到 owner 面前。〔silent〕
- D-11：這個 epic 不寫系統頁面；邊界取自既有的六步分析。owner 已答：取用。〔state：範圍〕

### 紀錄

- D-1：共用檔案是 `skills/line.md`，各 skill 以相對路徑讀它（`build` 讀 `scripts/` 的寫法）；未採用：每個 skill 各抄一份。〔logged：whetstone 內部的名字〕
- D-2：三個標籤的定義從 `ship` 搬到 `skills/line.md`，`ship` 改為讀它；未採用：留在 ship，檔案指向它。〔logged〕
- D-4：epic.md 的 `D-n` 與 brief 的 `B-n` 每條句尾帶標籤（幾個字），第一題才能判定；未採用：不帶標籤，只用第二題。〔logged：頁面格式，REQ-6 擋長度〕
- D-6：讀者的缺口寫在 brief 旁的 `read.md`，burn-down 寫在 review.md 旁的 `burndown.md`，各有 `independent:` 一行；未採用：附在 brief.md／review.md 裡。〔logged〕
- D-7：REQ-7 的 ship 頁由改過的 `ship` skill 在 unit 1 的真實輸入上 headless 跑出；brief 由作者把線套在已簽的 brief 上（重跑 `brief` 會寫出另一份 brief）；兩頁放 `evals-private/`，用 `repos.env` 的名字指向材料，不進公開 repo；材料不在時 REQ-7 停在 `UNVERIFIED`，unit 不 ship。未採用：兩頁都手改。〔logged：REQ-7 會紅〕
- D-9：`review` 加一句 burn-down 不是第二輪；ADR 0002 不動。〔logged〕
- D-10：兩個 manifest 版本改 0.1.3。〔logged〕
- D-12：解決注意力的三條路（以 epic 為單位簽名的 long run、intent 時預先授權區間、線上項目可數）記在 `BACKLOG.md`，只有第三條在這個 epic 裡（REQ-5）。〔logged〕

## Units

- U1 `line`：`skills/line.md`、三個 skill 的分層、標籤、`no check` 標記、可數的 n、ship grader、版本、REQ-7 的 live 證據。REQ-1、2、3、4、5、6、7、10。
- U2 `read-before-signing`：先量，達門檻後寫進 `brief` 與 `line.md` 的派工形狀。REQ-8。在 U1 之後。
- U3 `burn-down`：先量，達門檻後寫進 `build`、`review` 與 `line.md`。REQ-9。在 U1 之後，與 U2 無關。

## Out of scope

每頁一個走過一遍的範例；long run 與預先授權區間（BACKLOG）；系統頁面；Codex 上 dispatch 的確認。
