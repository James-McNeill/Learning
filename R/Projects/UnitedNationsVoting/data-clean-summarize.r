# Initial work with the dataset

# Filtering rows
# Load the dplyr package
library(dplyr)

# Print the votes dataset
votes

# Filter for votes that are "yes", "abstain", or "no"
votes %>% filter(vote <= 3)

# Add another %>% step to add a year column
votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945)

# Load the countrycode package
library(countrycode)

# Convert country code 100
countrycode(100, "cown", "country.name")

# Add a country column within the mutate: votes_processed
votes_processed <- votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945,
  votes_processed = countrycode(ccode, "cown", "country.name")
  )

# Print votes_processed
votes_processed

# Find total and fraction of "yes" votes. By performing a binary review of the variable vote, the calculation will treat each TRUE as 1 in the formula
votes_processed %>%
    summarize(total = n(),
    percent_yes = mean(vote == 1))

# Change this code to summarize by year
votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Summarize by country: by_country. Storing the output within the variable by_country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Review the output in the console
by_country

# You have the votes summarized by country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print the by_country dataset
by_country

# Sort in ascending order of percent_yes
by_country %>% arrange(percent_yes)

# Now sort in descending order
by_country %>% arrange(desc(percent_yes))

# Filter out countries with fewer than 100 votes. The countries with the lowest number of votes submitted can skew the conclusions
by_country %>%
  arrange(percent_yes) %>%
  filter(total >= 100)

