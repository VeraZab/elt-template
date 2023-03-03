terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.PROJECT
  region = var.REGION
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.DATASET_NAME
  project    = var.PROJECT
  location   = var.REGION
}