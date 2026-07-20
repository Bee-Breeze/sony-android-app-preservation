# HTC 跨品牌測試摘要

- 裝置：HTC One M8
- Android／API：6.0.1／23
- ABI：`armeabi-v7a,armeabi`
- 測試 artifact：與 Sony 最終 v2 相同，SHA-256
  `7c2c0445d6c98817b0ff0e8b79c4340a171b94ae424b08f7cdd8072cce487e34`
- 安裝結果：`INSTALL_FAILED_NO_MATCHING_ABIS`
- Runtime Root：未使用

最新版只含 `arm64-v8a` native library，HTC 測試機是 32 位元硬體／系統。
這是可重現的安裝前 ABI 邊界，不是 Sony framework 或 App 主頁崩潰。
測試後 package 仍不存在，裝置旋轉與核心服務狀態維持。

- 正規化結果：`htc_tested_failed_install_abi`
- 技術判定：`accepted_sony_only`
