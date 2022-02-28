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

