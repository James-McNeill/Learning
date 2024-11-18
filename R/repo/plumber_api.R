# Creating an API with plumber
# Link https://www.r-bloggers.com/2022/03/creating-apis-for-data-science-with-plumber/

# cheatsheets
# https://github.com/rstudio/cheatsheets/blob/main/plumber.pdf

# Recreating the Shiny App tutorial with a Plumber API + React
# Part 1: https://www.jumpingrivers.com/blog/r-shiny-plumber-react-part-1/

# plumber.R
library(plumber)

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}
