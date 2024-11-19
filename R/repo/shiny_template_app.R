# R Shiny app
# Number of tasks to produce minimum viable product (MVP)
# 1. Create N tabs that have different information
# 2. Include tab that contains the input data to allow user to review
# 3. Export file to excel or pdf file format

# Load required libraries
library(shiny)
library(shinydashboard)
library(scales)

# Create the UI
ui <- dashboardPage(
  dashboardHeader(title = "Data Exploration"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data", tabName = "data_tab"),
      menuItem("Summary", tabName = "summary_tab"),
      menuItem("Report", tabName = "report_tab")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "data_tab",
              fileInput("file", "Upload CSV file"),
               fluidRow(column(6, verbatimTextOutput("data_summary"))),
               fluidRow(column(12, dataTableOutput("data_table")))
               ),
      tabItem(tabName = "summary_tab", 
              verbatimTextOutput("summary_output")
              ),
      tabItem(tabName = "report_tab",
              actionButton("generate_btn", "Generate Report"),
              uiOutput("excel_report"))
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
  output$summary_output <- renderText({
    output <- capture.output({
      summary(data())
      str(data())
      column_types <- sapply(data(), typeof)
      print(column_types)
    })
    paste(output, collapse = "\n")
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
  
  # Excel report
  observeEvent(input$generate_btn, {
    output_file <- "excel_report.html"
    params <- list(
      title = "My Report",
      subtitle = "Generated using R Markdown",
      date = Sys.Date(),
      dataset = data()
    )
    rmarkdown::render("excel_report.Rmd", output_file = output_file, params = params)
    output$excel_report <- renderUI({
      includeHTML(output_file)
    })
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
