# Returning values from a function

# A. Returning values from functions
# 1. Returning early
# Should a result occur earlier in the function then a result can be returned early without having to run the entire function
is_leap_year <- function(year) {
  # If year is div. by 400 return TRUE
  if(year %% 400 == 0) {
    return(TRUE)
  }
  # If year is div. by 100 return FALSE
  if(year %% 100 == 0) {
    return(FALSE)
  }  
  # If year is div. by 4 return TRUE
  if(year %% 4 == 0) {
    return(TRUE)
  }
  
  # Otherwise return FALSE
  return(FALSE)
}

# 2. Return invisibly
# Define a pipeable plot fn with data and formula args
pipeable_plot <- function(data, formula) {
  # Call plot() with the formula interface
  plot(formula, data = data)
  # Invisibly return the input dataset
  invisible(data)
}

# Draw the scatter plot of dist vs. speed again
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Now the plot object has a value
plt_dist_vs_speed

# B. Returning multiple values from functions
# 1. Returning many things
# If users want to have the list items as separate variables, they can assign each list element to its own variable using zeallot's multi-assignment operator, %<-%.
# Look at the structure of model (it's a mess!)
str(model)

# Use broom tools to get a list of 3 data frames. Each of the methods are taken from the broom package
list(
  # Get model-level values
  model = glance(model),
  # Get coefficient-level values
  coefficients = tidy(model),
  # Get observation-level values
  observations = augment(model)
)

# Wrap this code into a function, groom_model
groom_model <- function(model) {
  list(
    model = glance(model),
    coefficients = tidy(model),
    observations = augment(model)
  )
}

# Call groom_model on model, assigning to 3 variables
c(mdl, cff, obs) %<-% groom_model(model)

# See these individual variables
mdl; cff; obs

# 2. Returning metadata
pipeable_plot <- function(data, formula) {
  plot(formula, data)
  # Add a "formula" attribute to data. Syntax to assign attributes; attr(object, "attribute_name") <- attribute_value
  attr(data, "formula") <- formula
  invisible(data)
}

# From previous exercise
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Examine the structure of the result
plt_dist_vs_speed

# C. Environments
# Environments are used to store other variables. Environments interact similar to family structures, whereby, if the parent does not have the answer
# then the grandparent will be asked and so forth.
# 1. Creating and exploring environments
# Add capitals, national_parks, & population to a named list
rsa_lst <- list(
  capitals = capitals,
  national_parks = national_parks,
  population = population
)

# List the structure of each element of rsa_lst
ls.str(rsa_lst)

# convert list to environment
rsa_env <- list2env(rsa_lst)

# Find the parent environment of rsa_env
parent <- parent.env(rsa_env)

# Print its name
environmentName(parent)

# 2. Do variables exist
# Compare the contents of the global environment and rsa_env
ls.str(globalenv())
ls.str(rsa_env)

# Does population exist in rsa_env?
exists("population", envir = rsa_env)

# Does population exist in rsa_env, ignoring inheritance?
exists("population", envir = rsa_env, inherit = FALSE)
