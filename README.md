# elt-template

 </br>

## In Development

---

### Prerequisites:

<details>
<summary>Python 3</summary>
</details>

<details>
<summary>Terraform</summary>

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
<summary>Google Cloud Platform Project</summary>

1. Create a project in Google Cloud
   ![create new GC project](/utilities/images/new-project-name.png)
   ![go into the project](/utilities/images/select-project.png)

1. Create a new IAM service account for big query, give it BigQuery Admin access
   ![creating a new service account](/utilities/images/iam-service-account.png)
1. Create an access key for that IAM service account by generating it in json form (click manage keys, then add key, then generate in json format)
   ![creating a new service account](/utilities/images/generate-access-key.png)
1. Store that key somewhere safe, DO NOT SHARE. We'll use this later and will need to specify the path to this key
</details>

<details>
<summary>dbt Cloud</summary>
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
