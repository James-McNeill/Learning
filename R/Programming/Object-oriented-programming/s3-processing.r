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

# Create a data.frame method for get_n_elements. This method will only work for data.frame objects that are passed to the function
get_n_elements.data.frame <- function(x, ...)
{
    nrow(x) * ncol(x)
}

# Call the method on the sleep dataset
n_elements_sleep <- get_n_elements(sleep)

# View the result
n_elements_sleep

# 3. Creating an S3 method (2)
# View predefined objects within the workspace
ls.str()

# Create a default method for get_n_elements. Applies a default method that is used when a data.frame object is not passed to the method
get_n_elements.default <- function(x, ...)
{
    length(unlist(x))
}

# Call the method on the ability.cov dataset
n_elements_ability.cov <- get_n_elements(ability.cov)

# B. Methodical thinking
# 1. Finding available methods
# Find methods for print. Note that the preferred syntax is to use a string for the function name when checking for methods
methods("print")
# Methods for a class. Note that this contains both S3 and S4 methods
methods(class="glm")
# Return only S3 methods
.S3methods(class="glm")
# Return only S4 methods
.S4methods(class="glm")

# C. Method lookup for Primitive generics
# 1. Primitive generic functions
# Some core functionality of R is defined using primitive functions, which use a special technique for accessing C-code, for performance reasons.
# R will look for methods using the class, as normal, but if nothing is found, the internal C-code function will be called.

# View the structure of hair. A list object, with the class overridden to be "hairstylist" has been assigned in your workspace to the variable hair
str(hair)

# What primitive generics are available?
.S3PrimitiveGenerics

# Does length.hairstylist exist?
exists("length.hairstylist")

# What is the length of hair?
length(hair)

# D. Too much class
# 1. Very classy
# View the kitty
kitty

# Assign classes
class(kitty) <- c("cat", "mammal", "character")

# Does kitty inherit from cat/mammal/character? Can check for classes by using inherits() method
inherits(kitty, "cat")
inherits(kitty, "mammal")
inherits(kitty, "character")

# Is kitty a character vector?
is.character(kitty)

# Does kitty inherit from dog?
inherits(kitty, "dog")

# 2. Writing the Next method
# Inspect your workspace
ls.str()

# cat method
what_am_i.cat <- function(x, ...)
{
  # Write a message
  message("I'm a cat")
  # Call NextMethod
  NextMethod("what_am_i")
}

# mammal method
what_am_i.mammal <- function(x, ...)
{
  message("I'm a mammal")
  NextMethod("what_am_i")
}

# character method
what_am_i.character <- function(x, ...)
{
  message("I'm a character vector")
}

# Call what_am_i()
what_am_i(kitty)
