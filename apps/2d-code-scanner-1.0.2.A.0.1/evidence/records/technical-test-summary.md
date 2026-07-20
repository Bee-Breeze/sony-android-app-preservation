# 技術測試摘要

- 840 筆總目錄索引：1
- Package／版本：`jp.co.sony.mc.simplecamera`／`1.0.2.A.0.1`
- 最終 APK SHA-256：`7c2c0445d6c98817b0ff0e8b79c4340a171b94ae424b08f7cdd8072cce487e34`
- 最終簽章 SHA-256：`b5e26a13f091dd593e8f8024e7de21cc0426d0d383feae3300035b84def9d618`
- 技術結果：`accepted_sony_only`
- Runtime Root／重新開機：都不需要

## Sony Android 13

- 一般 Package Manager 安裝成功；從手機拉回的 APK hash 與候選完全相同。
- 208 ms 冷啟動進入真正的繁中 QR 掃描主畫面。
- 相機 HAL 顯示本 package 為 active client，畫面持續取得實體鏡頭 frame。
- 實體鏡頭掃描 `https://example.com/sony-preservation-qr-test`，由 App UID
  發出 `ACTION_VIEW`，經 Android resolver 在 Chrome 載入 Example Domain。
- 主畫面沒有按鈕、分頁、選單或 drawer；權限錯誤頁唯一「關閉」按鈕通過。
- 撤銷相機與麥克風後顯示繁中權限說明並安全退出；恢復權限後主頁通過。
- App 宣告鎖定直屏；系統要求橫屏時仍保持 rotation 0，列為有證據的 N/A。
- 130% 字級可讀，沒有裁切或重疊；主頁沒有需要 TalkBack 操作的控制項。
- 最終乾淨 log 沒有可歸責 fatal、ANR、linkage、verification 或 native crash。
- 字級、旋轉及權限已恢復；`system_server` 維持 PID 8542。

一次刻意過快的「force-stop 後立即重開並同時改字級」造成相機資源尚未釋放
而顯示 `Unable to start camera`。保留該失敗證據；等待四秒再冷啟動的
130% 字級 regression 在 198 ms 成功，不把測試工具造成的時序競爭隱藏。

## HTC Android 6

同一份 arm64 v2 APK 已用一般 Package Manager 嘗試安裝。HTC One M8 只有
`armeabi-v7a,armeabi`，因此明確回報
`INSTALL_FAILED_NO_MATCHING_ABIS`。Package 前後均不存在，旋轉設定與
`system_server` PID 2281 維持。沒有捏造 32 位元 Sony native library，
也沒有用較舊版本替代本次「精確最終 artifact」測試。

## 修復範圍

1. Manifest 的 `minSdkVersion` 由 34 降為 33；
2. 靜態確認程式碼沒有引用後，將 `com.sony.device` 的
   `uses-library` 由 required 改為 optional。

289 個非簽章 ZIP entry 的路徑與數量維持，只有
`AndroidManifest.xml` payload 改變。沒有修改程式碼、native library、
權限、相機流程、網路 endpoint、帳號或授權路徑。
