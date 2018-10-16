# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/14

# the stock crawler (daily)

# crawler: stock_day 
crawler <- function(stock_id,   # :character = "0050"
                    date,       # :character = YYYYMMDD (if use YYYY-MM-DD format will download the old data.)
                    save_dir    # :character = "~/.../.../stock/"
                    ) {
    
    # generating file name and setting the save path
    if (endsWith(save_dir, "/")) {
        save_file = sprintf("%sstock_%s_%s.txt", save_dir, stock_id, date)
    } else {
        save_file = sprintf("%s/stock_%s_%s.txt", save_dir, stock_id, date)
    }
    
    # generating crawling url
    url = sprintf("http://www.twse.com.tw/exchangeReport/STOCK_DAY?response=csv&date=%s&stockNo=%s", date, stock_id)
    
    # show crawler information
    cat(sprintf("----- Crawling Stock ID: %s || at Date: %s ----- \n", stock_id, date))
    
    # crawling
    download.file(url = url,
                  destfile = save_file,
                  quiet = TRUE)

}



# crawler: 
crawler_mi_index <- function(date,       # :character = YYYYMMDD (if use YYYY-MM-DD format will download the old data.)
                             response,   # :character = json/csv
                             save_dir    # :character = "~/.../.../stock/"
                             ) {
    
    # generating file name and setting the save path
    if (endsWith(save_dir, "/")) {
        save_file = sprintf("%smi_index_%s.%s", save_dir, date, response)
    } else {
        save_file = sprintf("%s/mi_index_%s.%s", save_dir, date, response)
    }
    
    # generating crawling url
    url = sprintf("http://www.twse.com.tw/exchangeReport/MI_INDEX?response=%s&date=%s&type=ALL", response, date)
    
    # show crawler information
    cat(sprintf("----- Crawling Stock MI_INDEX Data, The Data Date is %s ----- \n", date))
    
    # crawling
    download.file(url = url,
                  destfile = save_file,
                  quiet = TRUE)
    
}

crawler_mi_index(date = '20181001',
                 response = 'json',
                 save_dir = '/media/lewislin/Ubuntu/crawler'
                 )