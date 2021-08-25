from datetime import datetime
from airflow import DAG

# Specifying a task to take place each Monday at 7am
reporting_dag = DAG(
    dag_id="publish_EMEA_sales_report", 
    # Insert the cron expression
    schedule_interval="0 7 * * 1",
    start_date=datetime(2019, 11, 24),
    default_args={"owner": "sales"}
)

# Specifying order dependencies - example relates to making a pizza DAG
# Specify direction using verbose method - prepare_crust precedes
prepare_crust.set_downstream(apply_tomato_sauce)

tasks_with_tomato_sauce_parent = [add_cheese, add_ham, add_olives, add_mushroom]
for task in tasks_with_tomato_sauce_parent:
    # Specify direction using verbose method on relevant task - apply_tomato_sauce precedes each task
    apply_tomato_sauce.set_downstream(task)

# Specify direction using bitshift operator - first task precedes the second
tasks_with_tomato_sauce_parent >> bake_pizza

# Specify direction using verbose method - bake_pizza succeeds
bake_pizza.set_upstream(prepare_oven)
