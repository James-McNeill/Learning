# Advanced data challenges

# A. Uniformity
# 1. Date uniformity
# dplyr and lubridate are loaded and accounts is available
# Check out the accounts data frame
head(accounts)

# Define the date formats
formats <- c("%Y-%m-%d", "%B %d, %Y")

# Convert dates to the same format
accounts %>%
  mutate(date_opened_clean = parse_date_time(date_opened, orders = formats))

# 2. Currency uniformity
# dplyr and ggplot2 are loaded and the accounts and account_offices data frames are available
# Scatter plot of opening date and total amount
accounts %>%
  ggplot(aes(x = date_opened, y = total)) +
  geom_point()

# Left join accounts to account_offices by id
accounts %>%
  left_join(account_offices, by = "id") %>%
  # Convert totals from the Tokyo office to USD
  mutate(total_usd = ifelse(office == "Tokyo", total / 104, total)) %>%
  # Scatter plot of opening date vs total_usd
  ggplot(aes(x = date_opened, y = total_usd)) +
    geom_point()

# B. Cross field validation
# 1. Validating totals
# dplyr is loaded and accounts is available
# Find invalid totals
accounts %>%
  # theoretical_total: sum of the three funds
  mutate(theoretical_total = fund_A + fund_B + fund_C) %>%
  # Find accounts where total doesn't match theoretical_total
  filter(theoretical_total != total)

