# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/18

# parsing function of the mi_index data

# pkgs
library(jsonlite)

# parsing function from single file
parsing <- function(file # :string = full file path
                    ) {
    
    # read json file by full path
    read_file = jsonlite::read_json(file)
    
    # read tc columns
    tc_columns = read_file$fields5
    tc_columns = unlist(tc_columns, use.names = FALSE)
    
    # set en columns
    en_columns = c("stock_code", "stock_name",
                   "trade_volume", "transaction",
                   "trade_value", "opening_price",
                   "highest_price", "lowest_price",
                   "closing_price", "dir", "change",
                   "last_best_bid_price", "last_best_bid_volume",
                   "last_best_ask_price", "last_best_ask_volume", "price_eaming_ratio")
    
    # read quotes data
    data = read_file$data5
    
    # create data frame for record the daily quotes
    daily_quotes = data.frame(setNames(replicate(n = 16, expr = character(), simplify = FALSE), en_columns),
                              stringsAsFactors = FALSE)
    
    # parsing
    for (.id in seq_along(data)) {
        daily_quotes[.id, ] = unlist(data[[.id]])
    }
    
    # return daily_quotes
    return(daily_quotes)  # :data.frame
}