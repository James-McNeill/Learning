# R Shiny app
# Number of tasks to produce minimum viable product (MVP)
# 1. Create N tabs that have different information
# 2. Include tab that contains the input data to allow user to review
# 3. Export file to excel or pdf file format

# Load required libraries
library(shiny)
library(scales)

# Create the UI
ui <- fluidPage(
  titlePanel("Data Exploration"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data", 
                 fluidRow(column(6, verbatimTextOutput("data_summary"))),
                 fluidRow(column(12, dataTableOutput("data_table")))
                 ),
        tabPanel("Summary", verbatimTextOutput("summary_output")),
      )
    )
  )
)

# Server details for app
server <- function(input, output) {
  # Import the CSV file
  data <- reactive({
    file <- input$file
    if (is.null(file))
      return(NULL)
    read.csv(file$datapath, stringsAsFactors = FALSE)
  })
  
  # Render the data table
  output$data_table <- renderDataTable({
    data()
  })
  
  # Render the summary details
  output$summary_output <- renderPrint({
    str(data())
    summary(data())
  })
  
  # Display memory usage
  observeEvent(data(), {
    mem_size <- object.size(data()) / 1024^2 # Convert to megabytes
    mem_percent <- round((mem_size / memory.limit()) * 100, 2)
    mem_size_formatted <- format(mem_size, big.mark = ",")
    output$data_summary <- renderText({
      paste("Number of Rows:", nrow(data()), " | Number of Columns: ", ncol(data()), 
            " | Memory Usage: ", mem_size_formatted, " MB", " | Memory Limit: ", memory.limit(), " MB",
            " | Memory Usage pct: ", mem_percent, "%")
    })
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
