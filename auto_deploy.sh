#!/bin/#!/usr/bin/env bash


# Tier 1 Bootstrap
terraform -chdir=1-bootstrap init -backend=false
terraform -chdir=1-bootstrap apply -var-file=../terraform.tfvars --auto-approve
echo "bucket = $(terraform -chdir=1-bootstrap output bucket)" > init-config.tfvars
terraform -chdir=1-bootstrap init -migrate-state -backend-config=../init-config.tfvars -force-copy

# Tier 2 Organization
terraform -chdir=2-organization init -migrate-state -backend-config=../init-config.tfvars
terraform -chdir=2-organization apply --auto-approve -var-file=../init-config.tfvars

# Tier 3 Shared Services
terraform -chdir=3-shared init -migrate-state -backend-config=../init-config.tfvars
terraform -chdir=3-shared apply --auto-approve -var-file=../init-config.tfvars
