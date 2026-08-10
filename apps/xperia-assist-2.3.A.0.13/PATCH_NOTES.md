# Xperia Assist 2.3.A.0.13 共存修復

## 輸入門檻

只接受 SHA-256 為
`89d8f59efd1f3410c8210b9a19ce6f1b1a25e3b176f597b91424792274af88f0`
的原始 APK。其他版本或重新打包檔不能套用本紀錄。

## 變更

1. `AndroidManifest.xml` 的 `ContributionProvider` authority：
   `com.sonymobile.getmore` 改為 `com.sonymobile.assist.legacy.getmore`。
2. `com/sonymobile/b/a/a$a.smali` 的 contribution-state URI 同步改名。
3. `com/sonymobile/assist/realtime/provider/ContributionProvider.smali` 內兩個
   authority 常數同步改名。
4. 使用 apktool 重建、zipalign，並以專案本地 Xperia Assist 研究憑證簽署。

沒有全域替換其他 `com.sonymobile.getmore` 字串；migration、inbox、client 與
Xperia Services 契約保持原樣。

## 重建概要

```bash
apktool d original.apk -o decoded
# 僅修改上列 Manifest 與兩個 smali 類別中的 Provider 自我參照
apktool b decoded -o repaired-unsigned.apk
zipalign -p -f 4 repaired-unsigned.apk repaired-aligned.apk
apksigner sign --ks xperia-assist-local-research.p12 repaired-aligned.apk
apksigner verify --verbose --print-certs repaired-aligned.apk
```

公開 repository 不提供原始 APK、重建 APK、Sony 程式碼或私人簽署金鑰。

## 最終門檻

- package：`com.sonymobile.assist`
- versionName：`2.3.A.0.13`
- versionCode：`4587533`
- APK SHA-256：
  `6ec6e0a347cf5f731d92f085c6bf469a7a6ccfa03b3de3c082744b1b6e8d3b6e`
- signer SHA-256：
  `86057e2e6e7fe3c8389f6d2c48c8aab543e78313b61d0482a7278ca4f25d5129`

