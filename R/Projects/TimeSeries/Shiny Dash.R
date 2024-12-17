SHINY_DISPLAY <- function(){

    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP HEADER
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    header <- dashboardHeader(title = "ARIMAX Models")
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP SIDEBAR
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    sidebar <- dashboardSidebar(
      
                # Sidebar Menu Items
                sidebarMenu(
                  
                  # Menu Item No. 1
                  menuItem("Specifications", tabName = "specs", icon = icon("clipboard")),
                  
                  # Menu Item No. 2
                  menuItem("Dependent", tabName = "dependent", icon = icon("chart-line")),
                  
                  #Menu Item No. 3
                  menuItem("Explanatory Variables", tabName = "expl", icon = icon("pencil-ruler")),
                  
                  #Menu Item No. 4
                  menuItem("Models", tabName = "models", icon = icon("box-open")),
                  
                  #Menu Item No. 5
                  menuItem("Estimation Results", tabName = "est_results", icon = icon("poll")),
                  
                  #Menu Item No. 6
                  menuItem("Filtered Models", tabName = "filtered", icon = icon("filter")),
                  
                  #Menu Item No. 7
                  menuItem("Individual Model Forecast", tabName = "m_forecast", icon = icon("magic")),
                  
                  #Menu Item No. 8
                  menuItem("Bayesian Model Forecast", tabName = "bace_forecast", icon = icon("ruler"))
                  
                  
                )
    )
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP DASHBOARD
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    body <- dashboardBody(
      
              # Tab Items
              tabItems(
                
                # First Tab Content
                tabItem(tabName = "specs", 
                        
                        h1("ARIMAX Model Estimation Specifications"),
                        
                        h2("Information Regarding the User's Input Options"),
                        
                        h3("The ARIMAX models estimated in this procedure include three main components. 
                             The auto-regressive component(s), the moving average component(s) and the exogenous variables."),br(),
                        
                        fluidRow(box(title = "Model Specifications", width = 12, solidHeader = TRUE, status = "primary", collapsible = FALSE,
                          paste("The maximum number of auto-regressive terms permitted:", p),br(),
                          paste("The maximum number of auto-regressive terms permitted:", q),br(),
                          paste("The maximum number of auto-regressive terms permitted:", comb),
                          br(),br(),
                          paste("Total distinct number of models:", nrow(MODELS)),br())
                        ),
                        
                        h3("The procedure also requires the user to select two separate 'P-Values' used when conducting statistical
                           tests to identify the final candidate models. Firstly, models are excluded if any of the coefficients in 
                           the model have a p-value less than the chosen threshold. Secondly, models are excluded if the p-values from
                           the residual white-noise and normality tests are greater than the chosen threshold."),br(),
                        
                        fluidRow(box(title = "Statistical Test Specifications", width = 12, status = "primary", solidHeader = TRUE, collapsible = FALSE,
                          paste("The threshold for the coefficient statistical tests:", p_thres1),br(),
                          paste("The threshold for the residual statistical tests:", p_thres2),br()
                                    ),
                                 box(title = "Download CSV Output", width = 12, status = "primary", solidHeader = TRUE, collapsible = FALSE,
                                     downloadButton("download_xlsx", "Download")
                                     )
                        )
                ),
                
                # Second Tab Content
                tabItem(tabName = "dependent",
                        fluidRow(box(title="Plot of the Dependent Variable", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                      plotlyOutput("plot_dep")
                                  ),
                                  
                                  box(title="ACF Plot of the Dependent Variable", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                      plotOutput("plot_depacf")
                                  ),
                                  
                                  box(title="PACF Plot of the Dependent Variable", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                      plotOutput("plot_deppacf")
                                  )
                        )
                ),
                
                tabItem(tabName = "expl",
                        fluidRow(box(title="Controls", solidHeader = TRUE, status = "primary", collapsible = FALSE, height="480px", width=6,
                                    selectInput("expl_var", label = "Explanatory Variable", names(INDEPENDENT[,grepl("L0", colnames(INDEPENDENT))]),
                                                selected = names(INDEPENDENT[,1]), multiple = FALSE),br(),
                                    strong("Summary Statistics"),br(),br(),
                                    textOutput("max"), textOutput("min"), textOutput("mean"), textOutput("sd"), br(),
                                    "*Select the explanatory variable above to examine the historic time series and basic statisitics."
                                 ),
                                 box(title="Plot of the Selected Explanatory Variable", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                     height = "480px", width = 6,
                                     plotlyOutput("plot_expl")
                                 ),
                                 box(title="Correlation of the Explanatory Variables and Dependent", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                     plotOutput("plot_corr")
                                 ),
                                 box(title="Scenario(s) for Explanatory Variables", solidHeader = TRUE, status = "primary", collapsible = FALSE,
                                     plotlyOutput("expl_scen")
                                 )
                        )
                        
                ),
                
                tabItem(tabName = "models",
                        fluidRow(
                            box(title = "Models Pre-Estimation", solidHeader = TRUE, status = "primary", collapsible = FALSE, width = 12,
                                div(style = 'overflow-y: auto', dataTableOutput('est_models'))
                            )
                        )
                ),
                tabItem(tabName = "est_results",
                        fluidRow(
                          box(title = "Models Estimation Results", solidHeader = TRUE, status = "primary", collapsible = FALSE, width = 12,
                              div(style = 'overflow-y: auto', dataTableOutput('est_results'))
                          )
                        )
                ),
                tabItem(tabName = "filtered",
                        fluidRow(
                          box(title = "Summary of Filters", solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = TRUE,width = 4,
                              strong("Summary of Filter Results"), br(), br(),
                              div(style = 'overflow-y: auto', tableOutput("FILTER_S")), br(), 
                              strong(paste("A total of", nrow(FILTERED_MODELS), "models passed all the statistical tests out of",
                                           nrow(MODELS), "possible models.", sep = " "))
                              ),
                          box(title = "Number of Models Failing Each Test", solidHeader = TRUE, status = "primary", collapsible = TRUE, collapsed = TRUE, width= 8,
                              plotOutput("bc_filters")
                          ),
                          box(title = "Candidate Models (Models which passed all statistical tests)", solidHeader = TRUE, status = "primary", collapsible = TRUE, width = 12,
                              div(style = 'overflow-y: auto', dataTableOutput('cand_models'))
                          )
                        )
                ),
                tabItem(tabName = "m_forecast",
                        fluidRow(
                          box(title = "Individual Model Details", solidHeader = TRUE, status = "primary", collapsible = FALSE,width = 4,
                              height = "550px",
                              selectInput("ind_model", "Choose the Individual Model",
                                          choices = colnames(SCENARIO_FORECAST[,2:(ncol(SCENARIO_FORECAST)-2)]),
                                          selected = colnames(SCENARIO_FORECAST[,2])), br(),
                              div(style = 'overflow-y: auto', strong("Model Components:"),br(),br(),
                              tableOutput("model_vars"),
                              strong("Model Parameter Estimates:"), br(), br(),
                              tableOutput("model_pars"),
                              strong("Model Fit Measurements:"), br(), br(),
                              tableOutput("model_fit"))
                          ),
                          box(title = "Individual Model Forecast", solidHeader = TRUE, status = "primary", collapsible = FALSE, width = 8,
                              height = "550px", plotlyOutput("m_forecast", width = "100%")
                          )
                        )
                  
                ),
                tabItem(tabName = "bace_forecast",
                        fluidRow(
                          box(title = "Bayesian Model Parameters", solidHeader = TRUE, status = "primary", collapsible = FALSE, width = 4,
                              div(style = 'overflow-y: auto', tableOutput('bace_model'))
                          ),
                          box(title = "Bayesian Model Forecast", solidHeader = TRUE, status = "primary", collapsible = FALSE, width = 8,
                              plotlyOutput("bace_forecast")
                          ),
                          box(title = "Bayesian Model Parameters", solidHeader = TRUE, status = "primary", collapsible = TRUE, 
                              width = 8,collapsed = TRUE,
                              div(style = 'overflow-y: auto', dataTableOutput('bace_models'))
                          )
                        )
                        
                )
              )
    )
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # STEPS TO BE COMPLETED OUTSIDE THE SERVER 
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    CORR <- as.logical(grepl("L0", colnames(DEVELOPMENT)) + grepl("TARGET", colnames(DEVELOPMENT)))
    CORR <- round(cor(DEVELOPMENT[,CORR]),3)
    
    ARIMA_RESULTS <- DECIMALS(ARIMA_RESULTS, 5)
    FILTERED_MODELS <- DECIMALS(FILTERED_MODELS, 5)
    
    FILTER_S <- data.frame("Test"=colnames(FILTERS_SUMMARY), "Models Failed"=colSums(FILTERS_SUMMARY), row.names = NULL)
    FILTER_S$Test = factor(FILTER_S$Test, levels=FILTER_S[order(FILTER_S$Models.Failed, decreasing = TRUE),1])
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP SERVER
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    
    server <- function(input, output) {
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # SPECIFICATIONS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$download_xlsx <- downloadHandler(
        filename = function() {
          paste(input$t_xlsx_output, ".xlsx", sep = "")
        },
        content = function(file) {
          write.xlsx(t_xlsx_output, file, row.names = FALSE)
        }
      )
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # DEPENDENT TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      output$plot_dep <- renderPlotly({
        
        #plot(DEVELOPMENT$TARGET, type = "o", col="blue", lwd = 2, main="")
        
        ggplot(DEVELOPMENT, aes(x=index(DEVELOPMENT), y=DEVELOPMENT$TARGET)) +
          geom_line(color="blue", size = 1) +
          ylab("") +
          xlab("Date") 
        
        
      })
      
      output$plot_depacf <- renderPlot({
        
        Acf(DEVELOPMENT$TARGET, main= "", lag.max = 24)
        
      })
      
      output$plot_deppacf <- renderPlot({
        
        Pacf(DEVELOPMENT$TARGET, main= "", lag.max = 24)
        
      })
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # EXPLANATORY VARIABLES TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      EXPL <- reactive({
        
        EXPL <- droplevels(INDEPENDENT[which(INDEPENDENT$Var == input$expl_var)])
        
      })
      
      output$plot_expl <- renderPlotly({
        
        ggplot(INDEPENDENT, aes(x=index(INDEPENDENT), y=INDEPENDENT[, input$expl_var])) +
          geom_line(color="blue", size = 1) +
          ylab("") +
          xlab("Date") 
        
      })
      
      output$expl_scen <- renderPlotly({
        
        ggplot(SCENARIO_DATA, aes(x=SCENARIO_DATA$Date, y=SCENARIO_DATA[, input$expl_var], colour=Scenario), group=Scenario) +
          geom_line(size = 1) +
          labs("Scenario") + 
          ylab("") +
          xlab("Date") +
          theme(legend.position = "top")

      })
      
      output$max <- renderText({paste("Max Value:", round(max(DEVELOPMENT[, input$expl_var], na.rm=TRUE),4))})
      output$min <- renderText({paste("Min Value:", round(min(DEVELOPMENT[, input$expl_var], na.rm=TRUE),4))})
      output$mean <- renderText({paste("Mean Value:", round(mean(DEVELOPMENT[, input$expl_var], na.rm=TRUE),4))})
      output$sd <- renderText({paste("Std. Deviation", round(sd(DEVELOPMENT[, input$expl_var], na.rm=TRUE),4))})
    
      output$plot_corr <- renderPlot({
        
        corrplot(CORR, method = "square")
        
      })
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # MODELS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$est_models <- renderDataTable(MODELS, options=list(pageLength=20))
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # ESTIMATION RESULTS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$est_results <- renderDataTable(ARIMA_RESULTS, options=list(pageLength=15))
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # FILTERS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$FILTER_S <- renderTable(FILTER_S, rownames = TRUE, digits = 0)
      
      output$cand_models <- renderDataTable(FILTERED_MODELS, options=list(pageLength=15))
      
      output$bc_filters <- renderPlot({
        
        ggplot(FILTER_S, aes(x=FILTER_S$Test, y=FILTER_S$Models.Failed, fill=FILTER_S$Test))+
          geom_bar(stat = "identity", show.legend = FALSE) +
          geom_abline(slope=0, intercept=nrow(MODELS),  col = "red",lty=2, lwd=0.75)+
          xlab("") + 
          ylab("") +
          scale_fill_brewer(palette = "YlGnBu") +
          coord_flip()
        
      })
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # INDIVIDUAL MODEL FORECASTS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$model_vars <- renderTable(FILTERED_MODELS[FILTERED_MODELS$Index == as.numeric(gsub("MODEL.ID.", "", input$ind_model)), 2:6])
      output$model_pars <- renderTable( FILTERED_MODELS[FILTERED_MODELS$Index == as.numeric(gsub("MODEL.ID.", "", input$ind_model)), 
                                                        grepl("^EST", colnames(FILTERED_MODELS))])
      output$model_fit <- renderTable(FILTERED_MODELS[FILTERED_MODELS$Index == as.numeric(gsub("MODEL.ID.", "", input$ind_model)),
                                                      c("AIC", "SSE", "MSE")])

      
      output$m_forecast <- renderPlotly({
        
        ggplot(SCENARIO_FORECAST, aes(x=SCENARIO_FORECAST$Date, y=SCENARIO_FORECAST[, input$ind_model], colour=Scenario), group=Scenario) +
          geom_line(size = 1) +
          geom_line(aes(x=SCENARIO_FORECAST$Date, y=SCENARIO_FORECAST$TARGET), size = 1, colour="blue", lty = 3) +
          labs("Scenario") + 
          ylab("") +
          xlab("Date") +
          theme(legend.position = "top")
        
      })
      
      #-------------------------------------------------------------------------------------------------------------------------------#
      # BAYESIAN MODEL FORECASTS TAB
      #-------------------------------------------------------------------------------------------------------------------------------#
      
      output$bace_model <- renderTable(BAYESIAN_MODEL)
      
      output$bace_forecast <- renderPlotly({
        
        ggplot(BAYESIAN_FORECAST, aes(x=BAYESIAN_FORECAST$Date, y=BAYESIAN_FORECAST[, 1], colour=Scenario), group=Scenario) +
          geom_line(size = 1) +
          geom_line(aes(x=SCENARIO_FORECAST$Date, y=SCENARIO_FORECAST$TARGET), size = 1, colour="blue", lty = 3) +
          labs("Scenario") + 
          ylab("") +
          xlab("Date") +
          theme(legend.position = "top")
        
      })
      
      output$bace_models <- renderDataTable(FILTERED_MODELS[,c("Index", "k","SSE", "AIC", "Bayesian Probability")], options=list(pageLength=15))
      
    }

    #-------------------------------------------------------------------------------------------------------------------------------#
    # SETUP UI AND RUN SHINYAPP
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    ui <- dashboardPage(header, sidebar, body)
    OUTPUT <- shinyApp(ui, server)
    return(OUTPUT)
    
    #-------------------------------------------------------------------------------------------------------------------------------#
    # CLEANUP OF DATASETS
    #-------------------------------------------------------------------------------------------------------------------------------#
    
    rm(CORR, FILTER_S)


}


