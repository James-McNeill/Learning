#-------------------------------------------------------------------------------------------------------------------------------#
# INPUT OPTIONS
#-------------------------------------------------------------------------------------------------------------------------------#

fct_path <- ".../Functions"
data_path <- ".../ARIMAX Model Developer"
input_filename <- "Input.xlsx"
lags <- 4
comb <- 2
ind_logit <- "N"
ind_diff <- "Y"
ind_roc <- "Y"
p <- 1
q <- 1
Keep_Variables <- c("RPPI_Y","UE_R","NOB_D","EARN_Y","IR_R","ISEQ_Y","CPI_D","GDP_Y")
p_thres1 <- 0.05
p_thres2 <- 0.05
display_dashboard <- "Y"
export_excel <- "N"
output_file <- ".../TESTING.xlsx"


#-------------------------------------------------------------------------------------------------------------------------------#
# CHECK REQUIRED PACKAGES ARE INSTALLED AND INSTALL IF NOT  
#-------------------------------------------------------------------------------------------------------------------------------#

packages <- c("zoo", "xts","astsa","forecast","corrplot", "reshape", 
              "plyr", "shinydashboard", "shiny", "DT", "plotly", "openxlsx",
              "tidyverse")

for (x in packages){
  if(x %in% rownames(installed.packages()) == FALSE){
    install.packages(x)
  }
}

#-------------------------------------------------------------------------------------------------------------------------------#
# LIBRARIES AND PACKAGES REQUIRED FOR THE ENTIRE PROCESS ARE CALLED IN THIS SECTION
#-------------------------------------------------------------------------------------------------------------------------------#

library(zoo)
library(xts)
library(astsa)
library(forecast)
library(corrplot)
library(reshape)
library(plyr)

#-------------------------------------------------------------------------------------------------------------------------------#
# SHINY & SHINYDASHBOARD PACKAGES
#-------------------------------------------------------------------------------------------------------------------------------#

library(shinydashboard)
library(shiny)
library(DT)
library(plotly)
library(openxlsx)
library(tidyverse)

#-------------------------------------------------------------------------------------------------------------------------------#
# SPECIFY THE FILEPATH OF YOUR WORKING DIRECTORY
#-------------------------------------------------------------------------------------------------------------------------------#

setwd(fct_path)
dir()

#-------------------------------------------------------------------------------------------------------------------------------#
# SOURCE ALL FUNCTIONS WHICH ARE PART OF THE ARIMAX DEVELOPMENT PROCESS
#-------------------------------------------------------------------------------------------------------------------------------#

source("Transformations.R")
source("Keep Variables.R")
source("Model Combinations.R")
source("Model Estimation.R")
source("Filters.R")
source("Forecasting.R")
source("Decimals.R")
source("Shiny Dash.R")

#-------------------------------------------------------------------------------------------------------------------------------#
# READ IN THE DEPENDENT DATA FROM A SPECIFIC FOLDER AND FILE
#-------------------------------------------------------------------------------------------------------------------------------#

setwd(data_path)
dir()

library(readxl)
DEPENDENT <- read_excel(input_filename, sheet="DEPENDENT", col_types = c("date", "numeric"))
str(DEPENDENT)

#-------------------------------------------------------------------------------------------------------------------------------#
# CONVERT THE DEPENDENT DATASET TO A TIME SERIES OBJECT
#-------------------------------------------------------------------------------------------------------------------------------#

DEPENDENT <- xts(DEPENDENT$PD, order.by = DEPENDENT$DATE)
colnames(DEPENDENT) <- c("TARGET")

#-------------------------------------------------------------------------------------------------------------------------------#
# PLOT THE TIME SERIES OF THE DEPENDENT VARIABLE
#-------------------------------------------------------------------------------------------------------------------------------#

plot(DEPENDENT)
acf(DEPENDENT)
pacf(DEPENDENT)

#-------------------------------------------------------------------------------------------------------------------------------#
# READ IN THE INDEPENDENT DATA
#-------------------------------------------------------------------------------------------------------------------------------#

INDEPENDENT <- read_excel(input_filename, sheet = "HISTORIC") 

#-------------------------------------------------------------------------------------------------------------------------------#
# CONVERT THE INDEPENDENT DATA TO A TIME SERIES OBJECT
#-------------------------------------------------------------------------------------------------------------------------------#

