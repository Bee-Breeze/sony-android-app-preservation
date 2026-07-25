# What's New 社群重建說明

## 原版狀態

Sony 簽章的 `5.0.A.0.0` 仍可安裝，但官方服務已於 2019 年停止，啟動後
只提供服務終止資訊，無法進入原有內容主頁。

## 採用方案

本項沒有修改 Sony 反編譯程式來假裝連回官方服務。最終成品是獨立的
clean-source Android App，只沿用 package／版本身分與可辨識的五色視覺語言，
並在畫面內明確標示為社群重建版。

## 功能實作

- 公開來源擷取與多來源失敗隔離。
- 四類資訊篩選與手動更新。
- App 內 WebView 文章閱讀。
- 最近成功內容的 JSON 快取與離線冷啟動。
- 響應式直向／橫向版面。
- Android 5 至 15 可用的 SDK 宣告。

## v2 相容修復

v1 在 Android 7 以上使用 `Html.fromHtml(String, int)` 正常，但 HTC Android
6 沒有該 API，背景擷取會發生 `NoSuchMethodError`。v2 只增加 SDK 分支：

- Android 7 以上使用 `Html.fromHtml(String, Html.FROM_HTML_MODE_LEGACY)`。
- Android 5／6 使用已棄用但仍有效的 `Html.fromHtml(String)`。

此變更不改資料來源、畫面、權限、套件或版本號。v2 已在 Sony Android 13
及 HTC Android 6.0.1 重新驗證。

## 未實作

- Sony 帳號、商店、購買、授權或舊後端模擬。
- 任何繞過 Sony／Google 授權或付費機制的功能。
- 宣稱官方背書、官方服務恢復或完整重現歷史伺服器內容。

## 簽章影響

重建版使用專案本地測試簽章，不能覆蓋 Sony 原版簽章 APK。安裝與回溯前
應先備份 App 資料。
