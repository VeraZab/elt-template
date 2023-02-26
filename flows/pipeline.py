import os
from datetime import timedelta
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from prefect import flow, task
from prefect.tasks import task_input_hash
from prefect_gcp import GcpCredentials

load_dotenv()

# from prefect_dbt import DbtCoreOperation


# @task()
# def transform():
#     dbt_op = DbtCoreOperation.load("ny-taxi")
#     dbt_op.run()


@task(log_prints=True)
def load(blob):
    """Load Data to BigQuery Warehouse"""

    gcp_credentials = GcpCredentials.load(os.getenv("GCP_CREDENTIALS_BLOCK_NAME"))
    print(gcp_credentials)

    blob.to_gbq(
        destination_table=f"{os.getenv('GCP_DATASET_NAME')}.fhv_taxi_rides_template",
        project_id=os.getenv("GCP_PROJECT_ID"),
        credentials=gcp_credentials.get_credentials_from_service_account(),
        if_exists="append",
    )


@task(retries=3, cache_key_fn=task_input_hash, cache_expiration=timedelta(days=1), log_prints=True)
def extract(month, year):
    """Extract csv data from source"""

    if len(f"{month}") == 1:
        month = f"0{month}"

    data_url = (
        f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_{year}-{month}.csv.gz"
    )
    blob = pd.read_csv(data_url, nrows=100)
    print(blob)
    return blob


@flow(log_prints=True)
def extract_and_load(month, year):
    """Subflow Extracting and Loading a particular file"""
    blob = extract(month, year)
    load(blob)


def el_main(month_range, year_range):
    """Run all parametrized extraction and loading flows"""

    for year in range(year_range[0], year_range[-1] + 1):
        for month in range(month_range[0], month_range[-1] + 1):
            extract_and_load(month, year)


@flow(log_prints=True)
def main(month_range, year_range):
    """Main function kicking off our subflows"""

    el_main(month_range, year_range)
    # transform()


if __name__ == "__main__":
    main(month_range=[1], year_range=[2019])
