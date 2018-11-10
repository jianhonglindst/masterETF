suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
})

## server side code
function(input, output, session) {
    
    output$single_etf <- DT::renderDataTable({
        query <- sqlInterpolate(ANSI(), 
                                "SELECT date,
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
                                        price_eaming_ratio
                                   FROM tw_stock_daily_quotes 
                                  WHERE stock_code = '0050';")
        data <- dbGetQuery(pool, query)
        result_dt <- DT::datatable(data)
        return(result_dt)
    })
}

