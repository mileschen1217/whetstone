---
unit: boundary
status: accepted
base: boundary-accepted
checks: .whetstone/epics/two-layers/units/boundary/checks/
---

Goal: 線的第二題用系統對人的邊界，不是 unit 之間或內部元素之間的邊界；內部架構要不要嚴守是 `REVIEW.md` 一句規則的事，不是 owner 每次要讀的列。

## Interface

```
skills/line.md   ## Boundary rewritten; ≤ 30 lines; every phrase U1's ac1.sh greps for stays. Fixed sentences:
  "read from the system page under .whetstone/memory/ when the project has one; otherwise from the Outside: line of the accepted epic.md"
  "code in this repo, another unit and a later epic are inside the boundary"
  "a format or a name that only code inside the boundary reads fixes no cell"
  "what must hold across units inside the boundary is a rule in the project's REVIEW.md or a constraint on a memory page, walked by the reviewer; it is not a row for the owner"
  "with neither page, the other end of an exchange is a person or a thing outside the repo, and the page says which it took"
  gone: "the unit's diff" and "the modules under Today" as the boundary
skills/intent/SKILL.md   part 3 Today ends with one line `Outside:` — what the new behaviour reaches across the system's boundary
                 (a person, another system, a user interface, a protocol, a file that something outside the repo reads);
                 round one puts that line to the owner; the owner rules on it with the epic
## Two tests    test 1 unchanged (ship's three tags, "outside this diff"); test 2 unchanged apart from the sentence above
CHANGELOG.md ## 0.1.4;  .claude-plugin/plugin.json, .codex-plugin/plugin.json  version 0.1.4
evals/BASELINE.md  a section `# The three signed pages in two layers` with the numbers of units line and boundary

live inputs (B-8):  SHIP_RUN, BRIEF_RUN, INTENT_RUN as in unit line;  evals-private/repos.env TWO_LAYERS_MATERIAL=<dir>
                    <dir>/layered/pr-boundary-1.md, pr-boundary-2.md  (two headless runs of ship on the real unit 1 inputs)
                    <dir>/owner-boundary.md   page: pr · decision: merge|do not merge · reason: … · every-row-needs-me: yes|no
```

## Criteria

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `skills/line.md` is 30 lines or fewer, its Boundary section holds the five fixed sentences, no longer names the unit's diff or the modules under Today as the boundary, and every phrase U1's `ac1.sh` greps for is still there; `skills/intent/SKILL.md` says Today ends with an `Outside:` line and round one puts it to the owner | REQ-3, B-1 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac1.sh` | local |
| AC-2 | `skills/line.md` says what must hold across units inside the boundary is a `REVIEW.md` rule or a memory-page constraint walked by the reviewer, not a row for the owner | B-1 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac2.sh` | local |
| AC-3 | `ship` run twice on the first real project's unit 1 inputs: in both pages no row under `Needs the owner` is a `decision` ending in `a stored format`, the 6 fixed findings are under `Record`, and `Decisions needed:` is 4 or fewer | REQ-7, B-2 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac3.sh` | live |
| AC-4 | `ship-exceptions`, `ship-all-green`, `ship-memory` with the skill, 6 runs each: every grader passes in every run; every kept `pr.md` keeps the two-layer shape; on `ship-exceptions` the JSON-format decision is under `Record` in 6 of 6 | REQ-10 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac4.sh` | live |
| AC-5 | `brief-reservations` 3 trials and `intent-low-stock` `skill-epic` 2 trials still pass unit `line`'s form checks (red first, 10 of 10 planted, `[tag] [AC-…]` on every `B-n`; count line, two headings, tagged `D-n`), and both epics have an `Outside:` line under Today that names at least one thing | REQ-10, B-1 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac5.sh` | live |
| AC-6 | `owner-boundary.md` holds `decision:` (`merge` or `do not merge`), a `reason:` of 10 or more characters in the owner's words, and `every-row-needs-me: yes` or `no`, written after reading only the `Needs the owner` part of `pr-boundary-1.md` | REQ-7 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac6.sh` | live |
| AC-7 | Both manifests say `0.1.4`; `CHANGELOG.md` has a `## 0.1.4` entry naming `line.md` and the boundary | B-5 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac7.sh` | local |
| AC-8 | `evals/BASELINE.md` has a section `# The three signed pages in two layers` that names unit `line` and unit `boundary`, the ship harness counts (18/18), the real-page counts (10, 13, and this unit's two) and the cost | B-7 | `bash .whetstone/epics/two-layers/units/boundary/checks/ac8.sh` | local |

