# Data visualizations with ggplot2

# Define by_year
by_year <- votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Load the ggplot2 package
library(ggplot2)

# Create line plot
ggplot(by_year, aes(year, percent_yes)) +
  geom_line()

# Change to scatter plot and add smoothing curve
ggplot(by_year, aes(year, percent_yes)) +
  geom_point() +
  geom_smooth()
