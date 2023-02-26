import os

from prefect.filesystems import GitHub

github_block = GitHub(repository=os.getenv("GITHUB_REPO_URL"))
github_block.save(os.getenv("GITHUB_BLOCK_NAME"), overwrite=True)
