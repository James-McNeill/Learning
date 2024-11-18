# Text mining and word cloud
# Article reviewed
# http://www.sthda.com/english/wiki/text-mining-and-word-cloud-fundamentals-in-r-5-simple-steps-you-should-know

# Wordcloud2 is also available. Future review https://cran.r-project.org/web/packages/wordcloud2/vignettes/wordcloud.html

# Load required libraries
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(tidyverse)

# Load data
RegulatoryNewsRepo <- read_csv("inputfile.csv")
View(RegulatoryNewsRepo)

# Load data as a corpus
docs <- Corpus(VectorSource(RegulatoryNewsRepo))

# Inspect document contents
inspect(docs)

# Text transformation
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removePunctuation)
# docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("en"))
docs <- tm_map(docs, stripWhitespace)

# Build a term-document matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq = v)
head(d, 10)

# Generate the word cloud
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words = 200, random.order = FALSE, 
          colors = brewer.pal(8, "Dark2"))

# Plot word frequencies
top_words <- d %>%
  arrange(desc(freq)) %>%
  head(10)
  
ggplot(data = top_words, aes(x = word, y = freq)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = freq), color = "white")
