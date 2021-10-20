# Utilities - regular expressions

# 1. grepl & grep
# grepl(): which returns TRUE when a pattern is found in the corresponding character string.
# grep(): which returns a vector of indices of the character strings that contains the pattern.

# The emails vector has already been defined for you
emails <- c("john.doe@ivyleague.edu", "education@world.gov", "dalai.lama@peace.org",
            "invalid.edu", "quant@bigdatacollege.edu", "cookie.monster@sesame.tv")

# Use grepl() to match for "edu"
grepl(pattern = "edu", x = emails)

# Use grep() to match for "edu", save result to hits
hits <- grep(pattern = "edu", x = emails)

# Subset emails using hits
emails[hits]

# Advanced regular expressions
# ^: match content at the start of string
# $: match content at the end of string
# @: because a valid email must contain an at-sign.
# .*: which matches any character (.) zero or more times (*). Both the dot and the asterisk are metacharacters. 
#     You can use them to match any character between the at-sign and the ".edu" portion of an email address.
# \\.edu$: to match the ".edu" part of the email at the end of the string. 
#     The \\ part escapes the dot: it tells R that you want to use the . as an actual character.

# The emails vector has already been defined for you
emails <- c("john.doe@ivyleague.edu", "education@world.gov", "dalai.lama@peace.org",
            "invalid.edu", "quant@bigdatacollege.edu", "cookie.monster@sesame.tv")

# Use grepl() to match for .edu addresses more robustly
grepl(pattern = "@.*\\.edu$", x = emails)

# Use grep() to match for .edu addresses more robustly, save result to hits
hits <- grep(pattern = "@.*\\.edu$", x = emails)

# Subset emails using hits
emails[hits]

# 2. sub and gsub
# sub(): only replaces the first match
# gsub(): replaces all matches

# The emails vector has already been defined for you
emails <- c("john.doe@ivyleague.edu", "education@world.gov", "global@peace.org",
            "invalid.edu", "quant@bigdatacollege.edu", "cookie.monster@sesame.tv")

# Use sub() to convert the email domains to datacamp.edu
sub(pattern = "@.*\\.edu$", replacement = "@datacamp.edu", x = emails)
