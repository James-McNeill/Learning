"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Connect to the AWS Athena environment                                    |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@outlook.com"
__status__ = "Test"

# Import utilities, PyAthena and other modules
import time
import sys

# check and Install pyathena package.
util.check_and_install_python_mod("pyathena") # module to connect AWS Sagemaker to AWS Athena
util.check_and_install_python_mod("openpyxl") # module can be used to run the pd.read_excel() method

# Import modules from pyathena
from pyathena import connect
from pyathena.pandas.cursor import PandasCursor

# Create a cursor instance
def create_cursor():
    """
    Create a cursor instance that allows for connection to AWS Athena.
    s3_staging_dir: Directory for user to store Athena query results
    region_name: AWS region for the user session
    work_group: Reference required to run queries within AWS Athena
    """
    s3_staging_dir = 's3://bucket-eu-west-1-...../.../athena-query-result/..' # connection string to the S3 folder where the query results can be stored
    region_name = 'eu-west-1'
    work_group = '...' # workgroup that is connected to the AWS Athena account connection
    pandas_cursor = connect(s3_staging_dir = s3_staging_dir,  region_name = region_name, work_group=work_group).cursor(PandasCursor)
    return pandas_cursor
