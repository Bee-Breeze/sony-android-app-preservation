# 無障礙測試摘要

- 基準字級：1.0
- 放大測試字級：1.3
- 結果：月曆主頁文字可讀，沒有裁切或重疊。
- 檢查互動 node：49
- 有文字或 content description：47
- 無標籤 node：2 個空白議程／清單 container，列為限制。
- TalkBack：系統已安裝的 Google TalkBack。
- TalkBack service：成功啟用及 bind，具有語音、觸覺與音效 feedback。
- 可觀察焦點：主導覽選單成功取得 TalkBack focus。

測試後已停用 TalkBack，enabled-service 清單回到空、
`accessibility_enabled` 回到 0、字級回到 1.0，Calendar 也回到當月。本項是
實體裝置的基本無障礙檢查，不宣稱完整 WCAG conformance。
