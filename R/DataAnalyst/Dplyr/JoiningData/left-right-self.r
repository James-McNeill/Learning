# Working with left, right and self joins

# A. Left join
# 1. Left join by two different variable names
# Combine the star_destroyer and millennium_falcon tables
millennium_falcon %>%
    left_join(star_destroyer, by = c('part_num', 'color_id'), suffix = c('_falcon', '_star_destroyer'))

# 2. Left joining two sets by color
# Aggregate Millennium Falcon for the total quantity in each part
millennium_falcon_colors <- millennium_falcon %>%
  group_by(color_id) %>%
  summarize(total_quantity = sum(quantity))

# Aggregate Star Destroyer for the total quantity in each part
star_destroyer_colors <- star_destroyer %>%
  group_by(color_id) %>%
  summarize(total_quantity = sum(quantity))

# Left join the Millennium Falcon colors to the Star Destroyer colors
millennium_falcon_colors %>%
  left_join(star_destroyer_colors, by = 'color_id', suffix = c('_falcon', '_star_destroyer'))

# 3. Finding an observation that has a missing value
inventory_version_1 <- inventories %>%
  filter(version == 1)

# Join versions to sets
sets %>%
  left_join(inventory_version_1, by = 'set_num') %>%
  # Filter for where version is na. Shows that the joined table has no matching value
  filter(is.na(version))
