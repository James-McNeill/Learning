# dask dataframe

'''
A more efficient method to apply is to take the dask.dataframe method. The previous example api using the 
multiprocessor is very low level. Whereas the dask api is at a higher level and can apply the same 
functionality with less code.
'''
import dask.dataframe as dd

# Set the number of pratitions
athlete_events_dask = dd.from_pandas(athlete_events, npartitions = 4)

# Calculate the mean Age per Year
print(athlete_events_dask.groupby('Year').Age.mean().compute())

'''
Similar API to the pandas dataframe. Lazy operations are in place. Note that .head() and .tail() methods 
do not require the compute() method to work. Can build a delayed pipeline, whereby multiple datasets are 
pulled into the dataframe and calculations are created but the process doesn't consume any memory until 
the compute() method is used. There are some methods not available in the dask dataframe API, e.g. sorting 
and importing certain file formats (.xls, .zip, .gz)
'''
# visualize the pipeline of tasks being completed in parallel
wendy_diff.visualize(rankdir='LR')

'''
The visualise method will a workflow of the computations that are taking place within the process that was created. 
For the example previously, calling result.visualise() would show the work flow for the process steps. Each process 
step would be applied in parallel to help with computations.
'''
