# More distributions and central limit theorem

# Normal distribution
# Probability of deal < 7500
pnorm(7500, mean = 5000, sd = 2000)

# Probability of deal > 1000
pnorm(1000, mean = 5000, sd = 2000, lower.tail = FALSE)

# Probability of deal between 3000 and 7000
pnorm(7000, mean = 5000, sd = 2000) - pnorm(3000, mean = 5000, sd = 2000)

# Calculate amount that 75% of deals will be more than
qnorm(0.25, mean = 5000, sd = 2000)

# Calculate new average amount
new_mean <- 5000 * 1.2

# Calculate new standard deviation
new_sd <- 2000 * 1.3

# Simulate 36 sales
new_sales <- new_sales %>% 
  mutate(amount = rnorm(36, mean = new_mean, sd = new_sd))

# Create histogram with 10 bins
ggplot(new_sales, aes(amount)) +
  geom_histogram(bins = 10)

# Set seed to 104
set.seed(104)

# Sample 20 num_users from amir_deals and take mean
sample(amir_deals$num_users, size = 20, replace = TRUE) %>%
  mean()

# Repeat the above 100 times. replicate can be used to repeat the process steps multiple times and return the summary statistic
sample_means <- replicate(100, sample(amir_deals$num_users, size = 20, replace = TRUE) %>% mean())

# Create data frame for plotting
samples <- data.frame(mean = sample_means)

# Histogram of sample means
ggplot(samples, aes(mean)) +
  geom_histogram(bins = 10)

# The mean of means
# Set seed to 321
set.seed(321)

# Take 30 samples of 20 values of num_users, take mean of each sample
sample_means <- replicate(30, sample(all_deals$num_users, 20) %>% mean())

# Calculate mean of sample_means
mean(sample_means)

# Calculate mean of num_users in amir_deals
mean(amir_deals$num_users)

# Poisson distribution
# Probability of 5 responses. lambda = average within a defined time period
dpois(5, lambda = 4)

# Probability of 5 responses from coworker
dpois(5, lambda = 5.5)

# Probability of 2 or fewer responses
ppois(2, lambda = 4)

# Probability of > 10 responses
ppois(10, lambda = 4, lower.tail = FALSE)

# Exponential distribution. Continuous time of poisson distribution
# Probability response takes < 1 hour
pexp(1, rate = (1/2.5))

# Probability response takes > 4 hours
pexp(4, rate = (1 / 2.5), lower.tail = FALSE)

# Probability response takes 3-4 hours
pexp(4, rate = (1 / 2.5)) - pexp(3, rate = (1 / 2.5))

