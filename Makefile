include .env

####################################################################################################################
# Setting up environment

install-requirements:
	(\
		python -m pip install --upgrade pip &&\
		pip install --upgrade --upgrade-strategy eager -r requirements.txt\
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