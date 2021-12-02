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
