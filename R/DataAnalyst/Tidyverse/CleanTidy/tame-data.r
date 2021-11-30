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
