# dbt-databricks-example

This repo provides scaffolding for dbt projects using Databricks as a warehouse.

## Local Development
To get started, first install Poetry and run `poetry install` to build the virtual env with the necessary dependencies. `poetry shell` will activate this virtual environment. If you have not previously installed dbt, copy `./.config/profiles.yml` to `$HOME/.dbt/` and replace `schema`, `host`, `token`, and `endpoint` with your Databricks connection details. If you have not previously installed the Spark Simba driver necessary for ODBC connections, [download and install the driver](https://databricks.com/spark/odbc-drivers-download) and replace `driver` with the path to your driver installation.

This repository also makes use of [pre-commit hooks](https://github.com/offbi/pre-commit-dbt) for dbt. The `.pre-commit-config.yaml` contains a list of hooks to be run before every commit. Optionally, run `pre-commit install` to set up the git hook scripts. With this, pre-commit will run automatically on `git commit`. You can also manually run `pre-commit run` after you stage all files you want to run. Or `pre-commit run --all-files` to run the hooks against all of the files (not only staged).

## Github Actions
This project ships with two Github Actions workflows:
* `main.yml`: Runs on pull/PR on `main` branch and seeds, runs, tests, and generates and deploys docs using production credentials. dbt documentation is deployed via Github Pages, which will need to be enabled for the repo.
* `test.yml`: Runs on all other branches and seeds, runs, and tests using development credentials on a CI database target with the following name: `dbt_ci_YYYYMMDD_<SHORT SHA>`, where `SHORT SHA` is the the first eight characters of the commit SHA that triggered the workflow run.

To use these workflows, create the following secrets with respective values:
* DBT_DATABRICKS_HOST_PROD
* DBT_DATABRICKS_DATABASE_PROD
* DBT_DATABRICKS_ENDPOINT_PROD
* DBT_DATABRICKS_TOKEN_PROD
* DBT_DATABRICKS_HOST_TEST
* DBT_DATABRICKS_ENDPOINT_TEST
* DBT_DATABRICKS_TOKEN_TEST