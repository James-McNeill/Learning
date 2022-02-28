# Pattern matching with regular expressions

# A. Regular expressions
# 1. Matching the start or end of the string
# Working with rebus (Regular Expression Builder)
# Some strings to practice with
x <- c("cat", "coat", "scotland", "tic toc")

# Print END
END

# Run me. Keyword %R% can be referenced as THEN. Using this method provides a HTML output
str_view(x, pattern = START %R% "c")

# Match the strings that start with "co" 
str_view(x, pattern = START %R% "co")

# Match the strings that end with "at"
str_view(x, pattern = "at" %R% END)

# Match the string that is exactly "cat". rebus contains a function exactly(x) that can be used instead of the syntax below
str_view(x, pattern = START %R% "cat" %R% END)

# 2. Matcing any character
# Match two characters, where the second is a "t"
str_view(x, pattern = ANY_CHAR %R% "t")

# Match a "t" followed by any character
str_view(x, pattern = "t" %R% ANY_CHAR)

# Match two characters. Regular expressions are lazy and will take the first match they find
str_view(x, pattern = ANY_CHAR %R% ANY_CHAR)

# Match a string with exactly three characters
str_view(x, pattern = START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END)

# 3. Combining with stringr functions
pattern <- "q" %R% ANY_CHAR

# Find names that have the pattern
names_with_q <- str_subset(boy_names, pattern = pattern)

# How many names were there?
length(names_with_q)

# Find part of name that matches pattern
part_with_q <- str_extract(boy_names, pattern = "q" %R% ANY_CHAR)

# Get a table of counts
table(part_with_q)

# Did any names have the pattern more than once?
count_of_q <- str_count(boy_names, pattern = pattern)

# Get a table of counts
table(count_of_q)

# Which babies got these names?
with_q <- str_detect(boy_names, pattern = pattern)

# What fraction of babies got these names?
mean(with_q)
