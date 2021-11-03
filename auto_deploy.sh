#!/bin/bash


# Tier 1 Bootstrap
terraform -chdir=1-bootstrap init
terraform -chdir=1-bootstrap plan --var-file=./terraform.tfvars
# for V2, have the terminal ask if you want to apply the plan
terraform -chdir=1-bootstrap apply --var-file=./terraform.tfvars --auto-approve;

# Check that command ran successfully.
if [ $? !=0 ]; then
  echo "Error on Step 1"
  exit 1
else
  echo "Bootstrap deployed...migrating state..."
fi
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

if [ $? !=0 ]; then
  echo "Error on migrating bootstrap state"
  exit 1
else
  echo "State migrated."
fi

# Tier 2 Organization
echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_organization\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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

if [ $? !=0 ]; then
  echo "Error on Step 2"
  exit 1
else
  echo "Organization resources deployed."
fi

# Setup tier 3 provider.tf

echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_shared\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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

terraform -chdir=3-shared apply --auto-approve -var-file=terraform.tfvars

if [ $? !=0 ]; then
  echo "Error on Step 3"
  exit 1
else
  echo "Shared resources deployed. "
fi

# Tier 4 dev
echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_dev\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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
}" > ./4-dev/provider.tf


terraform -chdir=4-dev init
terraform -chdir=4-dev apply --auto-approve -var-file=terraform.tfvars

if [ $? !=0 ]; then
  echo "Error on Step 4"
  exit 1
else
  echo "Dev resources deployed. "
fi

#Tier 5 qa

echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_qa\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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
}" > ./5-qa/provider.tf

terraform -chdir=5-qa init
terraform -chdir=5-qa apply --auto-approve -var-file=terraform.tfvars

if [ $? !=0 ]; then
  echo "Error on Step 5"
  exit 1
else
  echo "QA resources deployed. "
fi

echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_uat\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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
}" > ./6-uat/provider.tf

terraform -chdir=6-uat init
terraform -chdir=6-uat apply --auto-approve -var-file=terraform.tfvars

if [ $? !=0 ]; then
  echo "Error on Step 6"
  exit 1
else
  echo "UAT resources deployed. "
fi

echo "terraform {
  backend \"gcs\" {
    $BUCKET
    prefix = \"tf_state_shared\"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider \"google\" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

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
}" > ./7-prod/provider.tf

terraform -chdir=7-prod init
terraform -chdir=7-prod apply --auto-approve -var-file=terraform.tfvars

if [ $? !=0 ]; then
  echo "Error on Step 7"
  exit 1
else
  echo "Prod resources deployed. "
fi