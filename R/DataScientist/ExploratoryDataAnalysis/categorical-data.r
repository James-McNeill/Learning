# Working with categorical data in R

# A) Explore
# Print the comics data
comics

# Check levels of align
levels(comics$align)

# Check the levels of gender
levels(comics$gender)

# Create a 2-way contingency table
table(comics$align, comics$gender)

# 1) Dropping levels
# Load dplyr
library(dplyr)

# Print tab
tab

# Remove align level
comics_filtered <- comics %>%
  filter(align != "Reformed Criminals") %>%
  droplevels()

# See the result
comics_filtered

# 2) Side by side bar charts
# Load ggplot2
library(ggplot2)

# Create side-by-side bar chart of gender by alignment
ggplot(comics, aes(x = align, fill = gender)) + 
  geom_bar(position = "dodge")

# Create side-by-side bar chart of alignment by gender
ggplot(comics, aes(x = gender, fill = align)) + 
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 90))

