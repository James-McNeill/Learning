# Install the package to use
pip install pyarrow
'''
Steps to take when aiming to import the parquet files from S3 bucket into AWS Sagemaker Jupyter notebook instance. 
Alternative method could involve the use of AWS Wrangler
'''
import pyarrow.parquet as pq
import pandas as pd
table = pq.read_table('s3-user-bucket/...dataset')
df = table.to_pandas()
df.head()
