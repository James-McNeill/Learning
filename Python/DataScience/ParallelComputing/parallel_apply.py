# parallel_apply

'''
Helps to spread the task efficiently across multiple processing units. The reduced memory requirements on 
each processing unit can improve processing power for the overall task. However, need to be mindful that the 
computational memory required to keep track of progress and bring everything together can offset the benefits 
of multiprocessing. Therefore, we need to fully understand the task at hand and whether multiprocessing is 
the most efficient method to use.
'''
import multiprocessor.Pool
# Function to apply a function over multiple cores
@print_timing
def parallel_apply(apply_func, groups, nb_cores):
    with Pool(nb_cores) as p:
        results = p.map(apply_func, groups)
    return pd.concat(results)

# Decorator helps to compute processing times for the following applications of the function with different number of cores
parallel_apply(take_mean_age, athlete_events.groupby('Year'), 1)
parallel_apply(take_mean_age, athlete_events.groupby('Year'), 2)
parallel_apply(take_mean_age, athlete_events.groupby('Year'), 4)
