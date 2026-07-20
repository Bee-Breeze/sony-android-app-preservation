# 公開資料去識別化驗收

- 候選：`Browser (small app) 3.2.3 v3c`
- 管道：公開 GitHub patchset 與證據紀錄
- 驗收日期：2026-07-20
- APK：排除
- 決定：`passed_after_redaction`

## 範圍

公開資料包含繁中文件、專案撰寫的相容性 Activity、manifest patch、已實際
驗證的重建腳本、五張截圖、SHA-256 清單與最小深度測試台帳。以下內容均
排除：裝置序號、ADB log、
UI hierarchy、私人瀏覽資料、Cookie、歷史、書籤、帳密、keystore、原始／
重簽 APK 與 NAS／本機絕對路徑。

五張最終截圖均已逐張顯示及人工檢查，只包含公開測試頁、App UI、一般狀態
列與裝置導覽列。沒有帳號名稱、通知內容、聯絡人、訊息、行事曆、精確位置、
網路識別碼、裝置序號或憑證。

## 修正紀錄

第一次自動掃描發現兩類僅存在於公開副本的問題：

- 雜湊清單保留六筆本機絕對路徑，之後改為候選內相對路徑。
- 兩張 HTC PNG 在 `IEND` 後附有 20 bytes 的 `Segmentation fault` 文字；
  只移除公開副本的尾端 bytes，解碼後的影像像素不變。

修正後重新凍結階段 7 候選。去識別化 scanner 為 0 finding，Gitleaks
8.30.1 為 0 secret，ExifTool 沒有圖片警告，且沒有 symlink 或隱藏檔。
五張最終圖片也已再次人工覆核。

2026-07-20 建立 Stage 8 本機 repository 候選後，新增的繁中 README、
manifest patch、build/verify scripts、可重建證據與相對連結也納入掃描。
`check_publication_record.py` 通過，所有 11 個 README 相對連結存在，禁止的
APK／keystore／idsig 數量為 0；候選目錄的去識別化 scanner 仍為 0 finding，
Gitleaks 仍為 0 secret。實際 commit 與可達 Git history 尚未建立，因此推送
前仍須對精確 commit 執行包含 `--git-history` 的完整重跑。

本機 pre-commit repository/history 掃描另列出 16 筆 review item，全部是
同一個有意公開的 repository owner GitHub noreply commit identity。其中兩筆
位於既有 App 的隱私紀錄，其他為六個既有 commits 的 author/committer
metadata；沒有命中私人信箱、新增 Browser 檔案或未公開身分。整個 Git
history 的 Gitleaks 掃描為 0 secret。這項值依其公開用途與擁有者脈絡接受，
不建立廣泛 email allowlist；精確新 commit 仍須再次逐筆檢查。

## Motivated-intruder 檢查

- `singling_out`：公開裝置型號與 OS 是測試條件，不含唯一裝置識別碼。
- `linkability`：狀態列時間及一般圖示不能連回私人內容；ADB serial 不公開。
- `inference`：圖片只揭露 README 已說明的 App 相容性與測試平台事實。

## 決定

- Reviewer：Codex 技術隱私門檻，由專案擁有者監督。
- 限制：不是獨立隱私專家或法律審查。
- 殘餘風險：一般人可得知公開的手機型號、OS 與 App 版本；未發現具實質性的
  singling-out、linkability 或 inference 路徑。
- 最終決定：`passed_after_redaction`。

任何檔案、截圖、metadata、commit 或 Git history 變更都必須重新掃描與人工
檢查；本紀錄不能自動延伸到尚未建立的遠端 commit。
