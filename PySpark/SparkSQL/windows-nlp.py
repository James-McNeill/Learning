# Windows functions with NLP data

# A. Load the data
# 1. Load the dataframe
df = spark.read.load('sherlock_sentences.parquet')

# Filter and show the first 5 rows
df.where('id > 70').show(5, truncate=False)

# 2. Split and explode text
# Split the clause column into a column called words 
split_df = clauses_df.select(split('clause', ' ').alias('words'))
split_df.show(5, truncate=False)

# Explode the words column into a column called word 
exploded_df = split_df.select(explode('words').alias('word'))
exploded_df.show(10)

# Count the resulting number of rows in exploded_df
print("\nNumber of rows: ", exploded_df.count())

# B. Moving window analysis
# 1. Creating context window features
# Word for each row, previous two and subsequent two words
query = """
SELECT
part,
LAG(word, 2) OVER(PARTITION BY part ORDER BY id) AS w1,
LAG(word, 1) OVER(PARTITION BY part ORDER BY id) AS w2,
word AS w3,
LEAD(word, 1) OVER(PARTITION BY part ORDER BY id) AS w4,
LEAD(word, 2) OVER(PARTITION BY part ORDER BY id) AS w5
FROM text
"""
spark.sql(query).where("part = 12").show(10)

# 2. Repartition the data. Ensures that the data for each chapter is contained on the same node (machine)
# Repartition text_df into 12 partitions on 'chapter' column
repart_df = text_df.repartition(12, 'chapter')

# Prove that repart_df has 12 partitions
repart_df.rdd.getNumPartitions()

# C. Finding common word sequences
# 1. Find the top 10 sequences of five words
query = """
SELECT w1, w2, w3, w4, w5, COUNT(*) AS count FROM (
   SELECT word AS w1,
   LEAD(word, 1) OVER(PARTITION BY part ORDER BY id) AS w2,
   LEAD(word, 2) OVER(PARTITION BY part ORDER BY id) AS w3,
   LEAD(word, 3) OVER(PARTITION BY part ORDER BY id) AS w4,
   LEAD(word, 4) OVER(PARTITION BY part ORDER BY id) AS w5
   FROM text
)
GROUP BY w1, w2, w3, w4, w5
ORDER BY count DESC
LIMIT 10 """
df = spark.sql(query)
df.show()

# 2. Unique 5-tuples sorted in descending order
query = """
SELECT DISTINCT w1, w2, w3, w4, w5 FROM (
   SELECT word AS w1,
   LEAD(word,1) OVER(PARTITION BY part ORDER BY id ) AS w2,
   LEAD(word,2) OVER(PARTITION BY part ORDER BY id ) AS w3,
   LEAD(word,3) OVER(PARTITION BY part ORDER BY id ) AS w4,
   LEAD(word,4) OVER(PARTITION BY part ORDER BY id ) AS w5
   FROM text
)
ORDER BY w1 DESC, w2 DESC, w3 DESC, w4 DESC, w5 DESC 
LIMIT 10
"""
df = spark.sql(query)
df.show()

# 3. Most frequent 3-tuples per chapter
subquery = """
SELECT chapter, w1, w2, w3, COUNT(*) as count
FROM
(
    SELECT
    chapter,
    word AS w1,
    LEAD(word, 1) OVER(PARTITION BY chapter ORDER BY id ) AS w2,
    LEAD(word, 2) OVER(PARTITION BY chapter ORDER BY id ) AS w3
    FROM text
)
GROUP BY chapter, w1, w2, w3
ORDER BY chapter, count DESC
"""

# Take the output from the subquery and produce a follow up query
query = """
SELECT chapter, w1, w2, w3, count FROM
(
  SELECT
  chapter,
  ROW_NUMBER() OVER (PARTITION BY chapter ORDER BY count DESC) AS row,
  w1, w2, w3, count
  FROM ( %s )
)
WHERE row = 1
ORDER BY chapter ASC
""" % subquery

spark.sql(query).show()
