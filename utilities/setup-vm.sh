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

export PATH=$PATH:/usr/local/lib/python3.11/bin/
python3.11 -m venv prefect-env
source prefect-env/bin/activate
pip install prefect==2.8.3

export EXTERNAL_VM_IP=`curl  -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/EXTERNAL_VM_IP"`
prefect config set PREFECT_API_URL="http://${EXTERNAL_VM_IP}:4200/api"
prefect config view
prefect orion start --host 0.0.0.0