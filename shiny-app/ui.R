suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
})



dashboardPage(
    # header
    dashboardHeader(
        title = "masterETF Dashboard"
    ),
    # sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem(
                text = "RawData",
                tabName = "datatable",
                icon = icon("dashboard")
            )
        )
    ),
    # body
    dashboardBody(
        tabItem(
            tabName = "datatable",
            fluidPage(
                box(
                    DT::dataTableOutput("single_etf")
                )
            )
        )
    ),
    # setting
    skin = "red"
)