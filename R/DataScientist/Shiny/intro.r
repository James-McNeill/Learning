# Introduction to Shiny

# Hello World
library(shiny)

# fluidPage is a HTML file
ui <- fluidPage(
	# CODE BELOW: Add a text input "name"
	textInput("name", "Enter a name:")
)

# Back end functionality
server <- function(input, output) {
  
}

# Displaying the app details
shinyApp(ui = ui, server = server)

# Displaying text after user input
ui <- fluidPage(
	textInput("name", "What is your name?"),
	# CODE BELOW: Display the text output, greeting
    # Make sure to add a comma after textInput()
	textOutput("greeting")
)

# Show the output text message
server <- function(input, output) {
	# CODE BELOW: Render a text output, greeting
	output$greeting <- renderText({
		paste(
			"Hello, ", input$name
		)
	})
}

shinyApp(ui = ui, server = server)

# Adding input (UI)
ui <- fluidPage(
  # CODE BELOW: Add a text input "name"
  textInput('name', 'Enter your Name', 'David')
)
server <- function(input, output, session) {

}
shinyApp(ui = ui, server = server)

# Add output (UI/Server)
ui <- fluidPage(
  textInput('name', 'Enter Name', 'David'),
  # CODE BELOW: Display the plot output named 'trend'
  plotOutput('trend')
)
server <- function(input, output, session) {
  # CODE BELOW: Render an empty plot and assign to output named 'trend'
  output$trend <- renderPlot({
    ggplot()
  })
}
shinyApp(ui = ui, server = server)

# Update layout (UI)
ui <- fluidPage(
  titlePanel("Baby Name Explorer"),
  # CODE BELOW: Add a sidebarLayout, sidebarPanel, and mainPanel
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter Name', 'David')
    ),
    mainPanel(
      plotOutput('trend')
    )  
  )
)

server <- function(input, output, session) {
  output$trend <- renderPlot({
    ggplot()
  })
}
shinyApp(ui = ui, server = server)

# Update output (server)
ui <- fluidPage(
  titlePanel("Baby Name Explorer"),
  sidebarLayout(
    sidebarPanel(textInput('name', 'Enter Name', 'David')),
    mainPanel(plotOutput('trend'))
  )
)
server <- function(input, output, session) {
  output$trend <- renderPlot({
    # CODE BELOW: Update to display a line plot of the input name
    ggplot(subset(babynames, name == input$name)) +
      geom_line(aes(x = year, y = prop, color = sex))
  })
}
shinyApp(ui = ui, server = server)
