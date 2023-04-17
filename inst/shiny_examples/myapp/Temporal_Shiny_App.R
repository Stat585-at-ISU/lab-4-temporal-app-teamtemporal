#Our shiny app!

library(shiny)
library(tidyverse)
library(lubridate)

#Read in data and get data range
#load("./data/presslog_isu.rda")
#load("./data/presslog_ames.rda")

data("presslog_isu")
data("presslog_ames")

presslog_ames2 <- separate(presslog_ames, "Call Received Date/Time", c("Date.Reported", "Time.Reported"), sep=" ", fill="right")
presslog_ames2$Date.Reported <- ymd(presslog_ames2$Date.Reported)
presslog_ames2$Time.Reported <- hms(presslog_ames2$Time.Reported)
ames_date_range <- c(min(presslog_ames2$Date.Reported), max(presslog_ames2$Date.Reported))

presslog_isu2 <- separate(presslog_isu, "Date.Time.Reported", c("Date.Reported", "Time.Reported"), sep=" ", fill="right")
presslog_isu2$Date.Reported <- ymd(presslog_isu2$Date.Reported)
presslog_isu2$Time.Reported <- hms(presslog_isu2$Time.Reported)
isu_date_range <- c(min(presslog_isu2$Date.Reported), max(presslog_isu2$Date.Reported))

#ui function
ui <- fluidPage(titlePanel("AmesPD Press-logs: A Temporal Analysis"),
                sidebarLayout(sidebarPanel( # Inputs(Widgets) go here:
                  dateRangeInput("dateRange", "Date range:", start=isu_date_range[1], end=isu_date_range[2]),
                              )
      , mainPanel(tabsetPanel(tabPanel("Number of Incidents",
        plotOutput(outputId = "incidents") )),
      tabsetPanel(tabPanel("Analyzing Aspects of Incidents",
        plotOutput(outputId = "aspects") ))
      )
))






#server function
server <- function(input, output) {
  observe({
    filter_range <- c(input$dateRange[1], input$dateRange[2])
    filtered_data <- presslog_isu2 %>% filter("Date.Reported">=filter_range) %>% filter("Date.Reported"<=filter_range)
  })


  output$incidents <- renderPlot({
    plot_data <-as.data.frame(table(filtered_data$Date.Reported))
    ggplot(plot_data, aes(x=plot_data[,1], plot_data[,2]))
  })

  output$aspects <- renderTable(filtered_data)


}

shinyApp(ui, server)








# ui <- fluidPage(
#   # App title ----
#   titlePanel("AmesPD"),
#
#   # Sidebar layout with input and output definitions ----
#   sidebarLayout(
#
#     # Sidebar panel for inputs ----
#     sidebarPanel(
#       dateRangeInput("daterange", "Date range:",
#                      start = "2001-01-01",
#                      end   = "2010-12-31")
#
#     ),
#
#     # Main panel for displaying outputs ----
#     mainPanel(
#
#       tabsetPanel(type = "tabs",
#                   tabPanel("A"),
#                   tabPanel("B")
#       )
#     )
#   )
#
# )
# server <- function(input, output) {}
# shinyApp(ui, server)

