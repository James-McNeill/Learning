# Reviewing PySpark SQL query plans

# Run explain on text_df
text_df.explain()

# Run explain on "SELECT COUNT(*) AS count FROM table1" 
spark.sql("SELECT COUNT(*) AS count FROM table1").explain()

# Run explain on "SELECT COUNT(DISTINCT word) AS words FROM table1"
spark.sql("SELECT COUNT(DISTINCT word) AS words FROM table1").explain()
