# 可重現建置驗證

- 已驗證輸入 APK SHA-256：`32bee2fab611f71914c2eed421630f2db9eae182476a07ae1cc2aa5ca0c61ae4`
- Apktool：3.0.2
- Java：JDK 17
- 必要 framework：相符 Sony `framework-res.apk` 與 UX framework APK
- Patch dry run：通過
- Decode、patch、rebuild、zipalign、sign：通過
- 重建 APK ZIP：通過
- APK Signature Scheme v1／v2／v3：通過

公開腳本已用文件指定原始 APK 及另一張 Android debug keystore 實際執行。
重建 APK 與內部 v3 實測 APK 都包含 1171 個非 `META-INF` entry；相對路徑、
新增／移除 entry 及每一個非簽章 payload SHA-256 完全一致，變更數為 0。
整包 APK hash 不同只因公開驗證使用不同簽章憑證。

第一次腳本審查在只提供 UX framework 時正確失敗。最終腳本因此明確要求
兩份相符 framework input，不會暗中依賴操作者的全域 Apktool cache。
