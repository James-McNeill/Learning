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
