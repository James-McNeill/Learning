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

