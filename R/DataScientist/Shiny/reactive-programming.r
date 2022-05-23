# Reactive Programming

# Reactivity 101
# One of the central tenets of reactivity is that reactive expressions are executed lazily, and their values are cached.
server <- function(input, output, session) {
  # CODE BELOW: Add a reactive expression rval_bmi to calculate BMI. Means that the expression only needs to be processed once each time
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
    bmi <- rval_bmi()
    paste("Your BMI is", round(bmi, 1))
  })
  output$bmi_range <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
    bmi <- rval_bmi()
    bmi_status <- cut(bmi, 
      breaks = c(0, 18.5, 24.9, 29.9, 40),
      labels = c('underweight', 'healthy', 'overweight', 'obese')
    )
    paste("You are", bmi_status)
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi"),
      textOutput("bmi_range")
    )
  )
)

shinyApp(ui = ui, server = server)

# Observers vs. reactives
# Add another reactive expression
server <- function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  # CODE BELOW: Add a reactive expression rval_bmi_status to 
  # return health status as underweight etc. based on inputs
  rval_bmi_status <- reactive({
    cut(rval_bmi(), 
      breaks = c(0, 18.5, 24.9, 29.9, 40),
      labels = c('underweight', 'healthy', 'overweight', 'obese')
    )
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Your BMI is", round(bmi, 1))
  })
  output$bmi_status <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with 
    # reactive expression rval_bmi_status
    bmi_status <- rval_bmi_status()
    paste("You are", bmi_status)
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi"),
      textOutput("bmi_status")
    )
  )
)

shinyApp(ui = ui, server = server)

# Add an observer to display notifications
ui <- fluidPage(
  textInput('name', 'Enter your name')
)

server <- function(input, output, session) {
  # CODE BELOW: Add an observer to display a notification
  # 'You have entered the name xxxx' where xxxx is the name
  observe({
    showNotification(
      paste("You have entered the name ", input$name)
    )
  })
}

shinyApp(ui = ui, server = server)

# Stop reactions with isolate()
server <- function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    # MODIFY CODE BELOW: 
    # Use isolate to stop output from updating when name changes.
    paste("Hi", isolate(input$name), ". Your BMI is", round(bmi, 1))
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height (in m)', 1.5, 1, 2, step = 0.1),
      numericInput('weight', 'Enter your weight (in Kg)', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)

# Delay reactions with eventReactive()
server <- function(input, output, session) {
  # MODIFY CODE BELOW: Use eventReactive to delay the execution of the
  # calculation until the user clicks on the show_bmi button (Show BMI)
  rval_bmi <- eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter height (in m)', 1.5, 1, 2, step = 0.1),
      numericInput('weight', 'Enter weight (in Kg)', 60, 45, 120),
      actionButton("show_bmi", "Show BMI")
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)


shinyApp(ui = ui, server = server)

# Trigger reactions with observeEvent()
server <- function(input, output, session) {
  # MODIFY CODE BELOW: Wrap in observeEvent() so the help text 
  # is displayed when a user clicks on the Help button.
  observeEvent(input$show_help, {
     # Display a modal dialog with bmi_help_text
     # MODIFY CODE BELOW: Uncomment code
     showModal(modalDialog(bmi_help_text)) # bmi_help_text: string variable with text for display
  })
  rv_bmi <- eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rv_bmi()
    paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
  })
}

ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120),
      actionButton("show_bmi", "Show BMI"),
      # CODE BELOW: Add an action button named "show_help"
      actionButton("show_help", "Help")
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)
