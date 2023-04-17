library(shiny)
library(tidyverse)
library(plotly)
library(devtools)
library(leaflet)
library(shiny)


#Read in data and get data range
load_all('./')
# Read in data and get date ranges
data("presslog_isu")
data("presslog_ames")

data("location")
locations <- read.csv("inst/location.csv")
#library(readr)

#locations <- read_csv("/Users/kundankumar/Documents/STAT_585/lab-4-temporal-app-teamtemporal/inst/locations.csv")
#View(locations)


# Define UI
ui <- fluidPage(
  leafletOutput("map")
)


server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet(locations) %>%
      addTiles() %>%
      addMarkers(lng = ~longitude, lat = ~latitude, popup = ~General.Location)
  })
}


shinyApp(ui, server)
