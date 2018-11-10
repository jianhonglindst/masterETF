# -*- coding: utf-8 -*-
# Created by jianhonglindst at 2018/11/10

# link the packrat librarys to shiny-server
setwd("~/Github/masterETF/")
packrat::on()

# pacakges
suppressPackageStartupMessages({
    library(magrittr)
    library(dplyr)
    library(DT)
    library(plotly)
    library(RPostgreSQL)
    library(pool)
})

pool <- dbPool(
    drv = dbDriver("PostgreSQL", max.con = 100),
    dbname = "postgres",
    host = "localhost",
    port = 15432,
    user = "postgres",
    password = "abcd1234zyxw0987",
    idleTimeout = 3600000
)