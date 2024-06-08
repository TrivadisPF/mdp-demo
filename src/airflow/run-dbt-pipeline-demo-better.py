import datetime
import uuid

from airflow.decorators import dag, task
from airflow.operators.bash import BashOperator
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.docker_operator import DockerOperator
from airflow.models.param import Param
from airflow.utils.dates import days_ago
from airflow.models import Variable

@dag(
     dag_id="run-dbt-pipeline-demo-better",
     start_date=days_ago(1),
     schedule_interval=None,
     params={
         "run_for_single_source": Param(False, type="boolean"),
         "source_table_name": Param("", type="string")
     },
     render_template_as_native_obj=True
)
def run_dbt_pipeline():

  eadpDockerRegistry = Variable.get("MDP_DOCKER_REGISTRY")
  s3Endpoint = Variable.get("S3_ENDPOINT")
  s3AccessKey = Variable.get("S3_ACCESS_KEY")
  s3SecretAccessKey = Variable.get("S3_SECRET_ACCESS_KEY")

  start_dag = DummyOperator(
        task_id='start_dag'
        )

  @task.branch(task_id="branching")
  def choose_mode(**context):
      if ( context["params"]["run_for_single_source"] ):
        return "run_for_single_source"
      else:
        return "run_for_all"

  choice_mode = choose_mode()

  branch_all = DockerOperator(
        task_id='run_for_all',
        image=eadpDockerRegistry + '/mdp/dbt-demo-better-pipeline:1.8.0',
        container_name='dbt_demo_better_pipeline_' + uuid.uuid4().hex,
        api_version='auto',
        force_pull=True,
        auto_remove=True,
        environment={
              'SPARK_THRIFSERVER_HOST':'spark-thriftserver',
              'AWS_S3_URL':s3Endpoint,
              'AWS_S3_ACCESS_KEY':s3AccessKey,
              'AWS_S3_SECRET_ACCESS_KEY':s3SecretAccessKey
        },
        command="dbt run",
        privileged=True,
        docker_url="unix://var/run/docker.sock",
        network_mode="mdp-demo-platform"
        )

  branch_single_source = DockerOperator(
        task_id='run_for_single_source',
        image=eadpDockerRegistry + '/eadp/dbt-demo-better-pipeline:1.8.0',
        container_name='dbt_demo_better_pipeline_' + uuid.uuid4().hex,
        api_version='auto',
        force_pull=True,
        auto_remove=True,
        environment={
              'SPARK_THRIFSERVER_HOST':'spark-thriftserver',
              'AWS_S3_URL': s3Endpoint,
              'AWS_S3_ACCESS_KEY': s3AccessKey,
              'AWS_S3_SECRET_ACCESS_KEY': s3SecretAccessKey
        },
        command="dbt run --select source:mdp_demo_better_db.{{ params.source_table_name}}+",
        privileged=True,
        docker_url="unix://var/run/docker.sock",
        network_mode="mdp-demo-platform"
        )

  start_dag >> choice_mode

  choice_mode >> branch_all
  choice_mode >> branch_single_source

run_dbt_pipeline()  