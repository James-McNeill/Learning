# Install required packages
# install.packages("text") # this is only from R > V4.0
# install.packages("textTinyR")

# Load required libraries
# library(text)
library(tm)
library(textTinyR)

# TRY this one out https://www.rdatamining.com/examples/text-mining

# Preprocessing and vectorization
user_question <- "What are the benefits of exercise?"
text_database <- c("Regular exercise has numerous health benefits.",
                   "Exercise improves cardiovascular health.",
                   "The benefits of physical activity include weight loss.")

corpus <- Corpus(VectorSource(c(user_question, text_database)))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("en"))
corpus <- tm_map(corpus, stripWhitespace)

dtm <- DocumentTermMatrix(corpus)
user_vector <- dtm[1, ]
database_vectors <- dtm[-1, ]

# Similarity calculation - this element doesn't appear to be working, have to review
similarity_scores <- textTinyR::COS_TEXT(user_vector, database_vectors)

# Ranking and retrieval
results <- data.frame(Similarity = similarity_scores, Text = text_database)
results <- results[order(results$Similarity, decreasing = TRUE), ]

print(results)
