# Working with missing values

# Import libraries
library(readxl)
library(dplyr)

# Import the excel file - folder location to be applied
folder <- "input_path"

# Excel file for testing
res <- read_excel(file.path(folder, "INPUTFILE.xlsx"))
View(res)

# Check for the missing values
miss_val <- 11111111111

# Create the features exposure, rate exposure feature
res <- res %>%
  mutate(
    TOT_EXP = if_else(CCF == miss_val, ONBAL + OFFBAL, ONBAL + (OFFBAL * CCF)),
    EFFRAT_EXP = if_else(EFFRAT != miss_val, TOT_EXP * EFFRAT, NA_real_)
    )

# Summarize the analysis by Risk bucket
eir_review_rskbkt <- res %>%
  group_by(RSKBKT) %>%
  summarize(exposure = sum(TOT_EXP),
            eir_exp = sum(EFFRAT_EXP, na.rm = TRUE),
            eir_exp_avg = sum(EFFRAT_EXP, na.rm = TRUE) / sum(TOT_EXP))
eir_review_rskbkt
