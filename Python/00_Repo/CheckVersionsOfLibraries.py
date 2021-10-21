# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# 1. Start Python and check versions

#%% Check the versions of libraries
# Python version
import sys
print('Python: {}'.format(sys.version))
# scipy
import scipy
print('scipy: {}'.format(scipy.__version__))
# numpy
import numpy
print('numpy: {}'.format(numpy.__version__))
# matplotlib
import matplotlib
print('matplotlib: {}'.format(matplotlib.__version__))
# pandas
import pandas
print('pandas: {}'.format(pandas.__version__))
# scikit-learn
import sklearn
print('sklearn: {}'.format(sklearn.__version__))

#%% Try to put this code into a function??
#def lib_review(libref):
#    import libref
#    print('libref: {}'.format(libref.__version__))
#    return librefout

#lib_review(scipy)