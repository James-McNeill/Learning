# Generate presigned_url for the uploaded object. Allows access to a private file via
# a URL for a set time. In this example the file will be available for 1 hour
share_url = s3.generate_presigned_url(
  # Specify allowable operations
  ClientMethod='get_object',
  # Set the expiration time
  ExpiresIn=3600,
  # Set bucket and shareable object's name
  Params={'Bucket': 'gid-staging','Key': 'final_report.csv'}
)

# Print out the presigned URL
print(share_url)


# Loading multiple files into a DataFrame for analysis. Objective is to take multiple
# files that are stored within a S3 bucket and concat them into one DataFrame.
df_list =  [ ] 

# All objects contained in the Bucket are stored within the response variable
for file in response['Contents']:
    # For each file in response load the object from S3
    obj = s3.get_object(Bucket='gid-requests', Key=file['Key'])
    # Load the object's StreamingBody with pandas
    obj_df = pd.read_csv(obj['Body'])
    # Append the resulting DataFrame to list
    df_list.append(obj_df)

# Concat all the DataFrames with pandas
df = pd.concat(df_list)

# Preview the resulting DataFrame
df.head()

# Review accessing private objects in S3
# download then open
s3.download_file() 
# Open directly
s3.get_object()
# Generate presigned URL
s3.generate_presigned_url()
