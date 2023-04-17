#Our shiny app!

library(shiny)
library(tidyverse)
library(plotly)
library(devtools)
#Read in data and get data range
load_all('./')
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
isu_dispostition <- unique(presslog_isu2$Disposition)
isu_classifications <- unique(presslog_isu2$Classifications)

#ui function
ui <- fluidPage(
  titlePanel("AmesPD Press-logs: A Temporal Analysis"),
             sidebarLayout(
               sidebarPanel(
               # Inputs(Widgets) go here:
                 actionButton("isu", "ISU"),
                 actionButton("ames", "AMES"),
                 #date range
                 uiOutput("daterange"),

                 downloadButton("downloadData")
               ),
               mainPanel(
                 tabsetPanel(type = "tabs",
                             tabPanel("Number of Incidents per day",
                                      fluidRow(plotlyOutput("incidents"), style = "padding-top:20px"),
                                      fluidRow(plotlyOutput("monthly_incidents"), style = "padding-top:20px")),
                             tabPanel("Analyzing Aspects of Incidents", 
                                      selectInput("columnFilter", "Choose Aspects to filter by", choices = list("Disposition" = 1, "Classification" = 2), selected = 1),
                                      checkboxGroupInput("filterGroup", "Column Elements to filter", choices = NULL),
                                      tableOutput(outputId = "aspects"))
                             )
                 )
               )
  )







#server function
server <- function(input, output) {

  v <- reactiveValues(data = NULL, label = NULL)
  observeEvent(input$ames, {
    v$data <- presslog_ames2
    v$label = 'AMES'
    output$daterange <- renderUI({
      dateRangeInput("daterange", "Date range:",
                     min = ames_date_range[1],
                     max   = ames_date_range[2],
                     start = ames_date_range[2] - 60,
                     end = ames_date_range[2])
    })
  })

  observeEvent(input$isu, {
    v$data <- presslog_isu2
    v$label = 'ISU'
    output$daterange <- renderUI({
      dateRangeInput("daterange", "Date range:",
                     min = isu_date_range[1],
                     max   = isu_date_range[2],
                     start = isu_date_range[2] - 730,
                     end = isu_date_range[2])
    })
  })



# get filtered data
  data <- reactive({
    if(is.null(v$data)) return(NULL)
    req(input$daterange)
    if(is.null(input$daterange)) return(NULL)
    dates = input$daterange
    v$data %>%
      filter(Date.Reported > dates[1] & Date.Reported < dates[2])
  })
# Tab: 'Number of Incidents per day'
  output$incidents <- renderPlotly({
    #filter by inputted dates
    incidents = data()
    validate(need(!is.null(incidents), "Please choose ISU or Ames!"))
    number_incidents = incidents %>%
      group_by(Date.Reported) %>%
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
    validate(need(!is.null(incidents), "Please choose ISU or Ames!"))
    number_incidents = incidents %>%
      mutate(Month.Reported = floor_date(Date.Reported, "month")) %>%
      group_by(date(Month.Reported )) %>%
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

  label = reactive({v$label})
  output$downloadData <- downloadHandler(
    filename = function() {sprintf("presslog_%s_%s_to_%s.csv", label(), input$daterange[1], input$daterange[2])},
    content = function(file) {
      write.csv(data(), file)
    })
  # Tab: 'aspects'
  observeEvent(input$columnFilter, {
    if (input$columnFilter == "Disposition") {
      updateCheckboxGroupInput(session = getDefaultReactiveDomain(), "filterGroup", "Column Elements to filter", choices = isu_disposition)
    } else {
      updateCheckboxGroupInput(session = getDefaultReactiveDomain(), "filterGroup", "Column Elements to filter", choices = isu_classifications)
    }
  })
  
  output$aspects <- renderTable({
    df = as.data.frame(data())
    validate(need(nrow(df) != 0, "Please choose ISU or Ames!"))
    df %>% mutate_at(c('longitude', 'latitude'), round, digits = 2) %>%
      mutate_all(as.character)

    })


}

shinyApp(ui, server)

