# Statistics

# A. stats with geoms
# 1. Smoothing
# Amend the plot to add a smooth layer
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth()

# Amend the plot. Use lin. reg. smoothing; turn off std err ribbon
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Amend the plot. Swap geom_smooth() for stat_smooth(). Shows that the linear model (lm) can be created with either method
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE)

# 2. Grouping variables
# Using mtcars, plot mpg vs. wt, colored by fcyl
ggplot(mtcars, aes(x = wt, y = mpg, color = fcyl)) +
  # Add a point layer
  geom_point() +
  # Add a smooth lin reg stat, no ribbon
  stat_smooth(method = "lm", se = FALSE)

# Amend the plot to add another smooth layer with dummy grouping
ggplot(mtcars, aes(x = wt, y = mpg, color = fcyl)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE) +
  stat_smooth(aes(group = 1), method = "lm", se = FALSE) # shows a dummy curve that has used all of the data points for one curve

# 3. Modifying stat_smooth
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  # Add 3 smooth LOESS stats, varying span & color. Providing span parameter relates to the number of data points that are using. Shorter
  # span will include more of the noise across the time series and could result in some overfitting
  stat_smooth(se = FALSE, span = 0.9, color = "red") +
  stat_smooth(se = FALSE, span = 0.6, color = "green") +
  stat_smooth(se = FALSE, span = 0.3, color = "blue")

# Amend the plot to color by fcyl
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  # Add a smooth LOESS stat, no ribbon
  stat_smooth(se = FALSE) +
  # Add a smooth lin. reg. stat, no ribbon
  stat_smooth(method = "lm", se = FALSE)

# Amend the plot
ggplot(mtcars, aes(x = wt, y = mpg, color = fcyl)) +
  geom_point() +
  # Map color to dummy variable "All"
  stat_smooth(se = FALSE, aes(color = "All")) +
  stat_smooth(method = "lm", se = FALSE)

# 4. Modufying stat_smooth 2
# Using Vocab, plot vocabulary vs. education, colored by year group
ggplot(Vocab, aes(x = education, y = vocabulary, color = year_group)) +
  # Add jittered points with transparency 0.25
  geom_jitter(alpha = 0.25) +
  # Add a smooth lin. reg. line (with ribbon)
  stat_smooth(method = "lm")

# Amend the plot
ggplot(Vocab, aes(x = education, y = vocabulary, color = year_group)) +
  geom_jitter(alpha = 0.25) +
  # Map the fill color to year_group, set the line size to 2
  stat_smooth(method = "lm", aes(fill = year_group), size = 2)

# B. stats sum and quantile
# 1. Quantiles
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  geom_jitter(alpha = 0.25) +
  # Add a quantile stat, at 0.05, 0.5, and 0.95
  stat_quantile(quantiles = c(0.05, 0.5, 0.95))

# Amend the plot to color by year_group. Quantile regression helps to provide a high level overview of the data
ggplot(Vocab, aes(x = education, y = vocabulary, color = year_group)) +
  geom_jitter(alpha = 0.25) +
  stat_quantile(quantiles = c(0.05, 0.5, 0.95))

# 2. Using stat_sum()
# Replaces the overlapping data points with a size variable attribute e.g. if a large number of data points are given the same value then the
# data point will be provided a larger size relative to other data points that might be less popular

# Run this, look at the plot, then update it
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  # Replace this with a sum stat
  # geom_jitter(alpha = 0.25)
  stat_sum()

ggplot(Vocab, aes(x = education, y = vocabulary)) +
  stat_sum() +
  # Add a size scale, from 1 to 10
  scale_size(range = c(1, 10))

# Amend the plot to group by education
ggplot(Vocab, aes(x = education, y = vocabulary, group = education)) +
  stat_sum(aes(size = ..prop..)) # size value of proportion of the whole dataset

# 3. stats outside geoms
# 1. Preparations
# From previous step
posn_j <- position_jitter(width = 0.2)
posn_d <- position_dodge(width = 0.1)
posn_jd <- position_jitterdodge(jitter.width = 0.2, dodge.width = 0.1)

# Create the plot base: wt vs. fcyl, colored by fam
p_wt_vs_fcyl_by_fam <- ggplot(mtcars, aes(x = fcyl, y = wt, color = fam))

# Add a point layer
p_wt_vs_fcyl_by_fam +
  geom_point()

# 2. Using position objects from preparations step
# Add jittering only
p_wt_vs_fcyl_by_fam +
  geom_point(position = posn_j)

# Add dodging only
p_wt_vs_fcyl_by_fam +
  geom_point(position = posn_d)

# Add jittering and dodging
p_wt_vs_fcyl_by_fam +
  geom_point(position = posn_jd)

# 3. Plotting variations
# mean_sdl(), calculates multiples of the standard deviation and mean_cl_normal() calculates the t-corrected 95% CI
# Arguments to the data function are passed to stat_summary()'s fun.args argument as a list.
p_wt_vs_fcyl_by_fam_jit +
  # Add a summary stat of std deviation limits
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), position = posn_d)

p_wt_vs_fcyl_by_fam_jit +
  # Change the geom to be an errorbar
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), position = posn_d, geom = "errorbar")

p_wt_vs_fcyl_by_fam_jit +
  # Add a summary stat of normal confidence limits
  stat_summary(fun.data = mean_cl_normal, fun.args = list(mult = 1), position = posn_d)
