%lprun	
# Run a line by line review of the code being processed within a function to understand where the different bottlenecks are when running the code. 
# Aims to retrieve the time spent on each line	

# In the Ipython shell run
%load_ext line_profiler
>>> puts the magic function into memory
%lprun -f function_name function_name(pparam1, kparam1)

# Have to inculde -f to show that it is a function to be reviewed, the function_name is then provided along with a version of what is required to run the function. 
# Then this will test an implementation of the function"
