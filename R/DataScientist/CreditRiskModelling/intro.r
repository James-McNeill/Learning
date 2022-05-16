# Credit Risk Modelling

# Introduction and data structure

# View the structure of loan_data
str(loan_data)

# Load the gmodels package 
library(gmodels)

# Call CrossTable() on loan_status
CrossTable(loan_data$loan_status)

# Call CrossTable() on grade and loan_status
CrossTable(x = loan_data$grade, y = loan_data$loan_status, prop.r = TRUE,
            prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
