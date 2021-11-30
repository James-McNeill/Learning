# Tame the data

# A. Cast Column types
# 1. Cast a column to a date
# Find format to parse uk_airdate 
parse_date("17 August 2010", format = "%d %B %Y")

# Edit to cast uk_airdate
desserts <- read_csv("desserts.csv", 
                     col_types = cols(
                       uk_airdate = col_date(format = "%d %B %Y")
                     )
                    )

# Arrange by descending uk_airdate
desserts %>% 
	arrange(desc(uk_airdate))

# 2. Cast a column to a number
# Edit code to fix the parsing error 
desserts <- read_csv("desserts.csv",
                      col_types = cols(
                        uk_airdate = col_date(format = "%d %B %Y"),
                        technical = col_number()
                      ),
                        na = c("", "NA", "N/A") 
                     )

# View parsing problems
problems(desserts)

# 3. Cast a column as a factor
# Cast result a factor
desserts <- read_csv("desserts.csv", 
                     na = c("", "NA", "N/A"),
                     col_types = cols(
                       uk_airdate = col_date(format = "%d %B %Y"),
                       technical = col_number(),                       
                       result = col_factor(levels = NULL)
                     )
                    )
                    
# Glimpse to view
glimpse(desserts)

# B. Recode values
# 1. Recode a character variable
# Count rows grouping by nut variable
desserts %>% 
    count(nut, sort = TRUE)
    
# Edit code to recode "no nut" as missing
desserts_2 <- desserts %>% 
  mutate(nut = recode(nut, "filbert" = "hazelnut", 
                           "no nut" = NA_character_))

# Count rows again 
desserts_2 %>% 
    count(nut, sort = TRUE)

# 2. Recode a numeric variable
# Edit to recode tech_win as factor. The parameter .default can be used to assign other values
desserts <- desserts %>% 
  mutate(tech_win = recode_factor(technical, `1` = 1,
                           .default = 0))

# Count to compare values                      
desserts %>% 
  count(technical == 1, tech_win)

# C. Select variables
# 1. Combine functions with select
ratings %>% 
	filter(episodes == 10) %>% 
	group_by(series) %>% 
	mutate(diff = e10_viewers - e1_viewers) %>% 
	arrange(desc(diff)) %>% 
	select(series, diff)

# 2. Recode factor to plot
# Recode channel as factor: bbc (1) or not (0)
ratings <- ratings %>% 
  mutate(bbc = recode_factor(channel, 
                             "Channel 4" = 0,
                             .default = 1))
                            
# Select to look at variables to plot next
ratings %>% 
  select(series, channel, bbc, viewer_growth)
  
# Make a filled bar chart
ggplot(ratings, aes(x = series, y = viewer_growth, fill = bbc)) +
  geom_col()

# 3. Select and reorder variables
# Move channel to first column
ratings %>% 
  select(channel, everything())

# Drop 7- and 28-day episode ratings
ratings %>% 
  select(-ends_with("day"))

# Move channel to front and drop 7-/28-day episode ratings
ratings %>% 
  select(channel, everything(), -ends_with("day"))

# D. Tame variable names
# 1. Reformat variables
# Glimpse to see variable names
glimpse(messy_ratings)

# Load janitor
library(janitor)

# Reformat to lower camelcase
ratings <- messy_ratings %>%
  clean_names(case = "lower_camel")
    
# Glimpse new tibble
glimpse(ratings)

# Reformat to snake case
ratings <- messy_ratings %>%  
  clean_names()

# Glimpse cleaned names
glimpse(ratings)
