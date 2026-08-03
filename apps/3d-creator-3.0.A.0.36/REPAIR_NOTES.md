# 修復紀錄

## 原版

原版 `3.0.A.0.36` 能在 Xperia 1 III 安裝並載入 Sony framework，但有兩個連續
阻礙：Play expansion 下載終止後留下不可取消的 progress dialog；解開介面後，
native scanner 因 `ro.semc.product.device=BC` 不在支援表而 assertion abort。

## 版本線

| 版本 | 假設與改動 | 結果 |
| --- | --- | --- |
| v1 | 終止下載失敗時關閉既有 progress dialog | 真正主頁通過；掃描在 `GetBackCamera` abort |
| v2 | 把 `BC` 對應到 J81 `rose/milvus` | 掃描器存活，但 Camera device error 3 |
| v3 | 改用 J82 `rose/vulture` | 前後 Camera2 串流與校準入口通過 |
| v4 | 保留 v3，另對旋轉銷毀時的 `mFab.show()` 加 null guard | 5 次精確旋轉重現通過；最終候選 |

native v2/v3 都只改一個四位元組產品代碼槽中的 3 bytes，binary 長度不變。
完整 offset、輸入／輸出 hashes、反組譯證據、失敗 logs、APK 與簽署材料只保留
在私人 NAS 研究封存，不在 GitHub 分發。

## 不做的事

- 不偽造購買或 Google Play license。
- 不把下載失敗改寫成成功。
- 不提供或合成缺少的 Sony OBB 範例內容。
- 不停用 Sony thermal 或相機安全機制。
- 不重建 Sony 雲端、分享、列印或帳號後端。
- 不宣稱僅憑 CameraService frames 就完成完整 3D 成模。

## 回溯

已實測同一研究 signer 的 v4 → v3 → v4。v3 安裝 SHA-256 為
`331acd94de5fb5a79702c2e274494968d3e98a8f940ebbf6458704ef66f87adf`，
恢復 v4 後為
`2bf3121a3bd8456e59fce955fe60a5803acd22dbd2a4f4c050a1c525e06cd8ef`。
