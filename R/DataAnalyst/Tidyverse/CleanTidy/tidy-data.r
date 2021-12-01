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
