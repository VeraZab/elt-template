#!/bin/bash

curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh sudo bash install-logging-agent.sh

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y \
    build-essential \
    curl \
    zlib1g-dev \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    libsqlite3-dev

# Download and compile Python 3.11 from source
wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
tar xzf Python-3.11.0.tgz
cd Python-3.11.0
./configure --enable-optimizations
make -j "$(nproc)"
sudo make altinstall
export PATH="/usr/local/lib/bin:$PATH"

git clone https://github.com/VeraZab/elt-template.git
cd elt-template

python3.11 -m venv prefect-env
source prefect-env/bin/activate

curl -sSL https://install.python-poetry.org | POETRY_HOME=/usr/local/lib python3.11 -
poetry install --no-root --without dev

export EXTERNAL_VM_IP=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/EXTERNAL_VM_IP"`
export GCP_DATASET_NAME=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCP_DATASET_NAME"`
export SERVICE_ACCOUNT_FILE_PATH=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/SERVICE_ACCOUNT_FILE_PATH"`
export GCP_REGION=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCP_REGION"`
export GCP_PROJECT_ID=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCP_PROJECT_ID"`
export PREFECT_AGENT_QUEUE=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/PREFECT_AGENT_QUEUE"`
export DBT_CORE_BLOCK_NAME=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DBT_CORE_BLOCK_NAME"`
export GCP_DATASET_TABLE_NAME=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCP_DATASET_TABLE_NAME"`
export DBT_PROFILE_NAME=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/DBT_PROFILE_NAME"`
export PREFECT_GCP_CREDENTIALS_BLOCK_NAME=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/PREFECT_GCP_CREDENTIALS_BLOCK_NAME"`

prefect config set PREFECT_API_URL="http://${EXTERNAL_VM_IP}:4200/api"

mkdir ~/.dbt
touch ~/.dbt/profiles.yml
echo "
    ${DBT_PROFILE_NAME}:
        outputs:
            dev:
            dataset: ${DATASET_NAME}
            job_execution_timeout_seconds: 300
            job_retries: 1
            keyfile: ${SERVICE_ACCOUNT_FILE_PATH}
            location: ${REGION}
            method: service-account
            priority: interactive
            project: ${PROJECT}
            threads: 4
            type: bigquery
        target: dev" >> ~/.dbt/profiles.yml

export SESSION_NAME="prefect"
export WINDOW_1_NAME="server"
export WINDOW_2_NAME="agent"


tmux new-session -d -s "$SESSION_NAME"

tmux new-window -n "$WINDOW_1_NAME" -t "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME:$WINDOW_1_NAME" 'prefect orion start --host 0.0.0.0' C-m

tmux new-window -n "$WINDOW_2_NAME" -t "$SESSION_NAME"
tmux send-keys -t "$SESSION_NAME:$WINDOW_2_NAME" "prefect agent start -q $PREFECT_AGENT_QUEUE" C-m