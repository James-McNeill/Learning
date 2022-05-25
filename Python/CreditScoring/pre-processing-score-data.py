# Working with JSON and YAML files to make the processing of input values unique
# AIM was to have one source for the input and output table names

# Also providing details on the scorecard buckets as well within one source

%%time 
import json

data = '''{
"input_woe":{"csv_path":"s3://bucket-eu-west-1-.../.../woes_file.csv",
    "header":"true",
    "delimiter":",",
    "schema":["Column","grouping","woe"]
    },

"grouped_table":{"database1":"db",
    "table1":"table1",
    "database2":"db2",
    "table2":"table2",
    "database3":"db3",
    "table3":"table3",
    },
    
"input_pe":{"csv_path":"s3://bucket-eu-west-1-.../.../model_parameter_estimates.csv",
    "header":"true",
    "delimiter":",",
    "schema":["factor","pe"]
    },

"scores":{ "0<=100":"A",
    "101<=200":"B",
    "201<=300":"C",
    "301<=400":"D"
        }, 
"qa_params":{"default":"-9999",
    "missing": "-1"
        }, 

"output":{
    "path_type":"dir",
    "header":"false",
    "save_type":"dynamic",
    "file_path":"s3://bucket-eu-west-1-.../.../pre_proc_output.csv"
        }
}'''
obj = json.loads(data)
obj

# Pre-processing input data
%%time

df = pandas_cursor.execute("""Select 

account_no
,month
,current_balance

from (
Select 

-- direct pull fields from table
ac.account_no
,ac.month
,ac.current_balance

,(ac.current_balance/ac.drawdown_amt)*100  as drv_bal_pc_drawdown

from {database1}.{table1} as ac
left join (select distinct * from {database2}.{table2} ) as fb
    on ac.account_no = fb.account_no
    and ac.year_month = fb.year_month
where month = cast('2020-03-01' as DATE)
order by account_no, year_month

""".format(**obj['grouped_table']), 
        keep_default_na = True).as_pandas()

df.columns = [x.lower() for x in df.columns]
df.head()

# Review WoE by variable
import csv

df_woe = pd.read_csv(obj['input_woe']['csv_path'])
df_woe['Column'] =df_woe['Column']+"_pd_grp" 
df_woe.head()

# Create a WoE dictionary
woe_dict = {k: f.groupby('grouping')['woe'].apply(list).to_dict()
     for k, f in df_woe.groupby('Column')}
woe_dict
