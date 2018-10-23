# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/16

# download mi_index json file by day

# pkgs
suppressPackageStartupMessages({
    library(optparse)
    library(lubridate)
})

# command line
read_arguments <- function() {
    
    arguments = parse_args(
        OptionParser(
            option_list = list(
                make_option(opt_str = c("-start", "--start-date"),
                            dest = "start_date",
                            default = "2013-10-01",
                            metavar = "yyyy-mm-dd",
                            help = "Setting the start date of crawling. (format: YYYY-MM-DD)(Default: %default)"),
                make_option(opt_str = c("-end", "--end-date"),
                            dest = "end_date",
                            default = "now_date",
                            metavar = "yyyy-mm-dd",
                            help = "Setting the end date of crawling. (format: YYYY-MM-DD)(Default: %default)"
                            ),
                make_option(opt_str = c("-r", "--response"),
                            dest = "response",
                            default = "json",
                            metavar = "file type",
                            help = "The type of download file. (json/csv)/(Default: %default)"),
                make_option(opt_str = c("-mp", "--module-path"),
                            dest = "module_path",
                            default = NULL,
                            metavar = "",
                            help = "Setting the path of module for source the functions in this project."),
                make_option(opt_str = c("-sp", "--save-path"),
                            dest = "save_path",
                            default = NULL,
                            metavar = "",
                            help = "Setting the path for save the download data and error record."),
                make_option(opt_str = c("-md", "--max-delay"),
                            dest = "max_delay",
                            default = 15,
                            metavar = "max delay time (unit: second)",
                            help = "Setting the maximum delay time of crawling, the minimum delay time is 5 sec.")
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

# dates generator: 
dates_generator <- function(start_date,
                            end_date,
                            frequency = "day") {
    
    dates = seq(from = as.Date(start_date), to = as.Date(end_date), by = frequency)
    dates = as.character(dates)
    dates = gsub(pattern = "-", replacement = "", dates)
    
    return(dates) 
}

# read dates txt
read_txt <- function(path,
                     file_name
                     ) {
    
    files = list.files(path = path, pattern = "*.txt")
    files_names = gsub(pattern = ".txt", replacement = "", x = files)
    
    if (identical(files_names, character(0))) {
        file = c("19700101")
    } else {
        for (name in files_names) {
            if (name == file_name) {
                file = readLines(con = paste0(path, file_name, ".txt"))
            }
        }
    }

    return(file)
    
}

# main: crawling by dates
main <- function() {
    
    # read command line
    arguments = read_arguments()
    
    # setting arguments
    start_date = arguments$start_date
    end_date = ifelse(test = arguments$end_date == "now_date", yes = as.character(date(now())), no = arguments$end_date)
    response = arguments$response
    module_path = path_check(path = arguments$module_path)
    save_path = path_check(path = arguments$save_path)
    max_delay = ifelse(test = arguments$max_delay >= 5, yes = arguments$max_delay, no = 10) 
    
    # source the crawling fucntion
    source(paste0(module_path, 'crawling.R'))
    
    # get dates vector
    ## request_dates
    request_dates = dates_generator(start_date = start_date,
                                    end_date = end_date)
    ## cache dates
    cache_dates = gsub(pattern = ".json", # step3: ignore ".json" text
                       replacement = "",
                       x = gsub(pattern = "mi_index_", # step2: ignore "mi_index_" text
                                replacement = "",
                                x = list.files(path = save_path,  # step1: read all name of files
                                               pattern = "*.json")))
    
    ## error dates
    error_date = read_txt(path = save_path,
                          file_name = "error")
    ## dates: { request - (suceess U error) }
    dates = setdiff(x = request_dates, y = union(x = cache_dates, y = error_date)) 
    
    # cat crawling infomation
    cat("----- Waitting to crawler dates list: ----- \n")
    cat(dates)
    cat("\n")
    cat(sprintf("----- Start to Crawling ----- \n"))
    
    # worker
    for (day in dates) {
        
        start_time = proc.time()
        tryCatch({
            # crawling
            crawler_mi_index(date = day,
                             response = response,
                             save_dir = save_path)
            
        },
        error = function(err) {
            
            # show crawler information
            cat(sprintf("----- Crawling is fail, The Data Date is %s ----- \n", day))
            
            # record the fail date
            write(file = paste0(save_path, "error.txt"),
                  x = day,
                  ncolumns = 1,
                  append = TRUE,
                  sep = ",")
            
        },
        finally = {
            
            # setting a random delay time
            Sys.sleep(ceiling(runif(1, 5, max_delay)))
            
            cat(sprintf("----- Sys.sleep: %s second ----- \n", round((proc.time() - start_time)[[3]], 3)))
            
        })
        
    }
}

main()
