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

# Outputs
# Add a table output
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # CODE BELOW: Add table output named "table_top_10_names"
  tableOutput('table_top_10_names')
)
server <- function(input, output, session){
  # Function to create a data frame of top 10 names by sex and year 
  top_10_names <- function(){
    top_10_names <- babynames %>% 
      filter(sex == input$sex) %>% 
      filter(year == input$year) %>% 
      top_n(10, prop)
  }
  # CODE BELOW: Render a table output named "table_top_10_names"
  output$table_top_10_names <- renderTable(
    top_10_names()
  )
}
shinyApp(ui = ui, server = server)

# Add an interactive table output
# There are multiple htmlwidgets packages like DT, leaflet, plotly, etc. that provide highly interactive outputs and can be 
# easily integrated into Shiny apps using almost the same pattern. For example, you can turn a static table in a Shiny app into 
# an interactive table using the DT package:

# Create an interactive table using, DT::datatable().
# Render it using, DT::renderDT().
# Display it using, DT::DTOutput().

# Add an interactive table output
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("M", "F")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # MODIFY CODE BELOW: Add a DT output named "table_top_10_names"
  DT::DTOutput('table_top_10_names')
)
server <- function(input, output, session){
  top_10_names <- function(){
    babynames %>% 
      filter(sex == input$sex) %>% 
      filter(year == input$year) %>% 
      top_n(10, prop)
  }
  # MODIFY CODE BELOW: Render a DT output named "table_top_10_names"
  output$table_top_10_names <- DT::renderDT({
    DT::datatable(top_10_names())
  })
}
shinyApp(ui = ui, server = server)

# Add interactive plot output
ui <- fluidPage(
  selectInput('name', 'Select Name', top_trendy_names$name),
  # CODE BELOW: Add a plotly output named 'plot_trendy_names'
  plotly::plotlyOutput('plot_trendy_names')
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
     babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  # CODE BELOW: Render a plotly output named 'plot_trendy_names'
  output$plot_trendy_names <- plotly::renderPlotly(
    {
      plot_trends()
    }
  )
}
shinyApp(ui = ui, server = server)

# Layouts and themes
# Sidebar layouts
ui <- fluidPage(
  # MODIFY CODE BELOW: Wrap in a sidebarLayout
  sidebarLayout(
    # MODIFY CODE BELOW: Wrap in a sidebarPanel
    sidebarPanel(
    selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    # MODIFY CODE BELOW: Wrap in a mainPanel
    mainPanel(
    plotly::plotlyOutput('plot_trendy_names'),
    DT::DTOutput('table_trendy_names')
    )
  )
)
# DO NOT MODIFY
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
     babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Tab layouts
# Displaying several tables and plots on the same page can lead to visual clutter and distract users of the app. In such cases, 
# the tab layout comes in handy, as it allows different outputs to be displayed as tabs.
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    mainPanel(
      # MODIFY CODE BLOCK BELOW: Wrap in a tabsetPanel
      tabsetPanel(
        # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
        tabPanel(
          'Plot', plotly::plotlyOutput('plot_trendy_names')
        ),
        # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
        tabPanel(
          'Table', DT::DTOutput('table_trendy_names')
        )
      )
    )
  )
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
     babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Themes
ui <- fluidPage(
  # CODE BELOW: Add a titlePanel with an appropriate title
  titlePanel('Babynames trend over time'),
  # REPLACE CODE BELOW: with theme = shinythemes::shinytheme("<your theme>")
  # shinythemes::themeSelector(), # this option provides a drop down menu of different theme options
  theme = shinythemes::shinytheme('superhero'),
  sidebarLayout(
    sidebarPanel(
      selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Plot', plotly::plotlyOutput('plot_trendy_names')),
        tabPanel('Table', DT::DTOutput('table_trendy_names'))
      )
    )
  )
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
     babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Building apps
# App1: Multilingual Greeting
ui <- fluidPage(
    selectInput('greeting', 'Select greeting', selected = 'Hello', choices = c('Hello', 'Bonjour')),
    textInput('name', 'Enter your name', 'Kaelen'),
    textOutput('text')
)

server <- function(input, output, session) {
  output$text <- renderText(
      {
        paste(
            input$greeting, ", ", input$name
        )
      }
  )
}

shinyApp(ui = ui, server = server)

# App2: Popular Baby Names
ui <- fluidPage(
  titlePanel("Most Popular Names"),
  sidebarLayout(
    sidebarPanel(
      selectInput('sex', 'Select Sex', c("M", "F")),
      sliderInput('year', 'Select Year', min = 1880, max = 2017, value = 1900)
    ),
    mainPanel(
     plotOutput('plot')
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    top_names_by_sex_year <- get_top_names(input$year, input$sex) 
    ggplot(top_names_by_sex_year, aes(x = name, y = prop)) +
      geom_col()
  })
}

shinyApp(ui = ui, server = server)

# App3: Popular Baby Names Redux
# MODIFY this app (built in the previous exercise)
ui <- fluidPage(
  titlePanel("Most Popular Names"),
  sidebarLayout(
    sidebarPanel(
      selectInput('sex', 'Select Sex', c("M", "F")),
      sliderInput('year', 'Select Year', min = 1880, max = 2017, value = 1900)
    ),
    mainPanel(
      tabsetPanel(  
        tabPanel('Plot', plotOutput('plot')),
        tabPanel('Table', tableOutput('table'))
      )
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    top_names_by_sex_year <- get_top_names(input$year, input$sex) 
    ggplot(top_names_by_sex_year, aes(x = name, y = prop)) +
      geom_col()
  })
  output$table <- renderTable(
    {
      get_top_names(input$year, input$sex)
    }
  )
}

shinyApp(ui = ui, server = server)
