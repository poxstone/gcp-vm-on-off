terraform {
  required_version = ">= 0.12"
}

provider "google" {  # provider "google-beta"
  project     = var.project_id
  credentials = file(var.account_key)
  region      = var.region
  zone        = var.zone
}