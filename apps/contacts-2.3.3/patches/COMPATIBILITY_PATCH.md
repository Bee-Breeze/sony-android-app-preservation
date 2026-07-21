# 相容性補丁規格

此公開文件描述從原始 Contacts 2.3.3 到最終 `compat-v20` 的行為差異，但不
重新散布原始 APK、完整反編譯程式或 OEM 資產。原始輸入必須先符合：

```text
package: com.android.contacts
versionName: 2.3.3
versionCode: 10
SHA-256: b79e48c1f39d706e33e398d35a776d65afad9377f2732422caa5a832f4069a82
```

## Manifest 與安裝模型

- 移除現代一般 App 無法取得的舊 shared UID/process 契約。
- 保留原 package 與 launcher 入口。
- 宣告現代長螢幕可使用完整 App 區域，不加入固定裝置像素尺寸。
- 不新增 Root、Magisk、overlay、網路或帳號依賴。

## 響應式撥號盤

- 移除過時的固定寬度與相容模式幾何。
- 每列切成三個等寬、可點擊的目標。
- 保留原始數字、標籤、順序與動作。
- 版面使用可用寬度計算，不綁定 Xperia 1 III 的 1096 px。

## Provider null 相容性

舊程式預期 `is_restricted` 一定存在；新 Contacts Provider 可能不提供。補丁
在值為 null 時採用 false，值存在時仍保留原有整數判斷，避免詳細頁 crash。

## 公開 Telecom API

已移除的內部 `ITelephony.isIdle()` 路徑改由公開
`TelecomManager.isInCall()` 判斷。所有使用者可觸發的
`android.intent.action.CALL_PRIVILEGED` 改為
`android.intent.action.DIAL`，因此只交給系統撥號器，不會直接撥出。

## Framework 相容層

- App-local contact header shim 只透過公開 Contacts API 提供舊 layout 需要
  的 ABI。
- App-local window factory 使用目標 Android 仍存在的 `PhoneWindow`，讓
  歷史 QuickContact window 可以建立。

## QuickContact 路由

頭像 click listener 明確啟動本 package 的 `QuickContactActivity`，攜帶歷史
`mode=2`，並從被點擊頭像的螢幕位置與尺寸建立 `sourceBounds`。這可保留有
錨點的 overlay，也避免多個通訊錄 App 同時註冊時出現錯誤 Resolver。

## 修復輪次

| 最終相關版本 | 主要假設 | 結果 |
| --- | --- | --- |
| v13 | 響應式撥號盤與觸控對位 | 通過 |
| v14-v16 | contact header、provider null、telecom API | 通過 |
| v17-v18 | 安全撥號交接 | 通過 |
| v19 | QuickContact window factory | framework crash 排除 |
| v20 | 明確 host 與真實 anchor bounds | 最終通過 |

完整私有 diff、每一版 APK 與失敗 logs 只放在 NAS 研究封存。公開文件足以說明
修復邊界，但不宣稱可在沒有合法原始檔及個人簽章的情況下直接產生 APK。
