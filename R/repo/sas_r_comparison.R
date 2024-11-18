# R coding compared to SAS
# Using base R logic. 
# Link to article http://rstudio-pubs-static.s3.amazonaws.com/271369_5e95e7c2114245879499dc05b04dc2dd.html

# overview on library, place code in console
library(help = "datasets")

# import data for review. Had to convert the imported table into a dataframe to work with methods that followed.
# issue was that the original table was understood to represent an atomic vector and had to be transformed.
tb <- datasets::Titanic
is.atomic(tb)
df <- as.data.frame(tb)

# Details on data
View(tb)
class(tb)
View(df)
class(df)

# 1) Select observations. When working with the selection criteria the square brackets operate by [row,column]
female_data <- df[df$Sex=="Female",]

# 2) Select variables. Can include feature names or position of feature
red_data <- df[, c('Class', 'Survived', 'Freq')]
red_data1 <- df[, c(1:3)]

# 3) Transformations
add_data <- df
add_data$total <- df$Freq + 10
add_data$total_log <- log(add_data$total)

# 4) Conditional transformations
add_data$Grade <- ifelse(add_data$total > add_data$Freq, 1, 0)

# 5) Rename
library(reshape)
add_data <- rename(add_data, c(total = "total2"))

# 6) Stacking data
high_data <- df[df$Freq > 100,]
low_data <- df[df$Freq == 0,]
comb_data <- rbind(low_data, high_data) # For columns can use cbind()

# 7) Join data. method is merge(df1, df2, by="id")

# 8) Data analysis
library(foreign)
library(Hmisc)
library(prettyR)
# Descriptive stats and frequencies. 
summary(df)

# Means, freqencies & percents 
describe(df)

# Frequencies & percents
freq(df)

# # Pearson correlations.
# cor(data.frame(q1,q2,q3,q4),method="pearson")
# 
# # Spearman correlations.
# cor(data.frame(q1,q2,q3,q4),method="pearson")
