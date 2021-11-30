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
