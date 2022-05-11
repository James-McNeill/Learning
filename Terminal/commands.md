Using the Terminal in AWS Sagemaker to create a zip file containing the development code / files	
	
Open Terminal	
	
- dir:  shows the current folders in the directory
- pwd:	shows the current working directory
- cd:	change directory
- zip:	zip the files required

Creating a zipped folder	
steps	
1. change directory	
 - SageMaker is the directory to go into
 - cd /SageMaker/s3-user-bucket/…/	
2. Move to the directory folder required. For the macro models this would have been into the STF folder
 - zip -r ZipFolder.zip .	
	- `-r is the command, 
 	- ZipFolder.zip is the zipped folder name and 
  	- . Is used to select all items in the current folder
