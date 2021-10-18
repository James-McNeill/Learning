# Factors
# The term factor refers to a statistical data type used to store categorical variables. 
# The difference between a categorical variable and a continuous variable is that a categorical variable 
# can belong to a limited number of categories. A continuous variable, on the other hand, 
# can correspond to an infinite number of values.

# Sex vector
sex_vector <- c("Male", "Female", "Female", "Male", "Male")

# Convert sex_vector to a factor - function will reduce the vector to a unique set
factor_sex_vector <- factor(sex_vector)

# Print out factor_sex_vector
factor_sex_vector
