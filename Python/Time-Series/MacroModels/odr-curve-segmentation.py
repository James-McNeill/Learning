# Creating the ODR curve by various feature segments
# Aim is to perform t-test's to compare the variance of the segment curves

# Create connection to AWS Athena
# Import utilities, PyAthena and other modules
import pandas as pd
import numpy as np
import datetime
import time
import sys
import os
from pathlib import Path

# Print current working directory location
print(os.getcwd()+'/')
# Connect to the repo package folder to use in this Notebook
sys.path.append("/home/ec2-user/SageMaker/s3-user-bucket/..../")
# Import the sub-packages
from stmd import utils as stmd

# Set default options for the notebook
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.options.display.float_format = '{:,.4f}'.format # Comma and four decimal places for float variables

# Create the pandas cursor object
pandas_cursor = stmd.create_cursor()

# Input data testing
