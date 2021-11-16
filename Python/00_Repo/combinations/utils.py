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

# Import the necessary packages
import sys
import os
import time

# Import sub packages
from ._awsathena import (create_cursor)
from ._historicdata import (HistoricData)
from ._datasetimport import (datasetImport)
from ._transitionrates import (transition)
from ._methods import (dict_to_list, column_exist, check_var_list, create_date_list)
from ._unique import (duplicateData)
from ._mergedData import *
