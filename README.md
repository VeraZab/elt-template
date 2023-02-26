# elt-template

 </br>

## In Development

---

### Prerequisites:

<details>
<summary>Python 3</summary>
This project was tested with Python 3.11.1, please install that version for best results.
It is also recommended that you use a Python version manager and a virtual environment to install your dependencies.
</details>

<details>
<summary>Google Cloud Platform and gcloud CLI</summary>

1. Create an account on Google Cloud Platform
1. Install [gcloud cli](https://cloud.google.com/sdk/docs/install-sdk)
1. Run `gcloud init` and follow instructions to setup your project (projectID must be unique across all projects ever created by all users in google cloud)
1. Run `gcloud info` to check that all is configured correctly, you should see that your CLI is configured to use your created project
1. Enter your newly created projectID into the .env file
1. Fill out the rest of the environment variables that relate to GCP
1. Run `make gcp-setup`, this will create a service account with editor permissions, and download a json format api key to the path you specified in .env file,
   make sure to include this file to .gitignore so its not version controlled
1. Run `set -o allexport && source .env && set +o allexport` to export all variables, we're going to need some of them for Terraform setup

</details>

<details>
<summary>Terraform</summary>

1. [Install Terraform](https://developer.hashicorp.com/terraform/downloads?ajs_aid=f70c2019-1bdc-45f4-85aa-cdd585d465b4&product_intent=terraform)
1. Make sure you have the `GOOGLE_APPLICATION_CREDENTIALS` environment variable set, this should have happened at the GCP setup step, when you exported all your env vars
1. Change all the values in the `variables.tf` file to your own
1. Run `terraform init` to initialize
1. Run `terraform plan` to see the changes to be applied
1. Run `terraform apply` to deploy your resources
1. If you need to destroy the changes you can run `terraform destroy`

</details>

<details>
<summary>Prefect Cloud</summary>

1. Login to Prefect Cloud and Create a workspace
   ![creating a new workspace](/utilities/images/prefect-cloud-create-workspace.png) [It does not seem possible atm to create this with a tool like Terraform for example, has to be manual for now]

1. Create an API key for your cloud account by going to the menu at the bottom of the screen and clicking on your profile name, then clicking on API KEYS
   ![go to API KEYS](/utilities/images/api-settings.png) ![create a new API KEY](/utilities/images/create-api-keys.png)
1. Copy paste your API KEY into your .env file, it will only be shown to you once. Also create an environment variable for your workspace name [the format will be <yourAccountName/yourWorkspaceName>].
1. Export your environment variables by running `set -o allexport && source .env && set +o allexport`
1. Run `make get-prefect-api-url` to get your api url and also enter that into your .env file. (Note that during this step we're unsetting the PREFECT_API_KEY environment variable, and we'll have to set it back again because of this [bug](https://github.com/PrefectHQ/prefect/issues/7797))

</details>

<details>
<summary>dbt Cloud</summary>

1. Register to dbt cloud
1. Configure your dbt cloud account with your github account.
   ![dbt github config](/utilities/images/dbt-github.png)
1. Configure your external connections. ![external connections](/utilities/images/dbt-connections-config.png)
1. Also include a project subdirectory in the field that asks for it. This will create that project folder, and when you click "Initialize Project" it will put all of the dbt related folders into that parent folder you created.

</details>

<details>
<summary>Your copy of this repo pushed to Github with Github Secrets for CI/CD</summary>

1. Clone repository </br>
   `git clone https://github.com/VeraZab/elt-template.git`
1. Remove git history </br>
   `rm -rf .git`
1. Reinitialize git and make your initial commit on `main` branch </br>
   `git init`</br>
   `git add .` </br>
   `git commit -m 'initial commit'` </br>
1. Push to your own remote repository
1. Setup your Github Action Secrets</br>
   ![github action secrets](/utilities/images/github-action-secrets.png)

</details>

</br>

To get started:

1. Create a feature branch </br>
   `git checkout -b feature-branch`
1. Create a virtual environment </br>
   `python -m venv venv && source venv/bin/activate`
1. Install requirements </br>
   `pip install -r requirements-dev.txt`
1. Rename the `env` file to `.env`, and add your own environment variables
1. Load environment variables, by running this on your terminal </br>
   `set -o allexport && source .env && set +o allexport && export PREFECT_API_KEY=$PREFECT_KEY` [the last export part is needed to rename a variable because of this [bug](https://github.com/PrefectHQ/prefect/issues/7797)]

</br>

## In Production

---
