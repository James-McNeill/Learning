# R Shiny app
# Number of tasks to produce minimum viable product (MVP)
# 1. Create N tabs that have different information
# 2. Include tab that contains the input data to allow user to review
# 3. Export file to excel or pdf file format
# 4. Add an EDA Rmarkdown file to produce summary outputs

# Notes
# 1. Download buttons are not working correctly

# Load required libraries
library(shiny)
# library(tidyverse)
# library(readr)
library(DT)
# library(data.table)
library(ggplot2)
library(rmarkdown)

# Define UI
ui <- fluidPage(
  titlePanel("Data Exploration"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV file"),
      # br(),
      # radioButtons("sep", "Separator", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"), selected = ","),
      # br(),
      # downloadButton("download_report", "Download EDA Report as PDF")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Input Dataset", DT::dataTableOutput("data_table")),
        tabPanel("Summary", verbatimTextOutput("summary_output")),
        tabPanel("Missing Values", plotOutput("missing_values_plot")),
        tabPanel("EDA Report", includeHTML("eda_report.html"))
      )
    )
  )
)

# Define server
server <- function(input, output) {
  # Read CSV file
  dataset <- reactive({
    req(input$file)
    read_csv(input$file$datapath, col_names = TRUE)
  })
  
  # Render DataTable
  output$data_table <- DT::renderDataTable({
    dataset()
  })
  
  # Show summary of the dataset
  output$summary_output <- renderPrint({
    summary(dataset())
  })
  
  # Create plot for missing values
  output$missing_values_plot <- renderPlot({
    missing_data <- colSums(is.na(dataset()))
    barplot(missing_data, main = "Missing Values per Column",
            xlab = "Columns", ylab = "Missing Values")
  })
  
  # Render EDA Report
  output$render_report <- render({
    rmarkdown::render("eda_report.Rmd", output_file = "eda_report.html")
  })

  # Download EDA Report as PDF
  # output$download_report <- downloadHandler(
  #   filename = function() {
  #     "eda_report.pdf"
  #   },
  #   content = function(file) {
  #     rmarkdown::render("eda_report.Rmd", output_file = file)
  #   }
  # )
  
}

# Run the application
shinyApp(ui = ui, server = server)