## Decisions to confirm

Decisions needed: 4

### Needs the owner

- B-1 邊界不由 agent 假設，由 owner 裁：有系統頁面就讀它；沒有時，`intent` 在 Today 最後一行寫 `Outside:`（新行為跨出系統邊界碰到的東西：人、別的系統、使用者介面、通訊協定、repo 之外會讀的檔案），第一輪問 owner、隨 epic 一起簽，brief 與 ship 讀那一行；兩者都沒有（沒有 epic 的小工作）才退到「另一端是人或 repo 之外的東西」，而且頁面要寫出它用了哪個。這個 repo 的程式碼、別的 unit、之後的 epic 都在邊界內；只有邊界內程式碼會讀的格式或名字不算一格；跨 unit 要守的東西是 `REVIEW.md` 規則或 memory 頁的 constraint，由 reviewer 走，不是給 owner 的列。未採用：agent 自己列舉另一端（owner／使用者／repo 之外）不問 owner。〔silent〕〔AC-1, AC-2, AC-5〕
- B-2 AC-3 的門檻：unit 1 的頁面線上沒有任何儲存格式的 decision，線上列數 ≤ 4（預期留下的是使用者會設的環境變數名、使用者看到的訊息、CLI 旗標名），兩次都要成立。未採用：≤ 2（會把使用者看得到的名字也擠下去）。〔silent〕〔AC-3〕
- B-3 REQ-7 再量一次：你只讀新頁面的 `Needs the owner` 段，寫 `owner-boundary.md`：decision、自己的話的 reason、以及「每一列都需要我嗎」yes／no。未採用：不再讀，只看 AC-3 的數字。〔silent〕〔AC-6〕
- B-4 第一題不動：ship 三個標籤仍用「outside this diff」的字，所以 Unit 2 會讀的儲存格式仍可能被標 `required: state`，但依第二題落到線下。未採用：把標籤的「diff」也改成系統邊界（會動到 review lens 的兩個述語）。〔silent〕〔AC-3〕

### Record

- B-5 版本 0.1.4，CHANGELOG 一條。〔logged〕〔AC-7〕
- B-6 回歸：ship 三個 case 各 6 run（`--allow-tools Write`）、brief 3 trial、intent 2 trial；bare 不跑；門檻同 unit line（每個 grader 6/6，planted 30/30）。〔logged〕〔AC-4, AC-5〕
- B-7 `BASELINE.md` 補一節：unit line 的數字當時沒有記進去（RUNBOOK 要求每次回答問題的 run 都要有一行），這個 unit 一起補。〔logged〕〔AC-8〕
- B-8 live 輸入同 unit line 的環境變數；真跑兩次的頁面存成 `layered/pr-boundary-1.md`、`pr-boundary-2.md`；你的檔案是 `owner-boundary.md`；材料不在時 AC-3、AC-6 停在 UNVERIFIED。〔logged〕〔AC-3, AC-6〕
- 檔案或儲存格式：`line.md` 的三節名稱不變；頁面格式不變。
- unit 之外會呼叫的名字：無新增；`skills/line.md` 與兩個標題沿用。
- 使用者看得到的訊息與 exit code：無（沒有 runtime）。

## Out of scope

改 ship 標籤的定義（第一題）；系統頁面本身；ship 頁 Text 欄的排版（BACKLOG）；U2、U3。
