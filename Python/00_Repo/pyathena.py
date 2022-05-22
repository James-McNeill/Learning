'''
Creating the connection to the S3 bucket for the Athena queries. The cursor and pandas_cursor allows for the remote connection to the 
staging environment. In essence, the method creates an ODBC connection to the athena_results being stored and allows for pass through 
queries to be created and the output to be displayed within AWS Sagemaker
'''

# Import utlities python package.
!pip install pyathena

# S3 bucket
s3_bucket = "bucket-eu-west-...-user"

# Working folder within S3 bucket – this is the path of where you are writing your code
prefix = ".../athena_results"

# Athena sql query results will be stored here.
s3_staging_dir = "s3://{}/{}/{}".format(s3_bucket,prefix,"athena-query-result") 

region_name = 'eu-west-1' # Region name
work_group = '...' # Work Group name.

# Setup the cursor
cursor = connect(s3_staging_dir = s3_staging_dir,
                    region_name = region_name
                ,work_group=work_group).cursor()

# Setup the pandas_cursor
pandas_cursor = connect(s3_staging_dir = s3_staging_dir,
                region_name = region_name,
            work_group=work_group).cursor(PandasCursor)

# Athena SQL query
'''
The execute method of the pandas_cursor method allows for the creation of the pass through SQL query. Additional options were included to account 
for the missing values which impacted the pandas DataFrame. 
'''
# Run the SQL query string
sql_data = pandas_cursor.execute("""
                                SELECT *  
                                FROM db.table limit 10
                                """
                                , keep_default_na=True
                                #, na_values=[""]
                                ).as_pandas()
sql_data.sample(5)
