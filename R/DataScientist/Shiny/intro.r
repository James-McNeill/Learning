# Introduction to Shiny

# Hello World
library(shiny)

ui <- fluidPage(
	# CODE BELOW: Add a text input "name"
	textInput("name", "Enter a name:")
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
