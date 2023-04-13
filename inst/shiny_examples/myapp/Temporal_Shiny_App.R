#Our shiny app!
library(shiny)

#Read in data and get data range


#ui function
ui <- fluidPage(titlePanel("AmesPD Press-logs: A Temporal Analysis",
                sidebarLayout(sidebarPanel( # Inputs(Widgets) go here:
                              ))
      ,mainPanel(tabsetPanel(
        plotOutput(outputId = "distPlot")
      ), tabsetPanel(
        plotOutput(outputId = "distPlot")
      )
      )
))






#server function


