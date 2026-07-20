# 公開資料去識別化驗收

- 候選：Calculator 2.1-update1 portable responsive v4 公開 Git 記錄
- 判定：`passed_after_redaction`
- 檢查範圍：README、patch、scripts、測試摘要、四張 PNG、repository 可達歷史

## 自動與人工檢查

- 公開目錄不含 APK、keystore、憑證私鑰、ADB 序號、帳號、密碼或環境檔。
- 四張截圖逐張檢查像素；只顯示 Calculator、一般系統狀態列與結果。
- PNG metadata 已移除；未保留拍攝者、位置、路徑或裝置唯一識別資料。
- 公開文字中的實體裝置以產品型號與 OS 表示，不包含 ADB serial。
- motivated-intruder review 未發現可用於 singling out、linkability 或 inference
  的私人資料組合。
- 公開 Git 不含 Sony APK、反編譯完整程式碼或 Sony 圖示。
- 完整可達歷史掃描回報 20 筆 email pattern；逐筆皆為 repository 已公開使用
  的 GitHub noreply 提交地址，不是私人聯絡信箱或 credential，人工判定為
  可接受的公開假陽性。
- gitleaks 掃描 8 次 commit，結果為 0 筆 secret leak。

## 修訂紀錄

候選截圖由 NAS 原始驗證證據複製後移除 PNG metadata。所有公開檔案形成確切
Git 候選後，已執行 repository 與完整可達歷史的 secret/de-identification
掃描。截圖 metadata 移除後的最終人工判定為 `passed_after_redaction`；
任何內容變更都必須重新驗收。
