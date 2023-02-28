import os

from dotenv import load_dotenv
from prefect.filesystems import GitHub
from prefect_dbt import DbtCoreOperation
from prefect_gcp import GcpCredentials

# from prefect_gcp.cloud_run import CloudRunJob

load_dotenv()

github_block = GitHub(repository=os.getenv("GITHUB_REPO_URL"))
github_block.save(os.getenv("GITHUB_BLOCK_NAME"), overwrite=True)

gcp_credentials_block = GcpCredentials(
    service_account_file=os.getenv("GCP_API_KEY_FILE_PATH")
)
gcp_credentials_block.save(
    os.getenv("GCP_CREDENTIALS_BLOCK_NAME"), overwrite=True
)

dbt_core_credentials_block = DbtCoreOperation(
    commands=["dbt build"],
    working_dir=os.getenv("DBT_CORE_WORK_DIR"),
    project_dir=os.getenv("DBT_CORE_PROJECT_DIR"),
)

dbt_core_credentials_block.save(
    os.getenv("DBT_CORE_BLOCK_NAME"), overwrite=True
)

# cloud_run_block = CloudRunJob(
#     image=,
#     region=os.getenv("GCP_RESOURCE_REGION"),
#     credentials=GcpCredentials.load(os.getenv("GCP_CREDENTIALS_BLOCK_NAME")),
#     cpu=1,
#     timeout=3600,
# )
