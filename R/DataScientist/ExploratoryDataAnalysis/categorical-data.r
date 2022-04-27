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
