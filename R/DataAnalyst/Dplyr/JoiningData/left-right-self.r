# Working with left, right and self joins

# A. Left join
# Combine the star_destroyer and millennium_falcon tables
millennium_falcon %>%
    left_join(star_destroyer, by = c('part_num', 'color_id'), suffix = c('_falcon', '_star_destroyer'))
