# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/18

# parsing function of the mi_index data

# pkgs
suppressPackageStartupMessages({
    library(jsonlite) 
})

# env setting: for ignore the warning message
options(warn=-1)

# parsing function from single file
parsing <- function(file # :string = full file path
                    ) {
    
    # read json file by full path
    read_file = jsonlite::read_json(file)
    
    # read tc columns
    #tc_columns = read_file$fields5
    #tc_columns = unlist(tc_columns, use.names = FALSE)
    
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
    for (stock in seq_along(data)) {
        daily_quotes[stock, ] = unlist(data[[stock]])
    }
    
    # add date column
    date = as.character(read_file$date)
    daily_quotes = cbind(date = date, daily_quotes)
    
    # clean
    ## dir: convert '" ", "<p style= color:green>-</p>", "<p style= color:red>+</p>", "X"' to 'NA, "-", "+", "X"'
    daily_quotes[, "dir"] = lapply(X = daily_quotes[, "dir"],
                                   FUN = function(element) (ifelse(test = element == " ",
                                                                   yes = NaN,
                                                                   no = ifelse(test = element == "<p style= color:green>-</p>",
                                                                               yes = "-",
                                                                               no = ifelse(test = element == "<p style= color:red>+</p>",
                                                                                           yes = "+",
                                                                                           no = "X")))))
    
    # setting the type of vars
    ## numeric type
    numeric_vars = c("trade_volume", "transaction", "trade_value", "opening_price", "highest_price", "lowest_price", "closing_price", "change", 
                     "last_best_bid_price", "last_best_bid_volume", "last_best_ask_price", "last_best_ask_volume", "price_eaming_ratio")
    
    ## character type
    character_vars = c("date", "stock_name", "dir")
    
    # convert type
    ## numeric type
    daily_quotes[, numeric_vars] = lapply(X = daily_quotes[, numeric_vars],
                                          FUN = function(element) as.numeric(gsub(pattern = ",", replacement = "", x = element)))
    
    ## character type
    daily_quotes[, character_vars] = lapply(X = daily_quotes[, character_vars],
                                            FUN = as.character)
    
    # return daily_quotes
    return(daily_quotes)  # :data.frame
}
