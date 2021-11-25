"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - A utils module that connects to all of the input modules. Allows for     |
#         this master module to be imported and the methods to be used from it.    |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@outlook.com"
__status__ = "Test"

# Example: import utils as utl
# This code will import all of the modules connected to this package

# Import sub packages
from ._awsathena import (create_cursor)
from ._transformations import (transformations)
from ._stationarity import (stationarity)
from ._doddata import (build_dod)
from ._correlation import (Correlation)
from ._single_factor import (SingleFactor)
from ._multi_factor import (MultiFactor)

from ._methods import (dict_to_list, column_exist, check_var_list, create_date_list)
from ._historicdata import (HistoricData)
