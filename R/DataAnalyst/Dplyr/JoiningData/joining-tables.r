# Performing inner joins

# 1. Joining on a unique key
# Use the suffix argument to replace .x and .y suffixes
parts %>% 
	inner_join(part_categories, by = c("part_cat_id" = "id"), suffix = c('_part', '_category'))

# 2. One-to-many join
# Combine the parts and inventory_parts tables. If the two tables have the same variable name then can include only one for the by parameter
parts %>%
    inner_join(inventory_parts, by = 'part_num')
