# What is tidy data

# A. Tidy data structure
# 1. Multiple variables per column
netflix_df %>% 
  # Split the duration column into value and unit columns. Using convert parameter creates the appropriate column data type conversion
  separate(duration, into = c("value", "unit"), sep = " ", convert = TRUE)

# B. Columns with multiple values
# 1. International phone numbers
phone_nr_df %>%
  # Unite the country_code and national_number columns
  unite("international_number", country_code, national_number, sep = " ")

# 2. Extracting observations from values
tvshow_df %>% 
  # Separate the actors in the cast column over multiple rows
  separate_rows(cast, sep = ", ") %>% 
  rename(actor = cast) %>% 
  count(actor, sort = TRUE) %>% 
  head()

# 3. Separating into columns and rows
drink_df %>% 
  # Separate the ingredients over rows
  separate_rows(ingredients, sep = "; ") %>% 
  # Separate ingredients into three columns
  separate(
    ingredients, 
    into = c("ingredient", "quantity", "unit"), 
    sep = " ", 
    convert = TRUE
  ) %>% 
  # Group by ingredient and unit
  group_by(ingredient, unit) %>% 
  # Calculate the total quantity of each ingredient
  summarize(quantity = sum(quantity))

# C. Missing values
# 1. Drop na values
director_df %>% 
  # Drop rows with NA values in the director column
  drop_na() %>% 
  # Spread the director column over separate rows
  separate_rows(director, sep = ", ") %>% 
  # Count the number of movies per director
  count(director, sort = TRUE)

# 2. Imputing sales data
# fill(): can be used to back and forward fill missing values for variables
sales_df %>% 
  # Impute the year column
  fill(year, .direction = "up") %>%
  # Create a line plot with sales per quarter colored by year.
  ggplot(aes(x = quarter, y = sales, color = year, group = year)) +
  geom_line()

# 3. Working with replace_na
# Method allows for missing values to be filled in for the DataFrame
country_to_continent_df %>% 
  left_join(nuke_df, by = "country_code") %>%  
  # Impute the missing values in the n_bombs column with 0L
  replace_na(list(n_bombs = 0L)) %>% 
  # Group the dataset by continent
  group_by(continent) %>% 
  # Sum the number of bombs per continent
  summarize(n_bombs_continent = sum(n_bombs)) %>% 
  # Plot the number of bombs per continent
  ggplot(aes(x = continent, y = n_bombs_continent)) +
  geom_col()
