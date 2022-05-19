## Scheduling with DAGs in Airflow

website to provide overview @ https://crontab.guru

Overview of the scheduling details

Working with python code

from airflow.models import DAG

dag = DAG(dag_id="sample",
  ...,
  schedule_interval="0 0 * * *"
)

- cron
1. .         minute            (0 - 59)
2. I .       hour              (0 - 23)
3. I I .     day of the month  (1 - 31)
4. I I I .   month             (1 - 12)
5. I I I I . day of the week   (0 - 6)
6. "* * * * *" <command>

#### Example
0 * * * * # Every hour at the 0th minute
