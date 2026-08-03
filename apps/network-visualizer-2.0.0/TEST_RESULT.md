# Network Visualizer 2.0.0 測試結果

## 技術結論

- 最終候選：`2.0.0-compat-v5`（`versionCode 18`）
- Sony Xperia 1 III／Android 13：`partial`
- HTC One M8／Android 6.0.1：安裝階段終止，`INSTALL_FAILED_OLDER_SDK`
- 公開準備狀態：`partial_evidence_record_ready`
- 公開散布模式：`evidence_only`
- 私人 APK 標籤：`PARTIAL`

## Sony Xperia 1 III

- 真正 Launcher 冷啟動進入 `NetworkVisualizerActivity`。
- 最終一次量測為 599 ms；另一次兩張穩定全畫面證據完全相同。
- 直屏、橫屏與 gesture-navigation inset 通過。
- 四種 PiP 模式全部測試，實際進入 `mode=pinned`，最後恢復原設定。
- 五個主選單入口全部打開；所有有限、安全控制完成操作與清理。
- 逐控制台帳共 24 項：18 通過、4 個外部／簽章依賴阻擋、2 個依政策跳過、
  0 個未解釋失敗。
- 五次冷啟動、五次旋轉、五次前後景、三次 PiP，無可歸因 Fatal 或 ANR。
- UI tree 中 overflow 為具名、可點擊、可聚焦；實體鍵盤 Tab traversal 未
  到達該按鈕，因此不列為通過。
- 即時 mmWDI 資料與 signature-gated controls 未恢復，主頁維持明確中性值。

## HTC One M8

完全相同的 v5 APK 以普通 Package Manager 安裝。Android 6.0.1／API 23
低於 App 的 minimum API 33，因此回傳 `INSTALL_FAILED_OLDER_SDK`。測試前後
package 都不存在，沒有安裝殘留，也沒有使用 Root 或替代 APK。

## 回溯與完整性

- 安裝後拉回的 v5 APK SHA-256 與候選一致。
- `v5 → Sony 原版 → v5` 實機回溯演練通過。
- Sony 原版與 v5 拉回檔案均符合各自 SHA-256。
- 回到 v5 後，三個 runtime permission 及已授權的首次啟動流程重新驗證。
- 測試後旋轉狀態恢復為使用者原本的自由旋轉設定。

## 隱私與資料處理

公開候選共有兩張 App-only 截圖。自動掃描、OCR、metadata 與逐像素人工檢視
均未發現帳戶、聯絡人、通知、位置、網路名稱、裝置識別碼、私有路徑或秘密
資料。隱私選項依專案擁有者既定授權接受；不填寫個人資料，也不開始任何
資料發布。