INDEPENDENT <- xts(INDEPENDENT[,2:ncol(INDEPENDENT)], order.by = INDEPENDENT$DATE)

#-------------------------------------------------------------------------------------------------------------------------------#
# APPLY TRANSFORMATIONS TO THE INDEPENDENT VARIABLES
#-------------------------------------------------------------------------------------------------------------------------------#

INDEPENDENT <- TRANSFORMATIONS(INDEPENDENT,ind_logit,ind_diff,ind_roc)

#-------------------------------------------------------------------------------------------------------------------------------#
# APPLY LAGS TO THE INDEPENDENT VARIABLES
#-------------------------------------------------------------------------------------------------------------------------------#

INDEPENDENT <- LAGS(INDEPENDENT, lags)

#-------------------------------------------------------------------------------------------------------------------------------#
# ADD FUNCTION TO DROP ANY UNWANTED VARIABLES OR TO KEEP ONLY SELECT VARIABLES
#-------------------------------------------------------------------------------------------------------------------------------#

if(length(Keep_Variables) > 0){
  
  INDEPENDENT <- KEEP(INDEPENDENT, Keep_Variables)
  
}

#-------------------------------------------------------------------------------------------------------------------------------#
# MODEL COMBINATIONS FUNCTION WHICH COMBINES ALL DISTINCT EXOGENOUS VARIABLES
#-------------------------------------------------------------------------------------------------------------------------------#

MODELS <- MODEL_COMBINATIONS(INDEPENDENT, comb)

#-------------------------------------------------------------------------------------------------------------------------------#
# MODEL EXCLUSIONS FUNCTION WHICH REMOVES COMBINATION WICH HAVE THE SAME VARIABLE
#-------------------------------------------------------------------------------------------------------------------------------#

MODELS <- MODEL_EXCLUSIONS(MODELS, comb)

#-------------------------------------------------------------------------------------------------------------------------------#
# MODEL ARMA FUNCTION WHICH CREATES DISTINCT MODELS WITH DIFFERING ENDOGENOUS PARMAETERS
#-------------------------------------------------------------------------------------------------------------------------------#

MODELS <- MODEL_ARMA(MODELS, p, q)

#-------------------------------------------------------------------------------------------------------------------------------#
# JOIN THE INDEPENDENT AND DEPENDENT DATA TO CREATE THE DEVELOPMENT DATASET (ADD CORRELATION ANALYSIS...)
#-------------------------------------------------------------------------------------------------------------------------------#

DEVELOPMENT <- na.omit(merge.xts(DEPENDENT, INDEPENDENT, all=FALSE, join = "left"))
TARGET <- DEVELOPMENT$TARGET

#-------------------------------------------------------------------------------------------------------------------------------#
# BEGIN THE MODEL ESTIMATION PROCEDURE LOOP
#-------------------------------------------------------------------------------------------------------------------------------#

ARIMA_RESULTS <- ARIMA_MODEL_ESTIMATION(MODELS, TARGET)

#-------------------------------------------------------------------------------------------------------------------------------#
# TEMPORARILY CREATE SIGNS TABLE (IN FUTURE MAKE THIS PART OF THE EXCEL)
#-------------------------------------------------------------------------------------------------------------------------------#

VARIABLE_SIGNS <- read_excel(input_filename, sheet = "SIGNS")

#-------------------------------------------------------------------------------------------------------------------------------#
# MODEL RESULTS FILTER FUNCTION
#-------------------------------------------------------------------------------------------------------------------------------#

TEMP <- FILTERS(ARIMA_RESULTS, p_thres1, p_thres2)
FILTERED_MODELS <- TEMP$OUTPUT
FILTERS_SUMMARY <- TEMP$SUMMARY
rm(TEMP)

#-------------------------------------------------------------------------------------------------------------------------------#
# READ IN SCENARIOS AND APPLY SAME TRANSFORMATIONS AND CONDUCT FORECASTING
#-------------------------------------------------------------------------------------------------------------------------------#

SCENARIOS_N <- length(excel_sheets(input_filename))
rm(SCENARIO_DATA, SCENARIO_FORECAST, BAYESIAN_FORECAST, BAYESIAN_MODEL)

