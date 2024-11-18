# Add additional features to the shiny app - still a work in progress
# Load the required packages
library(shiny)
library(ggplot2)

# Define the UI
ui <- fluidPage(
  titlePanel("Gantt Chart"),
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        "source", 
        label = "Data Source",
        choices = c("Upload CSV File", "Use Default Table"), 
        selected = "Use Default Table"
      ),
      conditionalPanel(
        condition = "input.source == 'upload'",
        fileInput("tasks_file", "Choose CSV File")
      )
    ),
    mainPanel(
      plotOutput("gantt")
    )
  )
)

# Define the server
server <- function(input, output) {
  # Define a reactive value for the tasks data frame
  tasks <- reactive({
    if (input$source == "upload" && !is.null(input$tasks_file)) {
      # Read the CSV file and return the data frame
      read.csv(input$tasks_file$datapath, stringsAsFactors = FALSE)
    } else {
      # If no file is uploaded or "Use Default Table" is selected, use a default data frame
      data.frame(
        Task = c("Task 1", "Task 2", "Task 3", "Task 4", "Task 5"),
        Start = c(as.Date("2023-04-01"), as.Date("2023-04-05"), as.Date("2023-04-08"), as.Date("2023-04-11"), as.Date("2023-04-15")),
        End = c(as.Date("2023-04-04"), as.Date("2023-04-10"), as.Date("2023-04-14"), as.Date("2023-04-16"), as.Date("2023-04-20")),
        User = c("User A", "User B", "User A", "User C", "User B")
      )
    }
  })
  
  output$gantt <- renderPlot({
    # Create the Gantt chart based on the selected option
    if (input$source == "upload") {
      ggplot(tasks(), aes(x = Start, xend=End, y = Task, yend=Task, color = User)) +
        geom_segment(size=8) +
        labs(x = "Date", y = "Task", title = "Gantt Chart") +
        # scale_x_date(date_breaks = "1 day", date_labels = "%b %d") +
        theme_minimal()
    } else {
      ggplot(tasks(), aes(x = Start, xend=End, y = Task, yend=Task, color = User)) +
        geom_segment(size=8) +
        labs(x = "Date", y = "Task", title = "Gantt Chart") +
        # scale_x_date(date_breaks = "1 day", date_labels = "%b %d") +
        theme_minimal()
    }
  })
  
  # Define an API to allow for different managers to add additional data
  observe({
    if (input$source == "upload" && !is.null(input$tasks_file)) {
      # Save the uploaded file to a directory
      file.copy(input$tasks_file$datapath, paste0("./data/", input$tasks_file$name))
    }
  })
}

# Run the app
shinyApp(ui = ui, server = server)
