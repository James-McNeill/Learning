"""
#----------------------------------------------------------------------------------+
#      This python client gives you an ability to:                                 |
#       - Import the datasets from AWS Athena connection               |
#----------------------------------------------------------------------------------+
"""
__author__ = "James Mc Neill"
__version__ = "1.0"
__maintainer__ = "James Mc Neill"
__email__ = "jmcneill06@outlook.com"
__status__ = "Test"

# Import packages
import pandas as pd
import numpy as np
import datetime
from operator import itemgetter

# Import sub-packages
from ._awsathena import (create_cursor)

# Initiate the pandas cursor connection
pandas_cursor = create_cursor()

class datasetImport:
    # Constructor
    def __init__(self):
        self.varList = ['accg_unit_id','prod_type_code','product','rwa_calc_type'
                           ,'dr_led_exp','drv_ead_dt_adj','drv_pd','drv_pool_pd_adj','drv_pool_rwa'
                          ,'drv_pool_el','drv_pool_lgd_adj','drv_pool_lgd_dt_adj',
                       'drv_int_accrued']
        self.strIrb = ",".join(self.varList)
        self.impVarList = varList = ['account_no','prod','prodsplit','report_exclude_flag'
                                   ,'post_adj_stage','ead','interest_in_suspense_cum'
                                   ,'rec_asset_raised','pst_adj_ecl_minus_iis']
        self.strImp = ",".join(self.impVarList)
        #print(f'{self.varList}')
        #print(f'{self.strIrb}')
        
    # Method - IRB data review
    def irbData(self,databaseName,tableName):
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT {self.strIrb}
                                        FROM {databaseName}.{tableName}
                                        WHERE brand in ('K','E','X','Z','U')
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset not present')
        return df
    
    # Method - Impairment data review
    def impData(self,databaseName,tableName):
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT {self.strImp}
                                        FROM {databaseName}.{tableName}
                                        WHERE prod != 'PCC' and report_exclude_flag = 'N'
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset not present')
        return df
    
    # Method - IFRS 9 12m PD data review
    def impPD(self, databaseName,tableName,channel,product):
        """
        impPD('reg_mart','t_ifrs9_pln_account_2019_11','Personal','Loans')
        """
        # Initialise tables
        df = None
        try:
            df = pandas_cursor.execute(
                                        f"""
                                        SELECT t1.accg_unit_id
                                            ,t1.pfolio
                                            ,t1.ifrs9_12mth_pd_curr_mes as i9_12m_pd
                                            ,'{channel}' as channel_type
                                            ,'{product}' as product_type
                                        FROM {databaseName}.{tableName} t1
                                        WHERE substr(pfolio,1,3) in ('UBS','UFA','UBT')
                                        """
                                        , keep_default_na=True
                                        , na_values=[""]
                                        ).as_pandas()
        except:
            print(f'{tableName} dataset missing')
        return df
    
    # Combine the IFRS 9 12m PD data sets
    def i9_12m_pd(self, date):
        """
        Combine the four IFRS 9 12m PD datasets
        """
        # Output dataframe
        df = None
        
        # Input values
        dfs = ['df' + str(x) for x in range(1,5)]
        databaseList = ['reg_mart','reg_mart','reg_mart','reg_mart']
        tableList = ['t_ifrs9_pln_account_'+date,'t_ifrs9_pca_account_'+date,'t_ifrs9_bln_account_'+date,'t_ifrs9_bca_account_'+date]
        channelList = ['Personal','Personal','Business Direct','Business Direct']
        productList = ['Loans','MTAs','Loans','MTAs']
        
        # Create dictionary of dataframes
        list_of_dfs = {}
        for df, db, tb, ch, pl  in zip(dfs,databaseList,tableList,channelList,productList):
            begin_time = datetime.datetime.now()
            print(f'Start time: {begin_time}, {df} = {db} = {tb}')
            list_of_dfs[df] = self.impPD(db,tb,ch,pl)
            print(f'Run time: {datetime.datetime.now() - begin_time}')
        
        # Extracting the key value pairs
        df1, df2, df3, df4 = itemgetter('df1','df2','df3','df4')(list_of_dfs)
        
        # Concatenate the four IFRS 9 12m PD model datasets
        frames = [df1, df2, df3, df4]
        df = pd.concat(frames)
        return df
    
    # Method - derived variables to be added to datasets
    def derived_variables(self, df, model=None):
        if model == 'IRB':
            df['channel_type'] = np.where(df['prod_type_code'].str[0]=='B','Business Direct','Personal')
            df['product_type'] = np.where(df['product'].isin(['F','L']),'Loans','MTAs')
            df['irb_approach'] = np.where(df['rwa_calc_type']=='IRB','AIRB','STD')
            df['default_flag'] = np.where(df['drv_pool_pd_adj']<1,0,1)
        elif model == 'IMP':
            df['channel_type'] = np.where(df['prod'].isin(['BCA','BLN']),'Business Direct','Personal')
            df['product_type'] = np.where(df['prod'].isin(['BLN','PLN']),'Loans','MTAs')
            df['default_flag'] = np.where(df['post_adj_stage']<3,0,1)
        else:
            print('Derived variables not added')
        return df
    
    # Method - summary statement for high level checks
    def summary_channel_irb(self, df):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        """
        df_s1 = df.groupby(['channel_type']).agg(
                                    {
                                        "accg_unit_id":['count']
                                        ,"dr_led_exp":['sum']
                                        ,"drv_ead_dt_adj":['sum']
                                        ,"drv_pool_el":['sum']
                                        ,"drv_pool_rwa":['sum']
                                    })
        df_s1.columns = ["_".join(x) for x in df_s1.columns.ravel()]
        return df_s1
    
    # Method - summary statement for high level checks at a default flag level
    def summary_irb_default(self, df):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        """
        df_s1 = df.groupby(['channel_type','default_flag']).agg(
                                    {
                                        "accg_unit_id":['count']
                                        ,"dr_led_exp":['sum']
                                        ,"drv_ead_dt_adj":['sum']
                                        ,"drv_pool_el":['sum']
                                        ,"drv_pool_rwa":['sum']
                                    })
        df_s1.columns = ["_".join(x) for x in df_s1.columns.ravel()]
        return df_s1
    
    # Method - summary statement for creation of PD and LGD variables
    def summary_irb(self, x):
        """
        Next level steps, adjust the groupby and the dictionary for output.
        Summary by default flag of the PD and LGD variables with exposure weighted outputs
        """
        result = {
            'be_pd_sum': (x['drv_pd'] * x['drv_ead_dt_adj']).sum() / x['drv_ead_dt_adj'].sum()
            ,'con_pd_sum': (x['drv_pool_pd_adj'] * x['drv_ead_dt_adj']).sum() / x['drv_ead_dt_adj'].sum()
            ,'con_pd_sum1': np.average(x['drv_pool_pd_adj'], weights=x['drv_ead_dt_adj'])
            ,'be_pd_vol': np.average(x['drv_pd'])
            ,'con_pd_vol': np.average(x['drv_pool_pd_adj'])
            ,'be_lgd_sum': (x['drv_pool_lgd_adj'] * x['drv_ead_dt_adj']).sum() / x['drv_ead_dt_adj'].sum()
            ,'dt_lgd_sum': (x['drv_pool_lgd_dt_adj'] * x['drv_ead_dt_adj']).sum() / x['drv_ead_dt_adj'].sum()
            ,'be_lgd_vol': np.average(x['drv_pool_lgd_adj'])
            ,'dt_lgd_vol': np.average(x['drv_pool_lgd_dt_adj'])
        }
        return pd.Series(result).round(4)