for(S in 1:SCENARIOS_N){
  
  SCENARIOS <- excel_sheets(input_filename)
  
  SCENARIO <- SCENARIOS[S]
  
  if(SCENARIO != "HISTORIC" & SCENARIO != "SIGNS" & SCENARIO != "DEPENDENT"){
    
    TEMP <- read_excel(input_filename, sheet = SCENARIO)
    TEMP <- xts(TEMP[,2:ncol(TEMP)], order.by = TEMP$DATE)
    TEMP <- TRANSFORMATIONS(TEMP, "N", "Y", "Y")
    TEMP <- LAGS(TEMP, 4)
    
    TEMP_FC <- FORECASTING(FILTERED_MODELS, DEVELOPMENT, TEMP)
    
    TEMP_FORECAST <- data.frame(TEMP_FC$MODEL_FORECAST)
    TEMP_BAYESIAN <- TEMP_FC$BAYESIAN_FORECAST
    TEMP <- data.frame(TEMP)
    
    TEMP$Scenario <- as.character(SCENARIO)
    TEMP_FORECAST$Scenario <- as.character(SCENARIO)
    TEMP_BAYESIAN$Scenario <- as.character(SCENARIO)
    
    TEMP$Date <- as.Date(row.names(TEMP))
    TEMP_FORECAST$Date <- as.Date(row.names(TEMP_FORECAST))
    TEMP_BAYESIAN$Date <- as.Date(row.names(TEMP_BAYESIAN))
    
    row.names(TEMP) <- NULL
    row.names(TEMP_FORECAST) <- NULL
    row.names(TEMP_BAYESIAN) <- NULL
    
    if(exists('SCENARIO_DATA') == FALSE){
      
      SCENARIO_DATA <- TEMP
      
    }
    else { 
      
      SCENARIO_DATA <- rbind(SCENARIO_DATA, TEMP)
      
    }
    
    if(exists('SCENARIO_FORECAST') == FALSE){
      
      SCENARIO_FORECAST <- TEMP_FORECAST
      
    }
    else { 
      
      SCENARIO_FORECAST <- rbind(SCENARIO_FORECAST, TEMP_FORECAST)
      
    }
    
    if(exists("BAYESIAN_MODEL") == FALSE){
      
      BAYESIAN_MODEL <- TEMP_FC$BAYESIAN_MODEL
      
    }
    
    if(exists("BAYESIAN_FORECAST") == FALSE){
      
      BAYESIAN_FORECAST <- TEMP_BAYESIAN
      
    }
    else{
      
      BAYESIAN_FORECAST <- rbind(BAYESIAN_FORECAST, TEMP_BAYESIAN)
      
    }
    
  }
}

#-------------------------------------------------------------------------------------------------------------------------------#
# CLEAN UP WORKSPACE AND REMOVE TEMPORARY DATASETS
#-------------------------------------------------------------------------------------------------------------------------------#

rm(TEMP, TEMP_FORECAST, TEMP_BAYESIAN, x, SCENARIO, SCENARIOS, SCENARIOS_N, S)


#-------------------------------------------------------------------------------------------------------------------------------#
# FORMAT OUTPUT FOR EXCEL 
#-------------------------------------------------------------------------------------------------------------------------------#

t_xlsx_output <- list("DEVELOPEMENT" = DEVELOPMENT,
                      "SCENARIOS" = SCENARIO_DATA,
                      "MODELS" = MODELS,
                      "ESTIMATION_RESULTS" = ARIMA_RESULTS,
                      "FILTERED MODELS" = FILTERED_MODELS,
                      "IND_FORECAST" = SCENARIO_FORECAST,
                      "BAYESIAN_MODEL" = BAYESIAN_MODEL,
                      "BAYESIAN_FORECAST" = BAYESIAN_FORECAST
)

#-------------------------------------------------------------------------------------------------------------------------------#
# OUTPUT EXCEL FILE
#-------------------------------------------------------------------------------------------------------------------------------#

if(export_excel == "Y"){
  
  write.xlsx(t_xlsx_output, output_file, row.names = FALSE)
  
}

#-------------------------------------------------------------------------------------------------------------------------------#
# SHINY DASHBOARD FOR PRESENTING RESULTS
#-------------------------------------------------------------------------------------------------------------------------------#

if(display_dashboard == "Y"){
  
  SHINY_DISPLAY()  
  
}
