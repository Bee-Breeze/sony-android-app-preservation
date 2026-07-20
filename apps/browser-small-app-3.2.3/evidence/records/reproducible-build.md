# 可重建修復驗證

公開的 `scripts/build-and-sign.sh` 已在 2026-07-20 使用以下條件實際執行：

- Sony 原始輸入 SHA-256：
  `dbac9c685f3d5072413d037ffa7de12f7617015dd20ace236802ddd2ea707551`
- apktool 3.0.2，使用 AAPT2 的兩階段 decode/build 流程
- Android platform 35、build-tools 35.0.0、D8 8.6.2-dev
- JDK 17
- 與實機最終版相同的本機測試簽章；公開腳本不包含 keystore 或密碼

第一階段只把原始 APK decode/build 成正規化中間檔，不套用任何 repair；
第二階段重新解碼中間檔，套用公開 manifest patch、編譯
`FullBrowserActivity.java` 為 `classes2.dex`，再重建、zipalign 與簽章。

## 驗證結果

- `verify-input.sh`：原始 SHA-256 通過。
- `unzip -t`：通過，沒有壓縮資料錯誤。
- `zipalign -c -p 4`：通過。
- `apksigner verify`：v1、v2、v3 通過。
- Package / version：`com.sonymobile.smallbrowser` / `3.2.3` / `30203`。
- SDK：minimum API 16、target API 23。
- `classes2.dex` SHA-256：
  `aff99e59509439b3ef7170534d960b90225c56096380df899832356f626ab95e`，
  與實機最終 `v3c` 完全相同。

排除重新簽章產生的 `META-INF/*` 後，以 ZIP entry 名稱及解壓後內容 SHA-256
比較公開重建與實機最終版：

| 項目 | 實機最終版 | 公開重建 | 結果 |
| --- | ---: | ---: | --- |
| ZIP entries | 275 | 275 | 相同 |
| 新增 | 0 | 0 | 相同 |
| 移除 | 0 | 0 | 相同 |
| 內容變更 | 0 | 0 | 相同 |

整份 APK 的 SHA-256 仍會因 ZIP 時間與使用者簽章不同而改變。上面的逐 entry
比對證明公開流程重建的是實機測試過的邏輯 payload，而不是要求任何人取得
或重現專案擁有者的私人簽章。

直接從原始 APK 單次 decode/build 的早期公開腳本會產生不同的資源 entry
命名，因此已被拒絕，沒有列為可重建方法。
