# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/14

# the stock crawler (daily)

# crawler
crawler <- function(stock_id,   # :str = "0050"
                    date,       # :str = YYYYMMDD (if use YYYY-MM-DD format will download the old data.)
                    save_dir    # :str = "~/.../.../stock/"
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
    cat("----- Crawling Stock ID:", stock_id, "-----", "\n")
    
    # crawling
    download.file(url, save_file)
    
    # end crawling
    cat("----- Finished Crawler -----", "\n")
}