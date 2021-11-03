# Performing inner joins

# 1. Joining on a unique key
# Use the suffix argument to replace .x and .y suffixes
parts %>% 
	inner_join(part_categories, by = c("part_cat_id" = "id"), suffix = c('_part', '_category'))
