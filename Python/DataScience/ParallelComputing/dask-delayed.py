# dask delayed

'''
In order to help avoid putting all computations into memory immediately, a generator can be used. The generator 
performs lazy processing, i.e. the method is not put into memory until it is required to be applied. When applied 
the steps are processing in a stepwise method. 

By using dask.delayed, this helps to remove the need to worry about creating and maintaining generators as the 
method applies lazy / delayed processing. delayed can also be applied as a decorator for methods (UDF's).
'''

# Pipeline of functions to be called
# Define count_flights
@delayed
def count_flights(df):
    return len(df)

# Define count_delayed
@delayed
def count_delayed(df):
    return (df['DEP_DELAY']>0).sum()

# Define pct_delayed
@delayed
def pct_delayed(n_delayed, n_flights):
    return 100 * sum(n_delayed) / sum(n_flights)

'''
Applying the dask delayed functions that were created in the previous row. The methods are used each time to 
build dask delayed objects. These objects will not be applied until the compute() method is called.
'''
# Loop over the provided filenames list and call read_one: df
for file in filenames:
    df = read_one(file)

    # Append to n_delayed and n_flights
    n_delayed.append(count_delayed(df))
    n_flights.append(count_flights(df))

# Call pct_delayed with n_delayed and n_flights: result
result = pct_delayed(n_delayed, n_flights)

# Print the output of result.compute()
print(result.compute())
