'''
The code shows what was used to create the pyspark output
To get this code output had to write the code in the terminal : repl:~$ cat /home/repl/spark-script.py
In order to run the code to get the queried results we used : spark-submit --master local[4] /home/repl/spark-script.py
'''
from pyspark.sql import SparkSession

if __name__ == "__main__":
    spark = SparkSession.builder.getOrCreate()
    athlete_events_spark = (spark
        .read
        .csv("/home/repl/datasets/athlete_events.csv",
             header=True,
             inferSchema=True,
             escape='"'))

    athlete_events_spark = (athlete_events_spark
        .withColumn("Height",
                    athlete_events_spark.Height.cast("integer")))

    print(athlete_events_spark
        .groupBy('Year')
        .mean('Height')
        .orderBy('Year')
        .show())
