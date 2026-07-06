# 行程路線規劃器（公開版）

單一 `index.html` 檔案、零後端、零建置——上傳到任何靜態空間就能跑。

## 部署方式（擇一）

1. **shinshing.tw 子目錄（建議）**：FTP 把 `index.html` 上傳到 `public_html/planner/`（或任何子目錄），網址即 `https://shinshing.tw/planner/`。跟主站同網域，GA4、品牌、SEO 都加分。
2. **Cloudflare Pages / GitHub Pages / Netlify**：把 `trip-map-planner/` 資料夾丟上去即可。

`data/star-travel-8days.json` 是阿新自己的行程資料，**公開部署時可以不上傳**（不影響工具運作）。

## 啟用使用人數統計（GA4）

打開 `index.html`，搜尋 `SITE_CONFIG`，把 GA4 評估 ID 填進去：

```js
const SITE_CONFIG = {
  analyticsId: 'G-XXXXXXXXXX'   // ← 填這裡；留空 = 完全不載入追蹤
};
```

建議在 GA4 建一個獨立的資料串流（或沿用 shinshing.tw 的 property 加一個串流）。已內建的自訂事件：

| 事件 | 意義 |
|---|---|
| `planner_loaded` | 工具被打開（看使用人數） |
| `add_stop` | 使用者加了地點（看活躍度） |
| `export_kml` / `copy_text` | 匯出行為（重度使用者） |
| `affiliate_click`（帶 `platform` 參數） | 聯盟連結點擊——**看哪個平台最會賺** |

## 聯盟連結維護

- 工具箱九條連結在 `index.html` 搜尋 `toolsGrid`；追蹤碼 source of truth 是 repo 的 `affiliate-config/*.json`，改碼時兩邊要同步。
- 情境式連結（搜尋 `affLink`）：🛏️ 住宿站 popup → Booking 搜尋（label=`shin-planner-stay`）；🎯 活動站 popup → KKday 搜尋。
- 全部已帶 `rel="sponsored nofollow noopener"`，側欄有揭露聲明。

## 公開流量的注意事項（免費服務的限制）

- **Google 圖磚**：目前直接用 `mt*.google.com` 圖磚端點（免 API key），嚴格說不在 Google 官方條款保障內。個人工具沒問題；若流量做大或要放廣告，建議改用 MapTiler／Thunderforest（有免費額度）或正式申請 Google Maps JS API。改底圖只要動 `setBaseLayer()` 一個函式。
- **OSRM 路線**（router.project-osrm.org）與 **Nominatim 搜尋**：都是社群免費服務，有流量禮儀限制（Nominatim 約 1 req/s）。搜尋已做 500ms 防抖；若日活躍破千再考慮自架或換付費 API。
- 使用者行程存在**各自瀏覽器的 localStorage**，互不相通、也不會傳到伺服器——隱私聲明可以直接這樣寫。
