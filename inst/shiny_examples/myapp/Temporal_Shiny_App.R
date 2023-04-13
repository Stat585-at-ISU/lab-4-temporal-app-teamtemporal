#Our shiny app!
ui <- fluidPage(
  dateRangeInput("daterange", "Date range:",
                 start = "2001-01-01",
                 end   = "2010-12-31")

)
server <- function(input, output) {}
shinyApp(ui, server)
