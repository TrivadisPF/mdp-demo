#!/bin/bash

docker build --tag mdp-demo/dbt-demo-better-pipeline:1.8.0  --target dbt-spark --build-arg dbt_project=demo_better_pipeline .

docker image tag mdp-demo/dbt-demo-better-pipeline:1.8.0 dataplatform-registry:5020/mdp-demo/dbt-demo-better-pipeline:1.8.0
docker image push dataplatform-registry:5020/mdp-demo/dbt-demo-better-pipeline:1.8.0

