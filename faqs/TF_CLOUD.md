# How to integrate our Foundation with Terraform Cloud

## Pre-Requisites

- Terraform Cloud (TFC) acccount
- TFC Workspace
- TFC ORG ID
- TFC credentials
- TF CLI locally

## Steps to move the Bucket stored state file into a TFC Workspace

- https://learn.hashicorp.com/tutorials/terraform/cloud-migrate?in=terraform/cloud

## TL;DR steps

- For each Foundation steps, open the file containing the location of the Sate File and change GCS for the new CLOUD section (*see code snippet*) with the ORG ID and Workspace from the Terraform Cloud account.
```
terraform {
  required_version = ">= 1.1.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  cloud {
    organization = "<ORG_NAME>"
    workspaces {
      name = "Example-Workspace"
    }
  }
}
```
- Login to Terraform cloud from CLI
  - terraform login
- Re-initialize Terraform
  - terraform init
- Answer YES to state file migration question
- Go into the Terraform Cloud console and see your State file in your workspace om STATE-MIGRATION 
