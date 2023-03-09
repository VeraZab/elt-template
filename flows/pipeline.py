import os

import pandas as pd
from dotenv import load_dotenv
from prefect import flow, task
from prefect.tasks import task_input_hash
from prefect_dbt import DbtCoreOperation
from prefect_gcp import GcpCredentials

load_dotenv()


@task()
def transform():
    dbt_op = DbtCoreOperation.load(os.getenv("PREFECT_DBT_CORE_BLOCK_NAME"))
    dbt_op.run()


@task()
def load(blob):
    """Load Data to BigQuery Warehouse"""
    dataset_name = os.getenv("GCP_DATASET_NAME")
    dataset_table_name = os.getenv("GCP_DATASET_TABLE_NAME")

    gcp_credentials = GcpCredentials.load(os.getenv("PREFECT_GCP_CREDENTIALS_BLOCK_NAME"))

    blob.to_gbq(
        destination_table=f"{dataset_name}.{dataset_table_name}",
        project_id=os.getenv("GCP_PROJECT_ID"),
        credentials=gcp_credentials.get_credentials_from_service_account(),
        if_exists="append",
    )


@task(
    retries=3,
    log_prints=True,
    task_run_name="extracting:{month}-{year}",
)
def extract(month, year):
    """Extract csv data from source"""

    if len(f"{month}") == 1:
        month = f"0{month}"

    data_url = (
        f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_{year}-{month}.csv.gz"
    )
    blob = pd.read_csv(data_url, nrows=100)
    return blob


@task(log_prints=True)
def just_for_fun():
    print("well hello there")


@flow(log_prints=True)
def main(month=1, year=2019):
    """Run all parametrized extraction and loading flows"""
    just_for_fun()
    blob = extract(month, year)
    load(blob)
    transform()


if __name__ == "__main__":
    main(month=1, year=2019)
