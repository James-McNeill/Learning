# Tidy data using R pipes

# A. gather()
# Used to convert tame (wide) data structure to tidy (long) data structure

# 1. Gather & plot
tidy_ratings <- ratings %>%
    # Gather and convert episode to factor.
    # factor_key: maintains the original order of columns
    # na.rm: removes the missing values from value
	gather(key = "episode", value = "viewers_7day", -series, 
           factor_key = TRUE, na.rm = TRUE) %>%
	# Sort in ascending order by series and episode
    arrange(series, episode) %>% 
	# Create new variable using row_number()
    mutate(episode_count = row_number())

# Plot viewers by episode and series
ggplot(tidy_ratings, aes(x = episode_count, 
                y = viewers_7day, 
                fill = series)) +
    geom_col()

# 2. Gather & plot non-sequential columns
week_ratings <- ratings2  %>% 
	# Select 7-day viewer ratings
    select(series, ends_with("7day")) %>% 
	# Gather 7-day viewers by episode
    gather(episode, viewers_7day, ends_with("7day"), na.rm = TRUE, factor_key = TRUE)
    
# Plot 7-day viewers by episode and series
ggplot(week_ratings, aes(x = episode, 
                         y = viewers_7day, 
                         group = series)) +
    geom_line() +
    facet_wrap(~series)

# B. Separate()
# 1. Separate a column
# tidyr, dplyr, and readr packages
# Create week_ratings
week_ratings <- ratings2 %>% 
    select(series, ends_with("7day")) %>% 
    gather(episode, viewers_7day, ends_with("7day"), 
           na.rm = TRUE) %>% 
    separate(episode, into = "episode", extra = "drop") %>% 
    mutate(episode = parse_number(episode))
    
# Edit your code to color by series and add a theme
ggplot(week_ratings, aes(x = episode, y = viewers_7day, 
                         group = series, color = series)) +
    geom_line() +
    facet_wrap(~series) +
    guides(color = FALSE) +
    theme_minimal()

# 2. Unite columns
ratings3 <- ratings2  %>% 
	# Unite and change the separator
	unite(viewers_7day, viewers_millions, viewers_decimal, sep = "") %>%
	# Adapt to cast viewers as a number
	mutate(viewers_7day = as.numeric(viewers_7day))

# Print to view
ratings3

# 3. Spread rows into columns
# Create tidy data with 7- and 28-day viewers
tidy_ratings_all <- ratings2 %>% 
    gather(episode, viewers, ends_with("day"), na.rm = TRUE) %>% 
    separate(episode, into = c("episode", "days")) %>%  
    mutate(episode = parse_number(episode),
           days = parse_number(days)) 

tidy_ratings_all %>% 
	# Count viewers by series and days
    count(series, days, wt = viewers) %>%
	# Adapt to spread counted values
    spread(days, n, sep = "_")

# C. Tidy mulitple sets of columns
# 1. Tidy 1
# Fill in blanks to get premiere/finale data
tidy_ratings <- ratings %>%
    gather(episode, viewers, -series, na.rm = TRUE) %>%
    mutate(episode = parse_number(episode)) %>% 
    group_by(series) %>% 
    filter(episode == 1 | episode == max(episode)) %>% 
    ungroup()

# 2. Tidy 2
# Recode first/last episodes
first_last <- tidy_ratings %>% 
  mutate(episode = recode(episode, `1` = "first", .default = "last")) 

# Fill in to make slope chart
ggplot(first_last, aes(x = episode, y = viewers, color = series)) +
  geom_point() +
  geom_line(aes(group = series))

# Switch the variables mapping x-axis and color. This created a dumbell chart which was a better display of the data
ggplot(first_last, aes(x = series, y = viewers, color = episode)) +
  geom_point() + # keep
  geom_line(aes(group = series)) + # keep
  coord_flip() # keep

# 3. Tidy 3
# Calculate relative increase in viewers
bump_by_series <- first_last %>% 
  spread(episode, viewers) %>%   
  mutate(bump = (last - first) / first)
  
# Fill in to make bar chart of bumps by series
ggplot(bump_by_series, aes(x = series, y = bump)) +
  geom_col() +
  scale_y_continuous(labels = scales::percent) # converts to %
