# External monitor 8.0.A.0.6 技術測試摘要

- 目錄索引：223
- Package：`com.sonymobile.extmonitorapp`
- 最終 artifact：未修改的 Sony 原始 APK
- APK SHA-256：`4edcdc0f968b0eb41c5b9dd7fdd6b7c6d5255e2ff250d76ee1843ef26f466d0c`
- Sony Xperia 1 III：`passed_with_root`
- HTC One M8：`second_oem_tested_failed_install`
- 技術結論：`partial`

Sony 端已測試真正的未連線主頁、完整教學、監視器設定、錄製設定及自訂
RTMP 設定。畫面固定橫向、沒有 App 產生的黑邊或可歸責崩潰。測試沒有輸入
帳號、URL 或金鑰，也沒有啟動錄影或串流。

尚未閉合的產品能力是實際 UVC 影像輸入、錄影及網路發布。公開與私人檔名
必須保留 `PARTIAL`，直到相同 artifact 完成硬體測試。

HTC 安裝由 Package Manager 在建立 package 前拒絕：精確 APK 為
`arm64-v8a`、minimum API 31，而 HTC One M8 為 `armeabi-v7a`、API 23。
測試後沒有留下 package 或資料。
