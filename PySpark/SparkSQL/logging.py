# Logging with PySpark

# Import module
import logging
logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                    format='%(levelname)s - %(message)s')

# Log columns of text_df as debug message
logging.debug("text_df columns: %s", text_df.columns)

# Log whether table1 is cached as info message
logging.info("table1 is cached: %s", spark.catalog.isCached(tableName="table1"))

# Log first row of text_df as warning message
logging.warning("The first row of text_df:\n %s", text_df.first())

# Log selected columns of text_df as error message
logging.error("Selected columns: %s", text_df.select("id", "word"))

# Working with logging statements
# Uncomment the 5 statements that do NOT trigger text_df
logging.debug("text_df columns: %s", text_df.columns)
logging.info("table1 is cached: %s", spark.catalog.isCached(tableName="table1"))
# logging.warning("The first row of text_df: %s", text_df.first())
logging.error("Selected columns: %s", text_df.select("id", "word"))
logging.info("Tables: %s", spark.sql("show tables").collect())
logging.debug("First row: %s", spark.sql("SELECT * FROM table1 limit 1"))
# logging.debug("Count: %s", spark.sql("SELECT COUNT(*) AS count FROM table1").collect())
