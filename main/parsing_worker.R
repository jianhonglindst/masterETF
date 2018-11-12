# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/24

# (version 1.0.0)automatic parse all data to database (postgresql/sqlite)

# pkgs
suppressPackageStartupMessages({
    library(DBI)
    library(optparse)
    library(jsonlite)
    library(RPostgres)
})

# env setting: for ignore the warning message
options(warn=-1)

# command line
read_arguments <- function() {
    
    arguments = parse_args(
        OptionParser(
            option_list = list(
                make_option(opt_str = c("-lp", "--load-path"),
                            dest    = "load_path",
                            default = NULL,
                            metavar = "",
                            help    = "Setting the path for load the download data and error record."),
                make_option(opt_str = c("-conf", "--config"),
                            dest    = "config_file",
                            default = NULL,
                            metavar = "",
                            help    = "Using custom config path. (Default: None)")
            )
        )
    )
    
    return(arguments)
}

# path check:
path_check <- function(path) {
    
    if (endsWith(path, "/")) {
        path = path
    } else {
        path = paste0(path, "/")
    }
    
    return(path)
}

# read dates txt
read_txt <- function(path,
                     file_name
                     ) {
    
    files = list.files(path = path, pattern = "*.txt")
    files_names = gsub(pattern = ".txt", replacement = "", x = files)
    
    if (!file_name %in% files_names) {
        file = c("mi_index_19700101.json")
    } else {
        for (name in files_names) {
            if (name == file_name) {
                file = readLines(con = paste0(path, file_name, ".txt"))
            }
        }
    }
    
    return(file)
    
}

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
    date = as.character(as.Date(as.character(read_file$date), format = '%Y%m%d'))
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
    numeric_vars = c("trade_volume", "transaction", "trade_value",
                     "opening_price", "highest_price", "lowest_price",
                     "closing_price", "change", "last_best_bid_price",
                     "last_best_bid_volume", "last_best_ask_price", "last_best_ask_volume",
                     "price_eaming_ratio")
    
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

# connect to database
connect <- function(config,  # :json -> 'config.json'
                    source   # :character -> 'postgres_tw_stock'
                    ) {
    
    connect_ = get(x   = source,
                   pos = config)
    
    conn = dbConnect(RPostgres::Postgres(),
                     dbname   = connect_$database,
                     host     = connect_$host,
                     port     = connect_$port,
                     user     = connect_$user,
                     password = connect_$password
                     )
    
    return(conn)
}

# sql
sql = "INSERT INTO tw_stock_daily_quotes (date,
                                          stock_code,
                                          stock_name,
                                          trade_volume,
                                          transaction,
                                          trade_value,
                                          opening_price,
                                          highest_price,
                                          lowest_price,
                                          closing_price,
                                          dir,
                                          change,
                                          last_best_bid_price,
                                          last_best_bid_volume,
                                          last_best_ask_price,
                                          last_best_ask_volume,
                                          price_eaming_ratio)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
           ON CONFLICT(date, stock_code)
           DO UPDATE
          SET stock_name           = excluded.stock_name,
              trade_volume         = excluded.trade_volume,
              transaction          = excluded.transaction,
              trade_value          = excluded.trade_value,
              opening_price        = excluded.opening_price,
              highest_price        = excluded.highest_price,
              lowest_price         = excluded.lowest_price,
              closing_price        = excluded.closing_price,
              dir                  = excluded.dir,
              change               = excluded.change,
              last_best_bid_price  = excluded.last_best_bid_price,
              last_best_bid_volume = excluded.last_best_bid_volume,
              last_best_ask_price  = excluded.last_best_ask_price,
              last_best_ask_volume = excluded.last_best_ask_volume,
              price_eaming_ratio   = excluded.price_eaming_ratio,
              __update_time        = now(); 
       "

# main: parsing worker
main <- function() {
    
    # read command line
    arguments   = read_arguments()
    
    # setting arguments
    load_path   = path_check(path = arguments$load_path)
    save_path   = load_path
    config_file = arguments$config_file
    
    # get config
    config = read_json(path = config_file,
                       simplifyVector = TRUE)
    
    # get files vector
    ## all files in raw data dir
    all_files = list.files(path = load_path, pattern = "*.json")
    
    ## finished file
    finished_files = read_txt(path = load_path, file_name = "parsing_finished")
    
    ## parsing_error file
    error_files = read_txt(path = load_path, file_name = "parsing_error")
    
    ## missions: { all_files - finished_files }
    mission_files = setdiff(x = all_files, y = union(x = finished_files, y = error_files))
    
    # cat parsing infomation
    cat("----- Waitting to parsing data list: ----- \n")
    cat(mission_files)
    cat("\n")
    cat(sprintf("----- Start to Parsing ----- \n"))
    
    # worker
    for (mission in mission_files) {
        start_time = proc.time()
        tryCatch({
                    
            # show crawler information
            cat(sprintf("----- Parsing Stock MI_INDEX Data, The file name is %s ----- \n", mission))
            
            # parsing
            format_data = parsing(file = paste0(load_path, mission))
            
            # insert data to database
            postgres_connect = connect(config = config, source = "postgres_tw_stock")
            for (idx_format_data in 1:dim(format_data)[1]) {
                
                # insert by row
                row_data = format_data[idx_format_data, ]

                query = dbSendQuery(conn = postgres_connect,
                                    statement = sql,
                                    params = unlist(row_data, use.names = FALSE))

                dbClearResult(query)
            }
            dbDisconnect(postgres_connect)
            
            # record the fail mission
            write(file = paste0(save_path, "parsing_finished.txt"),
                  x = mission,
                  ncolumns = 1,
                  append = TRUE,
                  sep = ",")
            
        },
        error = function(err) {
            
            # show crawler information
            cat(sprintf("----- Parsing is fail, The file name is %s ----- \n", mission))
            
            # record the fail mission
            write(file = paste0(save_path, "parsing_error.txt"),
                  x = mission,
                  ncolumns = 1,
                  append = TRUE,
                  sep = ",")
            
        },
        finally = {
            
            # cat fin
            cat(sprintf("----- Parsing and Insert: %s second ----- \n", round((proc.time() - start_time)[[3]], 3)))
            
        })
        
    }
}

main()