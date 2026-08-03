# 測試結果

## Sony Xperia 1 III／Android 13

| 驗證 | 結果 |
| --- | --- |
| Launcher | `com.sonymobile.intouchsignup/.MainActivity`，冷啟動約 699 ms |
| 真正服務流程 | 已進入自動裝置註冊，但 Sony 後端已退役，`dependency_limited` |
| 穩定畫面 | 兩張相隔 2 秒的 App-only frame 與 UI hierarchy 完全一致 |
| 直向版面 | 通過，無 App 黑邊、裁切、重疊或錯誤拉伸 |
| 1.3 倍字體 | 訊息及「確定」按鈕完整可見 |
| 橫向 | MainActivity 原生固定直向，經旋轉請求仍保持正確直向契約 |
| 唯一可見控制 | 「確定」5/5 次正常關閉並返回 Xperia Home |
| 穩定性 | 五輪零 attributable fatal exception／ANR |
| 回復 | v1 → Sony 原版 → v1；兩個 installed hash 均精確吻合 |

註冊與韌體交付沒有通過，原因是已退役的 Sony 後端，不是 APK 安裝或畫面修復
失敗。因此技術決策維持 `partial`。

## HTC One M8／Android 6.0.1

同一最終 APK 以一般 Package Manager 安裝，回傳：

```text
Failure [INSTALL_FAILED_MISSING_SHARED_LIBRARY]
```

HTC 缺少 App manifest 強制要求的 `com.sony.device`。package 在測試前後皆不存在，
沒有 Root 強裝、沒有建立 App data，也不宣稱跨品牌相容。

## 控制閉合

- Screens：1
- Controls：1
- Passed：1
- Failed：0
- Blocked controls：0
- Blocked workflow：Sony Concept 裝置註冊與韌體交付
