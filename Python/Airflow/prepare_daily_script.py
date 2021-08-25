# Import modules
from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.operators.python_operator import PythonOperator
from airflow.contrib.operators.spark_submit_operator import SparkSubmitOperator
import datetime

# Create a DAG object
dag = DAG(
  dag_id='optimize_diaper_purchases',
  default_args={
    # Don't email on failure
    'email_on_failure': False,
    # Specify when tasks should have started earliest
    'start_date': datetime(2019, 6, 25)
  },
  # Run the DAG daily
  schedule_interval='@daily')

# Example - run a bash command to ingest data from an API and convert to a target-csv file
# Location of the config file to be used
config = os.path.join(os.environ["AIRFLOW_HOME"], 
                      "scripts",
                      "configs", 
                      "data_lake.conf")

# Creating the Bash operator to perform the task
ingest = BashOperator(
  # Assign a descriptive id
  task_id="ingest_data", 
  # Complete the ingestion pipeline
  bash_command="tap-marketing-api | target-csv --config %s" % config,
  dag=dag)
