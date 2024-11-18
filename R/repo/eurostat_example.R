# Downloading data from Eurostat package in R
# Example shared at https://rforpoliticalscience.com/2022/01/02/download-eu-data-with-eurostat-package-in-r-part-1-with-pyramid-graphs/
library(eurostat)
library(tidyverse)
library(janitor)
library(ggcharts)
# library(ggflags)
library(rvest)
library(countrycode)
library(magrittr)

# Understand available datasets
toc <- get_eurostat_toc()

toc_data <- toc %>%
  filter(type == "dataset")

# Review populations - bulk download is applied. Note that during 2023 this option will be retired. API with smaller download
# limit will be applied moving forward.
pop_data <- get_eurostat(id = "demo_pjan",
                         type = "label")
View(pop_data)

# Data cleaning
pop_data$year <- as.numeric(format(pop_data$time, format = "%Y"))

pop_data$age_number <- as.numeric(gsub("([0-9]+).*$", "\\1", pop_data$age))

# Filter data to two years for review
pop_data %>%
  filter(age != "Total") %>%
  filter(age != "Unknown") %>% 
  filter(sex == "Total") %>% 
  filter(year == 1960 | year == 2019 ) %>% 
  select(geo, values, age_number) -> demo_two_years

# Taking data from Wikipedia. Perform some data cleaning
eu_site <- read_html("https://en.wikipedia.org/wiki/Member_state_of_the_European_Union")

eu_tables <- eu_site %>%
  html_table(header= TRUE, fill = TRUE)

eu_members <- eu_tables[[3]]
eu_members %<>% janitor::clean_names() %>%
  filter(!is.na(accession))

# Data cleaning to remove some footnotes
eu_members$accession <- as.numeric(gsub("([0-9]+).*$", "\\1",eu_members$accession))

eu_members$name_clean <- gsub("\\[.*?\\]", "", eu_members$name)

# Including iso mapping
demo_two_years$iso3 <- countrycode::countrycode(demo_two_years$geo, "country.name", "iso3c")
eu_members$iso3 <- countrycode::countrycode(eu_members$name_clean, "country.name", "iso3c")

# Merge data for the pyramid chart
my_pyramid <- merge(demo_two_years, eu_members, by.x = "iso3", by.y = "iso3", all.x = TRUE)

# Create pyramid chart to understand population by age [1 to 99 years of age]
my_pyramid %>%  
  filter(!is.na(age_number)) %>%  
  #filter(accession == 1957 ) %>% 
  arrange(age_number) %>% 
  group_by(age_number) %>% 
  summarise(mean_age = mean(values, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pyramid_chart(age_number, mean_age, year,
                bar_colors = c("#9a031e", "#0f4c5c")) 
