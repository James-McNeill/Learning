# German credit data - check out the ML in R book
# https://search.r-project.org/CRAN/refmans/fairml/html/00Index.html
# https://search.r-project.org/CRAN/refmans/fairml/html/german.credit.html
library(fairml)
library(dplyr)

tb <- german.credit 
is.atomic(tb)

class(tb)

tb %>% 
  summarize_all(mean)

table(tb$Credit_risk)

head(tb)

# Export as csv file
# write.csv(tb, "german_credit.csv")