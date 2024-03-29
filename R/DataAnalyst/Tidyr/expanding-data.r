# Expanding datasets

# A. Creating unique combinations of vectors
# 1. Letters of the genetic code
letters <- c("A", "C", "G", "U")

# Create a tibble with all possible 3 way combinations
codon_df <- expand_grid(
  letter1 = letters,
  letter2 = letters,
  letter3 = letters
)

codon_df %>% 
  # Unite these three columns into a "codon" column
  unite("codon", letter1:letter3, sep = " ")

# 2. When did humans replace dogs in space
# Create a tibble with all combinations of years and species
full_df <- expand_grid(
  year = 1951:1970, 
  species = c("Human", "Dog")
)

space_df %>% 
  # Join with full_df so that missing values are introduced
  right_join(full_df, by = c("year", "species")) %>% 
  # Overwrite NA values for n_in_space with 0L
  replace_na(list(n_in_space = 0L)) %>% 
  # Create a line plot with n_in_space over year, color by species
  ggplot(aes(x = year, y = n_in_space, color = species)) +
  geom_line()

# 3. Finding missing observations
# Create a tibble with all combinations of dates and reactors
full_df <- expand_grid(
  date = dates,
  reactor = reactors
)

# Find the reactor - date combinations not present in reactor_df
full_df %>% 
  anti_join(
    reactor_df, by = c("date", "reactor")
  )

# B. Completing data with all value combinations
# 1. Completing the solar system
planets = c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")

planet_df %>% 
  complete(
    # Complete the planet variable
    planet = planets,
    # Overwrite NA values for n_moons with 0L
    fill = list(n_moons = 0L)
  )

# 2. Zero olympic medals
medal_df %>% 
  # Count the medals won per team and year
  count(team, year, name = "n_medals") %>% 
  # Complete the team and year variables, fill n_medals with zeros
  complete(
    team, year, fill = list(n_medals = 0L)
  ) %>% 
  # Plot n_medals over year, colored by team
  ggplot(aes(x = year, y = n_medals, color = team)) +
  geom_line() +
  scale_color_brewer(palette = "Paired")

# 3. Creating a full_seq()
# Generate all years from 2020 to 2030
years <- full_seq(c(2020, 2030), period = 1)
years

# Generate all decades from 1980 to 2030
decades <- full_seq(c(1980, 2030), period = 10)
decades

outer_dates <- c(as.Date("1980-01-01"), as.Date("1980-12-31"))

# Generate the dates for all days in 1980
full_seq(outer_dates, period = 1)

# 4. The Cold War's hottest year
cumul_nukes_1962_df %>% 
  # Complete the dataset
  complete(country, date = full_seq(date, period = 1)) %>% 
  # Group the data by country
  group_by(country) %>% 
  # Impute missing values with the last known observation. Default is "down"
  fill(total_bombs) %>% 
  # Plot the number of bombs over time, color by country
  ggplot(aes(x = date, y = total_bombs, color = country)) +
  # These two lines will mark the Cuban Missile Crisis 
  geom_rect(xmin = as.Date("1962-10-16"), xmax = as.Date("1962-10-29"), ymin = -Inf, ymax = Inf, color = NA)+ 
  geom_text(x = as.Date("1962-10-22"), y = 15, label = "Cuban Missile Crisis", angle = 90, color = "white")+
  geom_line()

# D. Advanced completions
# 1. Olympic medals per continent. Comparison across summer and winter games
medal_df %>% 
  # Give each continent an observation at each Olympic event. nesting: maintains relationship to avoid non-sensical connections
  complete(
    continent, 
    nesting(season, year), 
    fill = list(medals_per_participant = 0L)
  ) %>%
  # Plot the medals_per_participant over time, colored by continent
  ggplot(aes(x = year, y = medals_per_participant, color = continent)) +
  geom_line() +
  facet_grid(season ~ .)

# 2. Tracking a virus outbreak
patient_df %>% 
  # Pivot the infected and recovered columns to long format
  pivot_longer(-patient, names_to = "status", values_to = "date") %>% 
  select(-status) %>% 
  # Group by patient
  group_by(patient) %>% 
  # Complete the date range per patient using full_seq()
  complete(date = full_seq(date, period = 1)) %>% 
  # Ungroup the data
  ungroup() %>% 
  # Count the dates, the count goes in the n_sick variable
  count(date, name = "n_sick") %>% 
  ggplot(aes(x = date, y = n_sick))+
  geom_line()

# 3. Counting office occupants
sensor_df %>% 
  # Complete the time column with a 20 minute interval
  complete(time = seq(min(time), max(time), by = "20 min"),
           fill = list(enter = 0L, exit = 0L)) %>%
  # Calculate the total number of people inside
  mutate(total_inside = cumsum(enter + exit)) %>% 
  # Pivot the enter and exit columns to long format
  pivot_longer(enter:exit, names_to = "direction", values_to = "n_people") %>% 
  # Plot the number of people over time, fill by direction
  ggplot(aes(x = time, y = n_people, fill = direction)) +
  geom_area() +
  geom_line(aes(y = total_inside))
