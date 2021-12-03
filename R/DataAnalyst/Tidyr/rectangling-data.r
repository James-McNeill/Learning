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
