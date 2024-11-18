# Simple R Shiny app that includes python code

# Libraries
library(shiny)
library(reticulate)

# Build the ui
ui <- fluidPage({
  titlePanel("CSV Viewer")
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File"),
      actionButton("loadBtn", "Load CSV")
    ),
    mainPanel(
      tableOutput("table")
    )
  )
})

# Server
server <- function(input, output) {
  observeEvent(input$loadBtn, {
    inFile <- input$file
    if (!is.null(inFile)) {
      py_run_file("read_csv.py")
      data <- py$load_csv(inFile$datapath)
      output$table <- renderTable(data)
    }
  }) 
}

# Run shiny app
shinyApp(ui = ui, server = server)
