# Overview of packages

# install.packages(), which as you can expect, installs a given package.
# library() which loads packages, i.e. attaches them to the search list on your R workspace.
# using search() command within R console will show the packages currently installed in the R workspace

# Load the ggplot2 package
library("ggplot2")

# Retry the qplot() function
qplot(mtcars$wt, mtcars$hp)

# Check out the currently attached packages again
search()
