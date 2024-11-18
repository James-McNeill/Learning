# Show SQL query example
# https://www.tidyverse.org/blog/2019/11/dtplyr-1-0-0/

# Libraries to install
library(data.table)
library(dbplyr)
library(dtplyr)
library(dplyr, warn.conflicts = FALSE)

# Example using iris data
data("iris")

# Put in a temporary table
iris2 <- memdb_frame(iris) %>%
  filter(Species == "setosa")  %>% 
  summarise(mean.Sepal.Length = mean(Sepal.Length),
            mean.Petal.Length = mean(Petal.Length))

# Show the SQL query
iris2 %>% show_query()

# # Create lazy data table to track operations
# mtcars2 <- lazy_dt("mtcars")

# Not working
# mtcars2 %>%
#   filter(wt < 5) %>%
#   mutate(l100k = 235.21 / mpg) %>% # litres / 100km
#   group_by(cyl) %>%
#   summarise(l100k = mean(l100k)) %>%
#   as_tibble()

# Previous code - issue with this version
# # Produce short summary details within dplyr
# memdb_frame(mtcars) %>%
#   group_by(cyl) %>%
#   summarise(mpg = mean(mpg, na.rm = TRUE)) %>%
#   arrange(desc(mpg)) %>% show_query()
# 
# # see query
# summary %>% show_query()
# 
# # execute query and retrieve results
# summary %>% collect()
