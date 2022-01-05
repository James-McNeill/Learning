# Working with S3
# S3 is a very simple object-oriented system that lets you define different behavior for functions, depending upon their input argument

# A. Generics and methods or function overload
# 1. Creating a Generic function
# The ellipsis is included in case arguments need to be passed from one method to another
# Overall structure of an S3 generic
an_s3_generic <- function(x, maybe = "some", other = "arguments", ...) {
  UseMethod("an_s3_generic")
}

# Create get_n_elements
get_n_elements <- function(x, ...)
{
  UseMethod("get_n_elements")
}

# 2. Creating an S3 method
# By itself the generic doesn't do anything. It is the method that helps to perform a task
# View get_n_elements
get_n_elements

# Create a data.frame method for get_n_elements
get_n_elements.data.frame <- function(x, ...)
{
    nrow(x) * ncol(x)
}

# Call the method on the sleep dataset
n_elements_sleep <- get_n_elements(sleep)

# View the result
n_elements_sleep
