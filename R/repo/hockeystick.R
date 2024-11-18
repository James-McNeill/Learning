# Hockeystick to view climate data
# https://cortinah.github.io/hockeystick/
# Package depends on R version >= 4.0

# Managing the cache
# By default, no climate data is cached, and all data is downloaded every time any of the get_ functions are called. 
# To cache data for future use, use the write_cache = TRUE option, available in all of the get_ functions. To download 
# and cache all data use hockeystick_update_all(). To view the files, date, and size of cached data use 
# hockeystick_cache_details(). To re-download data from the source use the use_cache = FALSE argument in 
# any of the get_ functions, for example: get_carbon(use_cache = FALSE, write_cache = TRUE). To delete all 
# cached data use hockeystick_cache_delete_all().

# Library
library(hockeystick)
