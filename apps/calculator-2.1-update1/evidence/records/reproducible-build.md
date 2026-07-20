# 公開 Patchset 重建驗證

- 驗證日期：2026-07-20（Asia/Taipei）
- 輸入 SHA-256：`76826e20297f97e31bf0fe381ab69590839d64f0bd943d07641551cf8a033b20`
- Apktool：3.0.2
- JDK：17
- Android SDK Build Tools：36.0.0
- 公開重建測試 APK SHA-256：
  `3d46922c028fd8480a4ca2cb7b83385b7ee25549bf3d6a17a3c1ec1e6a8e4340`
- 測試簽章：Android debug certificate，僅用於重建驗證

公開 `verify-input.sh` 已拒絕非指定來源，指定來源驗證通過。公開 patch 的三個
payload 與內部最終 v4 解碼結果逐 byte 一致：

| Payload | SHA-256 |
| --- | --- |
| `AndroidManifest.xml` | `8817ebe497805e427ad101afc184e4da8d347c957f4535aabe781240de766b0e` |
| `res/values-land/styles.xml` | `95a1d1e495685661ecedd1226b8b65a6c3da06141d015ae468aac8264df4ae79` |
| `res/values-port/styles.xml` | `d7b088f1d479cdeaf7ed9ae6113206183c9a081512fb97ea4e2e2d210781649d` |

重建 APK 可由 `apksigner` 驗證 v1/v2/v3，`aapt` 顯示 package
`com.android.calculator2.preserved`、versionName `2.1-update1`、
versionCode 7。重新打包會重新處理 PNG 壓縮，且使用者簽章不同，因此完整
APK SHA-256 不要求與內部 v4 相同；Manifest、responsive styles 與未修改的
smali tree 才是可重現的修復內容。
