#Our shiny app!
ui <- fluidPage(
  # App title ----
  titlePanel("AmesPD"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(
      dateRangeInput("daterange", "Date range:",
                     start = "2001-01-01",
                     end   = "2010-12-31")

    ),

    # Main panel for displaying outputs ----
    mainPanel(

      tabsetPanel(type = "tabs",
                  tabPanel("A"),
                  tabPanel("B")
      )
    )
  )

)
server <- function(input, output) {}
shinyApp(ui, server)
