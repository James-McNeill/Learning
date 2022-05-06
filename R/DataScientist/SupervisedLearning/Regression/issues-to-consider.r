# Regression model issues to consider

# When building models there are a number of issues to be aware of

# Categorical variables
# Creating dummy variables using model.matrix()
# Call str on flowers to see the types of each column
str(flowers)

# Use unique() to see how many possible values Time takes
unique(flowers$Time)

# Build and print a formula to express Flowers as a function of Intensity and Time: fmla
(fmla <- as.formula("Flowers ~ Intensity + Time"))

# Use fmla and model.matrix to see how the data is represented for modeling
mmat <- model.matrix(fmla, data = flowers)

# Examine the first 20 lines of flowers
head(flowers, n = 20)

# Examine the first 20 lines of mmat
head(mmat, n = 20)
