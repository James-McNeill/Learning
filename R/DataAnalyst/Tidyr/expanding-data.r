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
