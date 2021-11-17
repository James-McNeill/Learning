# Reviewing the best practices

# A. Bar plots
# 1. Dynamite plots
# Plot wt vs. fcyl
ggplot(mtcars, aes(x = fcyl, y = wt)) +
  # Add a bar summary stat of means, colored skyblue
  stat_summary(fun.y = mean, geom = "bar", fill = "skyblue") +
  # Add an errorbar summary stat std deviation limits
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), geom = "errorbar", width = 0.1)

# 2. Position dodging
# Define a dodge position object with width 0.9
posn_d <- position_dodge(width = 0.9)

# For each summary stat, update the position to posn_d
ggplot(mtcars, aes(x = fcyl, y = wt, color = fam, fill = fam)) +
  stat_summary(fun.y = mean, geom = "bar", position = posn_d, alpha = 0.5) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), width = 0.1, position = posn_d, geom = "errorbar")

# 3. Using aggregate data. The dataframe has been developed as a summary of the initial mtcars dataframe using cyl as the group by column
# Using mtcars_cyl, plot mean_wt vs. cyl
ggplot(mtcars_by_cyl, aes(x = cyl, y = mean_wt)) +
  # Add a bar layer with identity stat, filled skyblue
  geom_bar(stat = "identity", fill = "skyblue")

ggplot(mtcars_by_cyl, aes(x = cyl, y = mean_wt)) +
  geom_col(aes(width = prop), fill = "skyblue") +
  # Add an errorbar layer
  geom_errorbar(
    # ... at mean weight plus or minus 1 std dev
    aes(ymin = mean_wt - sd_wt, ymax = mean_wt + sd_wt),
    # with width 0.1
    width = 0.1
  )
