include .env

install-requirements-dev:
	(\
		python -m pip install --upgrade pip &&\
		pip install --upgrade --upgrade-strategy eager -r requirements-dev.txt\
	)

install-requirements-prod:
	(\
		python -m pip install --upgrade pip &&\
		pip install --upgrade --upgrade-strategy eager -r requirements.txt\
	)

get-prefect-api-url:
	(\
		unset PREFECT_API_KEY && \
		prefect cloud login -k $(PREFECT_KEY) &&\
		prefect cloud workspace set --workspace $(PREFECT_WORKSPACE) &&\
		prefect config view &&\
		prefect cloud logout\
	)

prefect-cloud-logout:
	prefect cloud logout



