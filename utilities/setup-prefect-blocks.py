import os

from dotenv import load_dotenv
from prefect.filesystems import GitHub
from prefect_dbt import DbtCoreOperation
from prefect_gcp import GcpCredentials

load_dotenv()

github_block = GitHub(repository=os.getenv("GITHUB_REPO_URL"))
github_block.save(os.getenv("PREFECT_GITHUB_BLOCK_NAME"), overwrite=True)

gcp_credentials_block = GcpCredentials(service_account_file=os.getenv("GCP_API_KEY_FILE_PATH"))
gcp_credentials_block.save(os.getenv("PREFECT_GCP_CREDENTIALS_BLOCK_NAME"), overwrite=True)

dbt_core_credentials_block = DbtCoreOperation(
    commands=["dbt build"],
    working_dir=os.getenv("DBT_CORE_WORK_DIR"),
    project_dir=os.getenv("DBT_CORE_PROJECT_DIR"),
)

dbt_core_credentials_block.save(os.getenv("PREFECT_DBT_CORE_BLOCK_NAME"), overwrite=True)
