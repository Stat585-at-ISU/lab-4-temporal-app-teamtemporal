library(shiny)
library(tidyverse)
library(plotly)
library(devtools)
library(leaflet)

#Read in data and get data range
load_all('./')
# Read in data and get date ranges
data("presslog_isu")
data("presslog_ames")

presslog_ames2 <- separate(presslog_ames, "Call Received Date/Time", c("Date.Reported", "Time.Reported"), sep=" ", fill="right")
presslog_ames2$Date.Reported <- ymd(presslog_ames2$Date.Reported)
ames_date_range <- c(min(presslog_ames2$Date.Reported), max(presslog_ames2$Date.Reported))

presslog_isu2 <- separate(presslog_isu, "Date.Time.Reported", c("Date.Reported", "Time.Reported"), sep=" ", fill="right")
presslog_isu2$Date.Reported <- ymd(presslog_isu2$Date.Reported)
isu_date_range <- c(min(presslog_isu2$Date.Reported), max(presslog_isu2$Date.Reported))

# Define UI
ui <- fluidPage(
  titlePanel("AmesPD Press-logs: A Temporal Analysis"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dateRange", "Date range:", start=ames_date_range[1], end=ames_date_range[2])),

      #dateRangeInput("dateRange", "Date range:", start=asu_date_range[1], end=asu_date_range[2])),
    mainPanel(
      leafletOutput(outputId = "map")
    )
  )
)

# Define server
server <- function(input, output) {

  # Filter data based on date range input
  filtered_data <- reactive({
    presslog_isu2 %>%
      filter(Date.Reported >= input$dateRange[1] & Date.Reported <= input$dateRange[2])
  })

  # Create map of incidents
  output$map <- renderLeaflet({
    leaflet(data = filtered_data()) %>%
      addTiles() %>%
      addMarkers(lng = ~Long, lat = ~Lat, popup = ~Incident.Description)
  })
}

# Run app
shinyApp(ui, server)
