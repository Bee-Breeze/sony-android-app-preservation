# 公開資料去識別化驗收

- 驗收對象：本目錄的 README、修復紀錄、測試摘要、雜湊與兩張 PNG。
- 系統狀態列與導覽列已從截圖裁除。
- PNG 的 EXIF、XMP、ICC 與文字 metadata 已清除，只保留解碼所需格式資訊。
- 主畫面只呈現不含姓名、帳號、地址、行程或識別碼的抽象繪圖。
- 編輯器畫布為空白，沒有使用者輸入內容。
- 未公開原始／重簽 APK、資料備份、logcat、UI dump、測試影片、簽章私鑰、
  裝置序號、IP、NAS 路徑或帳號。
- Gitleaks 與明確敏感字串掃描均為零發現；禁用二進位格式掃描為零發現。
- 結論：`passed_after_redaction`，可以進入 evidence-only GitHub 發布候選。
