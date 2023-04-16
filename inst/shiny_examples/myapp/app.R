#Our shiny app!

library(shiny)
library(tidyverse) #loading this will load both lubridate and dplyr
#library(lubridate)
#library(AmesPD) --> this package is not needed
#library(dplyr)
library(plotly)
#Read in data and get data range

data("presslog_isu")

min_date = min(presslog_isu$Date.Time.Reported)
max_date = max(presslog_isu$Date.Time.Reported)
#ui function
ui <- fluidPage(
  titlePanel("AmesPD Press-logs: A Temporal Analysis"),
             sidebarLayout(
               sidebarPanel(
               # Inputs(Widgets) go here:

               #date range
               dateRangeInput("daterange", "Date range:",
                              min = as.Date(min_date),
                              max   = as.Date(max_date),
                              start = as.Date(max_date) - 730,
                              end = as.Date(max_date))
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Plot",
                                      fluidRow(plotlyOutput("incidents"), style = "padding-top:20px"),
                                      fluidRow(plotlyOutput("monthly_incidents"), style = "padding-top:20px")),
                             tabPanel("B",
                               plotOutput(outputId = "aspects"))
                             )
                 )
               )
  )







#server function
server <- function(input, output) {

  data <- reactive({
    dates = input$daterange
    presslog_isu %>%
      filter(Date.Time.Reported > dates[1] & Date.Time.Reported < dates[2])
  })

  output$incidents <- renderPlotly({
    #filter by inputted dates
    incidents = data()
    number_incidents = incidents %>%
      group_by(date(Date.Time.Reported )) %>%
      count()
    names(number_incidents) = c('Date', 'n')
    number_incidents = as.data.frame(number_incidents)

    fig <- plot_ly()%>%
      add_trace(data = number_incidents, type = 'scatter', mode = 'lines',
                fill = 'tozeroy', x = ~Date, y = ~n, name = 'N') %>%
      layout(title = list(text = 'Number of incidents', font = list(size = 16)),
             showlegend = F,
             yaxis = list(title = 'Number of incidents',
                          zerolinecolor = '#ffff',
                          zerolinewidth = 2,
                          gridcolor = 'ffff'),
             xaxis = list(zerolinecolor = '#ffff',
                          zerolinewidth = 2,
                          gridcolor = 'ffff'),
             plot_bgcolor='#e5ecf6')
    options(warn = -1)
    fig <- fig %>%
      layout(
        xaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff'),
        yaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff'),
        plot_bgcolor='#e5ecf6', width = 900)


    fig
  })

  output$monthly_incidents <- renderPlotly({
    #filter by inputted dates
    incidents = data()
    number_incidents = incidents %>%
      mutate(Month.Time.Reported = floor_date(Date.Time.Reported, "month")) %>%
      group_by(date(Month.Time.Reported )) %>%
      count()
    names(number_incidents) = c('Date', 'n')
    number_incidents = as.data.frame(number_incidents)

    fig <- plot_ly() %>%
      add_trace(data = number_incidents,
                x = ~Date,
                y = ~n,
                type = 'bar',
                xperiod="M1",
                hovertemplate="%{y}<extra></extra>") %>%
      layout(title = list(text = 'Number of incidents by month', font = list(size = 16)),
             showlegend = F,
             yaxis = list(title = 'Number of incidents'))
    fig

  })

  output$aspects <- renderTable(filtered_data)


}

shinyApp(ui, server)

