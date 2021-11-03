# Working with full joins

# First need to understand the data
# Start with inventory_parts_joined table
inventory_parts_joined %>%
  # Combine with the sets table 
  inner_join(sets, by = "set_num") %>%
  # Combine with the themes table 
  inner_join(themes, by = c("theme_id" = "id"), suffix = c("_set", "_theme"))

# 2. Aggregate the data
# Count the part number and color id, weight by quantity
batman %>%
    count(part_num, color_id, wt = quantity)
star_wars %>%
    count(part_num, color_id, wt = quantity)

# 3. Full join the two datasets
batman_parts %>%
  # Combine the star_wars_parts table 
  full_join(star_wars_parts, by = c("part_num", "color_id"), suffix = c("_batman", "_star_wars")) %>%
  # Replace NAs with 0s in the n_batman and n_star_wars columns 
  replace_na(list(n_batman = 0,
                  n_star_wars = 0))
