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

# Add outputs
server <- function(input, output) {
  # CODE BELOW: Create a plot output name 'shapes', of sightings by shape,
  # For the selected inputs
  output$shapes <- renderPlot({
    usa_ufo_sightings %>%
      filter(state == input$state,
             date_sighted >= input$dates[1],
             date_sighted <= input$dates[2]) %>%
      ggplot(aes(shape)) +
      geom_bar() +
      labs(x = "Shape", y = "# Sighted")
  })
  # CODE BELOW: Create a table output named 'duration_table', by shape, 
  # of # sighted, plus mean, median, max, and min duration of sightings
  # for the selected inputs
  output$duration_table <- renderTable({
    usa_ufo_sightings %>%
      filter(
        state == input$state,
        date_sighted >= input$dates[1],
        date_sighted <= input$dates[2]
      ) %>%
      group_by(shape) %>%
      summarize(
        nb_sighted = n(),
        avg_duration = mean(duration_sec),
        median_duration = median(duration_sec),
        min_duration = min(duration_sec),
        max_duration = max(duration_sec)
      )
  })
}

ui <- fluidPage(
  titlePanel("UFO Sightings"),
  sidebarLayout(
    sidebarPanel(
      selectInput("state", "Choose a U.S. state:", choices = unique(usa_ufo_sightings$state)),
      dateRangeInput("dates", "Choose a date range:",
                     start = "1920-01-01",
                     end = "1950-01-01")
    ),
    mainPanel(
      # Add plot output named 'shapes'
      plotOutput("shapes"),
      # Add table output named 'duration_table'
      tableOutput("duration_table")
    )
  )
)

shinyApp(ui, server)

# Tab layout
ui <- fluidPage(
  titlePanel("UFO Sightings"),
  sidebarPanel(
    selectInput("state", "Choose a U.S. state:", choices = unique(usa_ufo_sightings$state)),
    dateRangeInput("dates", "Choose a date range:",
      start = "1920-01-01",
      end = "1950-01-01"
    )
  ),
  # MODIFY CODE BELOW: Create a tab layout for the dashboard
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("shapes")),
      tabPanel("Table", tableOutput("duration_table"))
    )
  )
)

server <- function(input, output) {
  output$shapes <- renderPlot({
    usa_ufo_sightings %>%
      filter(
        state == input$state,
        date_sighted >= input$dates[1],
        date_sighted <= input$dates[2]
      ) %>%
      ggplot(aes(shape)) +
      geom_bar() +
      labs(
        x = "Shape",
        y = "# Sighted"
      )
  })

  output$duration_table <- renderTable({
    usa_ufo_sightings %>%
      filter(
        state == input$state,
        date_sighted >= input$dates[1],
        date_sighted <= input$dates[2]
      ) %>%
      group_by(shape) %>%
      summarize(
        nb_sighted = n(),
        avg_duration_min = mean(duration_sec) / 60,
        median_duration_min = median(duration_sec) / 60,
        min_duration_min = min(duration_sec) / 60,
        max_duration_min = max(duration_sec) / 60
      )
  })
}

shinyApp(ui, server)
