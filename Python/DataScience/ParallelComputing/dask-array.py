# dask array

'''
Works very similar to numpy.array. In order to gain more parallel processing the array has to be converted into chunks.
'''
# Call da.from_array():  energy_dask
energy_dask = da.from_array(energy, chunks=len(energy) // 4)

# Print energy_dask.chunks
print(energy_dask.chunks)

# Print Dask array average and then NumPy array average
print(energy_dask.mean().compute())
print(energy.mean())

'''
Showing how similar operations can be performed with numpy arrays
'''
# Reshape allows us to reshape a one dimensional array to a 3d
# Reshape load_recent to three dimensions: load_recent_3d
load_recent_3d = load_recent.reshape((3,365,96))

# Reshape load_2001 to three dimensions: load_2001_3d
load_2001_3d = load_2001.reshape((1,365,96))

# Subtract the load in 2001 from the load in 2013 - 2015: diff_3d
diff_3d = load_recent_3d - load_2001_3d

# Print the difference each year on March 2 at noon
print(diff_3d[:, 61, 48])
