# RShiny app testing with YAML file

# libraries
library(config)
library(shiny)
library(ggplot2)

# set work directory to folder for testing purposes
dir <- "input_dir"
setwd(dir)

# display current working directory
getwd()

# Configuration: find the config.yml file in the current directory
config <- config::get(file="config.yml")

# display information contained within the yml file
print(config$dataset)
print(config$n_rows_to_print)

# import the iris dataset
df <- read.csv(config$dataset)
head(df, config$n_rows_to_print)

# Extract the numeric column names
print(colnames(df[,sapply(df,is.numeric)]))
features <- colnames(df[,sapply(df,is.numeric)])

# Shiny app UI
ui <- fluidPage(
  headerPanel("Iris data"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "xcol", label = "X Axis Variable", choices = features, selected = features[1]),
      selectInput(inputId = "ycol", label = "Y Axis Variable", choices = features, selected = features[2])
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(df, aes(x=.data[[input$xcol]], y=.data[[input$ycol]])) +
      geom_point(size = 5, aes(color = class)) +
      theme(legend.position = "bottom")
  })
}

# Display Shiny app
shinyApp(ui, server)
