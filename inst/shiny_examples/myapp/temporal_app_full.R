library(shiny)
library(plotly)
library(tidyverse)
library(lubridate)

#Read in data and get data range
# load("./data/presslog_isu.rda")
# load("./data/presslog_ames.rda")

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
                             #selectInput("selectData", "Choose Dataset to View", choices = list("ISU" = 1, "Ames" = 2), selected = 1),
                             dateRangeInput("dateRange", "Date range:", start=isu_date_range[1], end=isu_date_range[2]),
                             #dateRangeInput("dateRange", "Date range:", start = NULL, end   = NULL),
                             actionButton("submit", "View Data!")
                             )
                           , mainPanel(tabsetPanel(tabPanel("Number of Incidents per day",
                             plotOutput(outputId = "incidents") )),
                             tabsetPanel(tabPanel("Analyzing Aspects of Incidents",
                             tableOutput(outputId = "aspects") ))
                           ) )
)






#server function
server <- function(input, output) {
  # observe({
  #   if(input$selectData=="ISU"){
  #     updateDateRangeInput(session, "dateRange", "Date range:", start=isu_date_range[1], end=isu_date_range[2])
  #     data_used <- presslog_isu2
  #   } else{
  #     updateDateRangeInput(session, "dateRange", "Date range:", start=ames_date_range[1], end=ames_date_range[2])
  #     data_used <- presslog_ames2
  #   }
  #   })

  #Logan's code
  observeEvent(input$submit, {
    filter_range <- c(input$dateRange[1], input$dateRange[2])
    #print(filter_range)
    #filtered_data <- presslog_isu2 %>% dplyr::filter("Date.Reported">=filter_range[1]) %>% dplyr::filter("Date.Reported"<=filter_range[2])
    filtered_data <- presslog_isu2[presslog_isu2$Date.Reported>=filter_range[1],]
    filtered_data <- presslog_isu2[presslog_isu2$Date.Reported<=filter_range[2],]
    plot_data <- as.data.frame(table(filtered_data$Date.Reported))
    # fig <- plot_ly()%>%
    #   add_trace(data = plot_data, type = 'scatter', mode = 'lines', fill = 'tozeroy', x = ~Date, y = ~n, name = 'N') %>%
    #   layout(title = list(text = 'Number of incidents', font = list(size = 16)), showlegend = F,
    #          yaxis = list(title = 'Number of incidents', zerolinecolor = '#ffff',zerolinewidth = 2,gridcolor = 'ffff'),
    #          xaxis = list(zerolinecolor = '#ffff',zerolinewidth = 2,gridcolor = 'ffff'),
    #          plot_bgcolor='#e5ecf6')
    # options(warn = -1)
    #
    # fig <- fig %>%
    #   layout(
    #     xaxis = list(zerolinecolor = '#ffff',zerolinewidth = 2,gridcolor = 'ffff'),
    #     yaxis = list(zerolinecolor = '#ffff',zerolinewidth = 2,gridcolor = 'ffff'),
    #     plot_bgcolor='#e5ecf6', width = 900)

    plot1 <- ggplot(plot_data, aes(x=plot_data[1], y=plot_data[,2]) )

  })

  output$incidents <- renderPlotly({
    if(is.null(plot1)) return()
    plot1
  })

  output$aspects <- renderTable(filtered_data)


}


shinyApp(ui, server)











