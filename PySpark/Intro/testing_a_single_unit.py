from pyspark.sql import SparkSession
from pyspark.sql.functions import Row

spark = SparkSession.builder.getOrCreate()

# Single test to check if the price comes back as expected
def test_calculate_unit_price_in_euro():    
  record = dict(price=10,                  
                quantity=5,                  
                exchange_rate_to_euro=2.)    
  df = spark.createDataFrame([Row(**record)])    
  result = calculate_unit_price_in_euro(df)
  
  expected_record = Row(**record, unit_price_in_euro=4.)    
  expected = spark.createDataFrame([expected_record])
  
  assert DataFrameEqual(result, expected)
