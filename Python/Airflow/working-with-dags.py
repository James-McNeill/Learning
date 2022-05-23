# Working with the dag methods

from airflow.models import DAG
from airflow.operators.python_operator 
import PythonOperator
dag = DAG(dag_id="etl_pipeline",          
          schedule_interval="0 0 * * *")
etl_task = PythonOperator(task_id="etl_task",                          
                          python_callable=etl,                          
                          dag=dag)etl_task.set_upstream(wait_for_this_task)

# Define the ETL function
def etl():
    film_df = extract_film_to_pandas()
    film_df = transform_rental_rate(film_df)
    load_dataframe_to_film(film_df)

# Define the ETL task using PythonOperator
etl_task = PythonOperator(task_id='etl_film',
                          python_callable=etl,
                          dag=dag)

# Set the upstream to wait_for_table and sample run etl()
etl_task.set_upstream(wait_for_table)
etl()
