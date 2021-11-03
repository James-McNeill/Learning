# Performing inner joins

# 1. Joining on a unique key
# Use the suffix argument to replace .x and .y suffixes
parts %>% 
	inner_join(part_categories, by = c("part_cat_id" = "id"), suffix = c('_part', '_category'))

# 2. One-to-many join
# Combine the parts and inventory_parts tables. If the two tables have the same variable name then can include only one for the by parameter
parts %>%
    inner_join(inventory_parts, by = 'part_num')

# Shows that the same join with tables in the opposite positions returns the same output
# Combine the parts and inventory_parts tables
inventory_parts %>%
    inner_join(parts, by = 'part_num')

# 3. Joining three tables
sets %>%
	# Add inventories using an inner join 
	inner_join(inventories, by = 'set_num') %>%
	# Add inventory_parts using an inner join . Joins with the inventories table
	inner_join(inventory_parts, by = c('id' = 'inventory_id'))

# 4. Join multiple tables and check for most common color of lego pieces
# Count the number of colors and sort
sets %>%
	inner_join(inventories, by = "set_num") %>%
	inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
	inner_join(colors, by = c("color_id" = "id"), suffix = c("_set", "_color")) %>%
	count(name_color, sort = TRUE)
