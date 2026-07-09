# 行程路線規劃器（公開版）

單一 `index.html` 檔案、零建置——上傳到任何靜態空間就能跑。
線上版：https://ashin047.github.io/trip-planner/

## 更新部署

- **GitHub Pages（現行）**：改完 `index.html` 後執行 `deploy.ps1`（git push，1–2 分鐘生效）。
- **shinshing.tw 子目錄（規劃中）**：填好 `ftp-config.local.json`（複製 `.example`）後執行 `deploy-shinshing.ps1`。
- `data/star-travel-8days.json` 是阿新私人行程，被 `.gitignore` 排除，公開 repo 沒有它。

## 架構速覽

- **地圖**：Leaflet；底圖預設 CARTO light（英文地名），可切 Google 圖磚（mt*.google.com，免 key）。
- **路線**：OSRM（免費公服）計算開車段；`✈️` 類型站的前一段畫虛線不計里程；`osrmFetch` 佇列同時上限 4 個請求。
- **搜尋**：內建 `NZ_POI` 紐西蘭景點中文字典（含機場/租車點，「精選」置頂）→ Nominatim 全球搜尋（NZ 優先、國旗標示）。字典比中規則：城市別名需佔查詢 ≥60% 才置頂，避免蓋掉店家。
- **分享**：`#trip=`（LZ 壓縮進網址、零後端）；**共編** `#sync=`（Firebase RTDB `trip-planner-sync-5ca5c`，asia-southeast1，規則只允許單筆 `/trips/$id` 讀寫）。
- **儲存**：localStorage 即時自動存＋「行程版本」快照；收合狀態存 `trip-map-planner-collapsed`（不進行程資料）。

## GA4 統計

`SITE_CONFIG.analyticsId = 'G-7LD9T7TJBX'`（資源「紐西蘭旅遊攻略」→ 串流「行程規劃器 trip-planner」）。

| 事件 | 意義 |
|---|---|
| `planner_loaded` | 工具被打開 |
| `demo_loaded` / `welcome_start_blank` | 入門路徑選擇 |
| `share_created` / `share_opened` / `sync_created` / `sync_joined` | 分享與共編 |
| `booking_list_open` | 一鍵預訂清單開啟 |
| `affiliate_click`（`partner`＋`cta_position` 參數） | 聯盟點擊——對齊資源既有自訂維度，與 shinshing.tw 部落格同一套報表 |

## 聯盟連結維護

追蹤碼 source of truth：repo 根目錄 `affiliate-config/*.json`，改碼時同步 `index.html`。

| 觸點 | 位置（搜尋關鍵字） | Booking label |
|---|---|---|
| 工具箱 9 平台 | `toolsGrid` | `shin-planner-tools` |
| 住宿站彈窗「查 M/D 空房」 | `bookingStayUrl` | `shin-planner-stay-popup` |
| 每日 footer「訂 M/D 住宿」 | `bookingStayUrl` | `shin-planner-stay-day` |
| 一鍵預訂清單（機票/逐晚住宿/租車/eSIM/活動） | `buildBookingList` | `shin-planner-stay-list` |

住宿深連結自動帶「地點＋checkin/checkout（依出發日推算）＋2 人」。全部 `rel="sponsored nofollow noopener"`，側欄與清單皆有揭露聲明。

## 免費服務限制

- Google 圖磚端點嚴格說不在官方條款保障內；流量大時改 MapTiler/Thunderforest 或正式 API（只動 `setBaseLayer()`）。
- OSRM／Nominatim 為社群服務：搜尋已 500ms 防抖、路線已佇列節流；日活躍破千再考慮自架。
- 行程存在使用者各自瀏覽器，不上傳伺服器（共編除外，存 Firebase、僅知道連結者可讀寫）。
