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





