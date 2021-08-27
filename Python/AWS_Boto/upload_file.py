# A s3 client connection has been setup

# Upload final_report.csv to gid-staging
s3.upload_file(Bucket='gid-staging',
              # Set filename and key
               Filename='final_report.csv', 
               Key='2019/final_report_01_01.csv')

# Get object metadata and print it
response = s3.head_object(Bucket='gid-staging', 
                       Key='2019/final_report_01_01.csv')

# Print the size of the uploaded object - a dictionary is returned
print(response['ContentLength'])


# Uploading files and controlling for access restrictions - showing different methods that allow the public to
# access certain previously viewed private files. This example highlights making one file public

# Upload the final_report.csv to gid-staging bucket
s3.upload_file(
  # Complete the filename
  Filename='./final_report.csv', 
  # Set the key and bucket
  Key='2019/final_report_2019_02_20.csv', 
  Bucket='gid-staging',
  # During upload, set ACL to public-read. Allows public users to access the file but only the files highlighted
  ExtraArgs = {
    'ACL': 'public-read'})

# Second example: automatically making multiple files public

# List only objects that start with '2019/final_'
response = s3.list_objects(
    Bucket='gid-staging', Prefix='2019/final_')

# Iterate over the objects
for obj in response['Contents']:

    # Give each object ACL of public-read
    s3.put_object_acl(Bucket='gid-staging', 
                      Key=obj['Key'], 
                      ACL='public-read')
    
    # Print the Public Object URL for each object
    print("https://{}.s3.amazonaws.com/{}".format('gid-staging', obj['Key']))
