include .env

####################################################################################################################
# Setting up environment

install-requirements-dev:
	(\
		python -m pip install --upgrade pip &&\
		pip install --upgrade --upgrade-strategy eager -r requirements.txt &&\
		pip install --upgrade --upgrade-strategy eager -r requirements-dev.txt\
	)


####################################################################################################################
# Testing, auto formatting, type checks, & Lint checks

format:
	python -m black -S --line-length 119 .

isort:
	isort .

lint: 
	flake8 ./flows

lint-and-format: isort format lint


####################################################################################################################
# Prefect

prefect-cloud-login:
	(\
		unset PREFECT_API_KEY && \
		prefect cloud login -k $(PREFECT_KEY)\
	)

prefect-cloud-logout:
	prefect cloud logout

prefect-api-url:
	(\
		make prefect-cloud-login &&\
		prefect cloud workspace set --workspace $(PREFECT_WORKSPACE) &&\
		prefect config view &&\
		make prefect-cloud-logout\
	)

prefect-blocks:
	python ./utilities/setup-prefect-blocks.py

####################################################################################################################
# Google Cloud

service-account:
	gcloud iam service-accounts create $(GCP_SERVICE_ACCOUNT_NAME) --display-name="Terraform Service Account"

service-account-permissions:
	gcloud projects add-iam-policy-binding $(GCP_PROJECT_ID) --member='serviceAccount:$(GCP_SERVICE_ACCOUNT_NAME)@$(GCP_PROJECT_ID).iam.gserviceaccount.com' --role='roles/editor'

download-api-key:
	gcloud iam service-accounts keys create $(GCP_API_KEY_FILE_PATH) --iam-account=$(GCP_SERVICE_ACCOUNT_NAME)@$(GCP_PROJECT_ID).iam.gserviceaccount.com

gcp-setup:
	make service-account && make service-account-permissions && make download-api-key