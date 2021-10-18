# Summary function
# This function can be used throughout R to help summarize the variables that have been created

# Build factor_survey_vector with clean levels
survey_vector <- c("M", "F", "F", "M", "M")
factor_survey_vector <- factor(survey_vector)
levels(factor_survey_vector) <- c("Female", "Male")
factor_survey_vector

# Generate summary for survey_vector - displays characteristics of the variable
summary(survey_vector)

# Generate summary for factor_survey_vector - displays the summary values for the variable labels
summary(factor_survey_vector)
