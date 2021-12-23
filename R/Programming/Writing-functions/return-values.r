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
