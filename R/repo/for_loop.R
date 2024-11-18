# Example data
data <- data.frame(x = 1:10, y = 11:20, z = 21:30)

# Function to calculate mean and standard deviation of a column in a data frame
calc_stats <- function(df, col) {
  mean_val <- mean(df[[col]])
  sd_val <- sd(df[[col]])
  return(list(mean_val = mean_val, sd_val = sd_val))
}

# Loop to calculate stats for each column in the data frame
for(col in colnames(data)) {
  stats <- calc_stats(data, col)
  cat("Column", col, "Mean:", stats$mean_val, "SD:", stats$sd_val, "\n")
}
