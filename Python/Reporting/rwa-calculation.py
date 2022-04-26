# Import libraries
from scipy.stats import norm 
import pandas as pd
import random

# Create sample using code from module "sample-dataframe.py"
df = create_sample()

# First attempt at the RWA calculation optimisation
def calRWAs(df):
    df['K'] = ((((1/(1-df['rho']))**(1/2))*df['dt_pd'].apply(norm.ppf) + ((df['rho']/(1-df['rho']))**(1/2))*norm.ppf(0.999)).apply(norm.cdf) - df['dt_pd']) * df['perf_dt_lgd']
    df['perf_rwa'] =  df['K'] * 12.5 * df['perf_ead'] * 1.06

# Using Jupyter magic function to check timing
%%timeit
calRWAs(df)

# Second calculation attempt
def calRWAsV2(rho, pd, p_dt_lgd, p_ead):
    K = ( norm.cdf(((1.0/(1.0-rho))**(1.0/2.0))*norm.ppf(pd) + ((rho/(1.0-rho))**(1.0/2.0))*norm.ppf(0.999)) - pd) * p_dt_lgd
    perf_rwa =  K * 12.5 * p_ead * 1.06

df = create_sample()

%%timeit
df.apply(lambda x : calRWAsV2(x['rho'], x['dt_pd'], x['perf_dt_lgd'], x['perf_ead']), axis=1)

%%timeit
df['dt_pd'].apply(norm.ppf)

df = create_sample()

def calRWAsV3(df):
    df['a'] = ((1/(1-df['rho']))**(1/2))*df['dt_pd'].apply(norm.ppf)
    df['b'] = ((df['rho']/(1-df['rho']))**(1/2))*norm.ppf(0.999)
    df['K'] = ((df['a'] + df['b']).apply(norm.cdf) - df['dt_pd']) * df['perf_dt_lgd']
    df['perf_rwa'] =  df['K'] * 12.5 * df['perf_ead'] * 1.06  

%%timeit
calRWAsV3(df)

df = create_sample()

def calRWAsV4(rho, pd, p_dt_lgd, p_ead):
    a = ((1.0/(1.0-rho))**(1.0/2.0))*norm.ppf(pd)
    b = ((rho/(1.0-rho))**(1.0/2.0))*norm.ppf(0.999)
    K = ( norm.cdf(a + b) - pd) * p_dt_lgd
    perf_rwa =  K * 12.5 * p_ead * 1.06

%%timeit
df['perf_rwa'] = df.apply(lambda x : calRWAsV4(x['rho'], x['dt_pd'], x['perf_dt_lgd'], x['perf_ead']), axis=1)

df.head()

df.dtypes

def calRWAsV5(rho, pd, p_dt_lgd, p_ead):
    a = ((1.0/(1.0-rho))**(1.0/2.0))*norm.ppf(pd)
    b = ((rho/(1.0-rho))**(1.0/2.0))*norm.ppf(0.999)
    K = ( norm.cdf(a + b) - pd) * p_dt_lgd
    perf_rwa =  K * 12.5 * p_ead * 1.06
    return perf_rwa

%%timeit
df['rwa'] = calRWAsV5(df['rho'], df['dt_pd'], df['perf_dt_lgd'], df['perf_ead'])

df1 = create_sample(1000000)

%%timeit
df1['rwa'] = calRWAsV5(df1['rho'], df1['dt_pd'], df1['perf_dt_lgd'], df1['perf_ead'])
