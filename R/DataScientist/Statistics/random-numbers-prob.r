# Working with random numbers and probability

# Calculating probabilities
# Calculate probability of picking a deal with each product
amir_deals %>%
  count(product) %>%
  mutate(prob = n / sum(n))
