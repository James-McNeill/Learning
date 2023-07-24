# Data pipeline
library(magrittr)
library(dplyr)
library(tidyverse)

# Define a data pipeline function
# data_pipeline <- function(df) {
#   # df1 <- df %>%
#   #   mutate(y = x * 2) %>%
#   #   filter(x > 0)
#   df %>%
#     group_by(z) %>%
#     summarize(avg_y = mean(x, na.rm = TRUE))
# }

# Example data
data <- data.frame(z = c("A", "B", "A", "B", "A"), x = c(-1, 2, 3, -4, 5))

# Apply the data pipeline function to the data
# result <- data_pipeline(data)
result <- data %>%
  filter(x > 0) %>%
  mutate(y = x * 2) %>%
  group_by(z) %>%
  summarize(avg_y = mean(y, na.rm = TRUE))

# View the result
result
