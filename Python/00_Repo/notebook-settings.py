# Allows the user to set the options available within the Pandas package. The options outlined relate to the DataFrame settings that are displayed
# Setup DataFrame settings for the Jupyter Notebook
pd.set_option('display.max_columns', 3000)
pd.set_option('display.max_rows', 300)

# Adjust options for displaying the float columns
pd.options.display.float_format = '{:,.2f}'.format

# Display all of the outputs from a notebook cell. This code will allow for all methods used within a cell block to be displayed instead of just the 
# final one. For example; df.head(), df.info(), df.describe(), can all be run together
from IPython.core.interactiveshell import InteractiveShell
InteractiveShell.ast_node_interactivity = "all"
