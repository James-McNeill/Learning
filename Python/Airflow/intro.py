# Introduction to Airflow in Python

# Running commands
'''
Apache Airflow is a scheduler that can be used to complete data engineering tasks.
'''
# To run commands in the console
airflow run <dag_id> <task_id> <start_date>
# values between <> will be populated with values. The <> are not required they are just shown as placeholders
# Import the DAG object
from airflow.models import DAG

# Define the default_args dictionary
default_args = {
  'owner': 'dsmith',
  'start_date': datetime(2020, 1, 14),
  'retries': 2
}

# Instantiate the DAG object
etl_dag = DAG('example_etl', default_args=default_args)

# Starting the Airflow webserver - using the CLI
airflow webserver -p 9090
