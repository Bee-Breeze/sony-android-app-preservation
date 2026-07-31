# Sony Bluetooth Headset SBH56 1.0.A.0.6 保存與相容性紀錄

> 本研究的版本盤點、實機驗證、相容性分析與文件整理，由專案擁有者
> 指導 OpenAI Codex 完成。這是獨立保存研究，與 Sony、HTC 或 APKMirror
> 無隸屬、贊助或背書關係。

## 狀態

`1.0.A.0.6` 是 APKMirror 目前列出的最新版本。未修改的 Sony 原始 APK
可在 Xperia 1 III Android 13 上以一般使用者 App 安裝，進入繁體中文裝置
搜尋頁與 NFC／手動配對教學，不需要 Root 或重新開機。

本頁標示為 **PARTIAL / hardware-limited**。測試期間沒有實體 SBH56，因此
不宣稱藍牙配對、相機快門鍵、來電姓名播報、韌體更新或其他配對後功能已
通過硬體端驗收。

公開 repository 僅提供研究紀錄與去識別化截圖，不提供 Sony 原始 APK。

## 身分

| 欄位 | 內容 |
| --- | --- |
| 840 筆總目錄索引 | 63 |
| Package | `com.sonymobile.android.hostapp.sbh56` |
| 版本 | `1.0.A.0.6`（`versionCode 1000006`） |
| SDK／ABI | minimum API 19、target API 26、`armeabi-v7a` |
| 最終 APK SHA-256 | `517294598ead70bb93811f3c9ea7fa9c0850108075f824df402125658e55bc9c` |
| Sony 憑證 SHA-256 | `bc01a8cd9e5d87854f6dc4c84aed49edc34ac196c00b89623cea6ccbbdea627b` |
| 執行時 Root | 不需要 |

## 用途

這個 Host App 用於 Sony Bluetooth Headset with Speaker SBH56。它提供互動式
配對教學、來電者姓名語音通知、相機快門鍵設定，以及配對後的耳機管理與
韌體流程。

Sony 已公告此 App 在 2022 年 11 月後不再於 Google Play 提供下載。

## 歷史

APKMirror 目前保存三個版本：

- `1.0.A.0.1`
- `1.0.A.0.4`
- `1.0.A.0.6`

Sony 已公告此 App 在 2022 年 11 月後不再於 Google Play 提供下載。

## 版本選擇

本研究選擇 2019 年 2 月 8 日上傳的最新版本 `1.0.A.0.6`，沒有回退，也沒有
修改 APK。

來源：

- [APKMirror Bluetooth Headset SBH56 releases](https://www.apkmirror.com/apk/sony-mobile-communications/bluetooth-headset-sbh56/)
- [Sony SBH56 App Download Ending](https://www.sony.com/electronics/support/wireless-headphones-bluetooth-headphones/sbh56/articles/00280980)

## 修復內容

本研究沒有修改 APK、程式碼、資源、簽章、權限或網路端點。原版可直接在
Xperia 1 III Android 13 上安裝與啟動，因此沒有建立重簽版本。

## 刻意未復原的功能

本輪沒有模擬或繞過實體 SBH56，也沒有改寫配對、相機快門鍵、來電姓名播報
或韌體更新流程。這些功能保留原廠行為，等待實體耳機後再驗證。

## 測試平台

| 裝置 | 結果 |
| --- | --- |
| Sony Xperia 1 III／Android 13 | 原版 APK 冷啟動、繁中裝置搜尋、NFC／手動配對提示與版面通過 |
| HTC One M8／Android 6.0.1 | 2026-07-20 歷史測試曾以同一 APK 完成安裝、首次授權、繁中搜尋頁及配對提示；本輪依專案擁有者指示不重新驗證 |

HTC 歷史結果只涵蓋未連接耳機時的主頁與教學，不推論配對後功能或其他非
Sony 裝置。

## 驗證結果

Sony 端從 `RootActivity` 冷啟動後在 236 ms 進入真正的
`AutoPairingActivity`。畫面先顯示「正在搜尋裝置」，再進入 NFC／手動配對
說明。Activity 原生固定直向，畫面填滿可用 App 範圍，沒有 App 造成的
黑邊、裁切、重疊、Fatal 或 ANR。

無耳機狀態可見的配對提示與支援入口已驗證。需要實體 SBH56 的五組控制
合約記錄為硬體阻擋，而不是功能通過。

## 截圖

![正在搜尋裝置](evidence/screenshots/sony-android13-device-search.png)

*Sony Xperia 1 III／Android 13／直向：正在搜尋 SBH56。*

![NFC 與手動配對提示](evidence/screenshots/sony-android13-nfc-pairing.png)

*Sony Xperia 1 III／Android 13／直向：原廠 NFC 與手動配對教學。*

## 已知限制

- 沒有實體 SBH56，無法驗證藍牙／NFC 配對與所有配對後設定。
- 相機快門鍵、來電姓名播報及韌體更新尚未通過硬體測試。
- 舊版支援連結目前可能轉向一般 Sony 支援內容，不保證仍有 SBH56 專頁。
- HTC 本輪不重新測試；只保留同一 APK 的歷史實機結果。
- 測試只涵蓋上述兩台裝置，不推論其他 Android 裝置必然相容。

## 檔案與完整性

私人自用檔案為未修改的 Sony 原始 APK，SHA-256 是
`517294598ead70bb93811f3c9ea7fa9c0850108075f824df402125658e55bc9c`；
Sony 簽章憑證 SHA-256 是
`bc01a8cd9e5d87854f6dc4c84aed49edc34ac196c00b89623cea6ccbbdea627b`。

GitHub 僅保存文件、驗證結果與隱私檢視通過的截圖。

## 安裝與回溯

私人自用 APK 可透過一般 Package Manager 安裝：

```bash
adb install Bluetooth-Headset-SBH56-1.0.A.0.6-original.apk
adb shell am start -n \
  com.sonymobile.android.hostapp.sbh56/.activity.RootActivity
```

回溯時可透過一般 Package Manager 卸載，不會替換 Sony 系統核心元件。

## 發布與法律聲明

Sony APK、程式碼、圖示、名稱、商標及其他 OEM 資產仍屬原權利人。
Repository 的授權只涵蓋本專案自行撰寫的文件與工具，不涵蓋 Sony 二進位檔。

## 研究與作者分工

- 專案方向、實機操作監督與發布決策：專案擁有者。
- 盤點、分析、驗證、隱私檢視與文件：OpenAI Codex。
- App 原始程式與 Sony 發布資產：原權利人。
