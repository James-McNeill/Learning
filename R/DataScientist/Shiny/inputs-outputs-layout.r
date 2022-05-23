# Inputs, outputs and Layouts
# How to take advantage of different input and output options in shiny. You'll learn the syntax for taking inputs from users and 
# rendering different kinds of outputs, including text, plots, and tables.

# Inputs
# Selecting an input
# Shiny provides a wide variety of inputs that allows users to provide
# 1. text (textInput, selectInput), 
# 2. numbers (numericInput, sliderInput), 
# 3. booleans (checkBoxInput, radioInput), and 
# 4. dates (dateInput, dateRangeInput).

# Add a selectInput
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # CODE BELOW: Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select sex', selected = 'F', choices = c('M', 'F')),
  # Add plot output to display top 10 most popular names
  plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
  # Render plot of top 10 most popular names
  output$plot_top_10_names <- renderPlot({
    # Get top 10 names by sex and year
    top_10_names <- babynames %>% 
      # MODIFY CODE BELOW: Filter for the selected sex
      filter(sex == input$sex) %>% 
      filter(year == 1900) %>% 
      top_n(10, prop)
    # Plot top 10 names by sex and year
    ggplot(top_10_names, aes(x = name, y = prop)) +
      geom_col(fill = "#263e63")
  })
}

shinyApp(ui = ui, server = server)

# Adding a slider input to select year
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  # CODE BELOW: Add slider input named 'year' to select years  (1900 - 2010)
  sliderInput('year', 'Select years', value = 1900, min = 1900, max = 2010),
  # Add plot output to display top 10 most popular names
  plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
  # Render plot of top 10 most popular names
  output$plot_top_10_names <- renderPlot({
    # Get top 10 names by sex and year
    top_10_names <- babynames %>% 
      filter(sex == input$sex) %>% 
    # MODIFY CODE BELOW: Filter for the selected year
      filter(year == input$year) %>% 
      top_n(10, prop)
    # Plot top 10 names by sex and year
      ggplot(top_10_names, aes(x = name, y = prop)) +
        geom_col(fill = "#263e63")
  })
}

shinyApp(ui = ui, server = server)
