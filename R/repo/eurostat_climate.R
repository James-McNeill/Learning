# Review the Eurostat package to extract data
# Tutorial for the eurostat R package https://ropengov.github.io/eurostat/articles/eurostat_tutorial.html
# Load the package
library(eurostat)
library(knitr)
library(tidyverse)

# Get Eurostat data listing
toc <- get_eurostat_toc()

# Check the first items
kable(tail(toc))

# Search eurostat
# searcheuro <- search_eurostat()

# Review the data
toc_data <- toc %>%
  filter(type == "dataset")

head(toc_data)

toc_data %>% show_query()

type(toc_data)
