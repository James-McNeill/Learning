# Create sample DataFrame
import pandas as pd

def create_sample(num_of_rows=10000):
    num_of_rows = num_of_rows # number of records to generate.
    data = {
        'rho' : [0.04 for x in range(num_of_rows)],
        'dt_pd' : [0.02 for x in range(num_of_rows)],
        'perf_dt_lgd' : [0.7 for x in range(num_of_rows)],
        'nperf_dt_lgd' : [0.8 for x in range(num_of_rows)],
        'nperf_be_lgd' : [0.75 for x in range(num_of_rows)],
        'perf_ead' : [10000.0 for x in range(num_of_rows)],
        'nperf_ead' : [10000.0 for x in range(num_of_rows)]
    }
    df = pd.DataFrame(data)
    print("Shape : {}".format(df.shape))
    print("Type : \n{}".format(df.dtypes))
    df.head(5) # to display n number of records.
    return df
