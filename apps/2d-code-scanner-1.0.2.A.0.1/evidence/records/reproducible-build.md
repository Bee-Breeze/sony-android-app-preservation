# 可重現建置驗證

- 已驗證輸入 APK SHA-256：
  `883cd3561721602d9efa3f8bde0982151d4dbf87349837439355665eaf05ba39`
- JDK：17
- Android build-tools：36.0.0
- Manifest 精準定位：`uses-sdk/minSdkVersion` 34 → 33；
  唯一 `uses-library/required` true → false
- clean ZIP、CRC、zipalign 與 APK Signature Scheme v3：通過

公開腳本已用文件指定的精確原始 APK 與另一張 Android debug keystore
實際執行。重建 APK 與內部最終 v2 都有 289 個非 `META-INF` entry；
每個相對路徑及非簽章 payload SHA-256 完全一致，差異數為 0。整包 APK
hash 不同僅因公開驗證使用不同簽章憑證。

腳本會先鎖定原始 APK hash，並要求可執行的 JDK、`zipalign` 與
`apksigner`。若輸入、舊 Manifest 值、match 數量或簽署輸出不符，會停止，
避免把意外版本靜默包成成品。
