# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/10/16

# download mi_index json file by day

# pkgs
library(optparse)

# command line
read_arguments <- function() {
    
    arguments = parse_args(
        OptionParser(
            option_list = list(
                make_option(opt_str = c("-start", "--start-date"),
                            dest = "start_time",
                            default = "2013-10-01",
                            metavar = "yyyy-mm-dd",
                            help = "Setting the start date of crawling. (format: YYYY-MM-DD)(Default: %default)"),
                make_option(opt_str = c("-end", "--end-date"),
                            dest = "end_time",
                            default = "2018-10-01",
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
dates_generator <- function(start_time,
                            end_time,
                            frequency = "day") {
    
    dates = seq(from = as.Date(start_time), to = as.Date(end_time), by = frequency)
    dates = as.character(dates)
    dates = gsub(pattern = "-", replacement = "", dates)
    
    return(dates) 
}

# main: crawling by dates
main <- function() {
    
    # read command line
    arguments = read_arguments()
    
    # setting arguments
    start_time = arguments$start_time
    end_time = arguments$end_time
    response = arguments$response
    module_path = path_check(path = arguments$module_path)
    save_path = path_check(path = arguments$save_path)
    max_delay = arguments$max_delay
    
    # source the crawling fucntion
    source(paste0(module_path, 'crawling.R'))
    
    # get dates vector
    dates = dates_generator(start_time = start_time,
                            end_time = end_time)
    
    # work
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
            
            cat(sprintf("----- %s second ----- \n", round((proc.time() - start_time)[[3]], 3)))
            
        })
        
    }
}

main()
