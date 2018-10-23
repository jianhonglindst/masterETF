## mian

 序   | 功能          | 程式名稱                                 |
------|---------------|------------------------------------------|
[1]   |每日收盤價爬蟲 | [crawling_by_dates.R](#crawling_by_dates)|
 
## <span id = "crawling_by_dates"> 每日收盤價爬蟲: `crawling_by_dates.R` </span>

#### 功能描述

1. 說明: 指定日期區間，自動下載日期區間內的 `MI_INDEX` 資料至指定資料夾。
2. 時機: 任何時候/自訂排程。
3. 方式: 命令列呼叫

#### 命令列說明

序  | 實名變數       | 描述                  | 內容                  | 範例                       | 預設值      |
----|----------------|-----------------------|-----------------------|----------------------------|-------------|
[1] | `--start-date` | 起始日期              | `yyyy-mm-dd`          | `2013-10-01`               | `2013-10-01`|
[2] | `--end-date`   | 結束日期              | `yyyy-mm-dd`          | `2018-10-01`               | `now_date`  |
[3] | `--response`   | 檔案類型              | `json`(default), `csv`|  `json`                    | `json`      |
[4] | `--module-path`| 子程式路徑            |`../../main`           | `/home/../masterETF/main`  | `-`         |
[5] | `--save-path`  | 儲存資料路徑          | `../../mi_index`      | `../crawler/stock/mi_index`| `-`         |
[6] | `--max-delay`  | 下載最大延遲時間 (sec)| `integer`             | `15`                       | `15`        |

#### 使用範例

```
Rscript /home/../masterETF/main/crawling_by_dates.R --start-date=2013-10-01 --end-date=2018-10-10 --module-path=/home/../masterETF/main --save-path=../crawler/stock/mi_index
```

#### note

- 如果沒有指定`--end-date`，此程式會自動使用當天的日期，所以最懶人的下載方式，只要設定專案模組路徑`--module-path`和欲儲存的資料的路徑`--save-path`即可。