## mian

 序   | 功能          | 程式名稱                                 |
------|---------------|------------------------------------------|
[1]   |每日收盤價爬蟲 | [crawling_worker.R](#crawling_worker)|
 
## <span id = "crawling_worker"> 每日收盤價爬蟲: `crawling_worker.R` </span>

#### 功能描述

1. 說明: 指定日期區間，自動下載日期區間內的 `MI_INDEX` 資料至指定資料夾。
2. 時機: 任何時候/自訂排程。
3. 方式: 命令列呼叫

#### 命令列說明

序  | 實名變數       | 描述                  | 內容                   | 範例                       | 預設值      |
----|----------------|-----------------------|------------------------|----------------------------|-------------|
[1] | `--start-date` | 起始日期              | `yyyy-mm-dd`           | `2013-10-01`               | `2013-10-01`|
[2] | `--end-date`   | 結束日期              | `yyyy-mm-dd`           | `2018-10-01`               | `now_date`  |
[3] | `--response`   | 檔案類型              | `json`(default), `csv` | `json`                     | `json`      |
[4] | `--save-path`  | 儲存資料路徑          | `../../mi_index`       | `../crawler/stock/mi_index`| `-`         |
[5] | `--max-delay`  | 下載最大延遲時間 (sec)| `integer`              | `15`                       | `15`        |

#### 使用範例

```
Rscript /home/../masterETF/main/crawling_worker.R --start-date=2013-10-01 --end-date=2018-10-10 --save-path=../crawler/stock/mi_index
```

```
Rscript /home/../masterETF/main/crawling_worker.R --save-path=../crawler/stock/mi_index
```

#### note

- 如果沒有指定`--end-date`，此程式會自動使用當天的日期，所以最懶人的下載方式，只要設定欲儲存的資料的路徑`--save-path`即可。(如使用範例2)
- 如果是使用預設的`now_date`，程式內部會自動代入前一天的日期，因為`mi_index`資料是當日收盤行情，所以如果在收盤前就啟動的話，系統依然會獲得一份檔案，但此檔案內會沒有資料，故在保障可獲得資料的前提下，使用`now_date`，則會代入前一天的日期。


#### 版本紀錄

```
versio: 1.0.0 (crawling_by_date.R)
date: 2018/10/16
```

```
version: 2.0.0 (crawling_worker.R)
date:  2018/10/28
fix: 
	1. delete `moudle_path`
	2. using new Rscript `crawling_worker.R`
```