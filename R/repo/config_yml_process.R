# Basic config setup to understand process steps
# Aim: take the yml file to construct the input parameters. This logic can be used to easily change the inputs for other
#       applications of the same program e.g., if a different input dataset is needed or testing / production environment.
# Introduction to this processing at: https://cran.r-project.org/web/packages/config/vignettes/introduction.html

# libraries
library(config)

# set work directory to folder for testing purposes
dir <- "input_dir"
setwd(dir)

# display current working directory
getwd()

# create an empty file in the current working directory
# file.create("config1.yml")

# find the config.yml file
config <- config::get(file="config.yml")

# display information contained within the yml file
print(config$dataset)
print(config$n_rows_to_print)
