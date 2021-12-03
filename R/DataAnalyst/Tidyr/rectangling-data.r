# Rectangling data

# A. Intro to non-rectangular data
# 1. Rectangling Star Wars movies
# Data is taken from Star Wars API and is in JSON format

# Create a movie column from the movie_list
tibble(movie = movie_list) %>% 
  # Unnest the movie column
  unnest_wider(movie)

# Create a tibble with a movie column
tibble(movie = movie_planets_list) %>% 
  # Unnest the movie column
  unnest_wider(movie) %>% 
  # Unnest the planets column
  unnest_wider(planets)

# B. From nested values to observations
# 1. Rectangling Star Wars planets
# unnest_wider(): common length of lists
# unnest_longer(): varying length of lists

# Create a tibble from movie_planets_list
tibble(movie = movie_planets_list) %>% 
  # Unnest the movie column in the correct direction
  unnest_wider(movie) %>% 
  # Unnest the planets column in the correct direction
  unnest_longer(planets)

# 2. The Solar System's biggest moons
planet_df %>% 
  # Unnest the moons list column over observations
  unnest_longer(moons) %>% 
  # Further unnest the moons column
  unnest_wider(moons) %>% 
  # Unnest the moon_data column
  unnest_wider(moon_data) %>% 
  # Get the top five largest moons by radius
  slice_max(radius, n = 5)
