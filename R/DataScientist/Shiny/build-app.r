# Build Shiny Apps
# It’s time to build your own Shiny apps. You’ll make several apps from scratch, including one that allows you to 
# gather insights from the Mental Health in Tech Survey and another that uses recipe ingredients as its input to 
# accurately categorize different cuisines of the world. Along the way, you’ll also learn about more advanced input 
# and output widgets, such as input validation, word clouds, and interactive maps.


# Add inputs
ui <- fluidPage(
  # CODE BELOW: Add a title
  titlePanel("UFO Sightings"),
  sidebarLayout(
    sidebarPanel(
      # CODE BELOW: One input to select a U.S. state
      # And one input to select a range of dates
      selectInput("state",
        "Choose a U.S. state:",
        choices = unique(usa_ufo_sightings$state)
      ),
      dateRangeInput("daterange",
        "Choose a date range:",
        start = "1920-01-01",
        end = "1950-01-01"
      )
    ),
  	mainPanel()
  )
)

server <- function(input, output) {

}

shinyApp(ui, server)
