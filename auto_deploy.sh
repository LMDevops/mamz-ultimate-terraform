#!/bin/bash


# Tier 1 Bootstrap
terraform -chdir=1-bootstrap init
terraform -chdir=1-bootstrap plan --var-file=./terraform.tfvars
# for V2, have the terminal ask if you want to apply the plan
terraform -chdir=1-bootstrap apply --var-file=./terraform.tfvars --auto-approve;

# Check that command ran successfully.

# Grab bucket output to use for future state checks
export BUCKET=$(terraform -chdir=1-bootstrap output | grep bucket)
echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_bootstrap\"
  }
}" > ./1-bootstrap/provider.tf

# Migrate the backend to the GCS bucket
terraform -chdir=1-bootstrap init -force-copy

# Tier 2 Organization
echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_organization\"
  }
}

provider \"google\" {
  impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
}

data \"terraform_remote_state\" \"bootstrap\" {
  backend = \"gcs\"
  config = {
    $BUCKET
    prefix = \"tf_state_bootstrap\"
  }
}" > ./2-organization/provider.tf

terraform -chdir=2-organization init
terraform -chdir=2-organization plan
# for V2 ask if you want to apply changes
terraform -chdir=2-organization apply --auto-approve

# Setup tier 3 provider.tf

echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_shared\"
  }
}

provider \"google\" {
  impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
}

data \"terraform_remote_state\" \"bootstrap\" {
  backend = \"gcs\"
  config = {
    $BUCKET
    prefix = \"tf_state_bootstrap\"
  }
}

data \"terraform_remote_state\" \"organization\" {
  backend = \"gcs\"
  config = {
    $BUCKET
    prefix = \"tf_state_organization\"
  }
}" > ./3-shared/provider.tf
# Tier 3 Shared Services
terraform -chdir=3-shared init 

####STOP HERE AND ADD THE TF SA TO THE BILLING ACCOUNT AS A BILLING USER IF USING THE TF SA.######

terraform -chdir=3-shared apply --auto-approve

# terraform -chdir=3-shared init -migrate-state -backend-config=../init-config.tfvars
# terraform -chdir=3-shared apply --auto-approve -var-file=../init-config.tfvars
