#!/bin/bash

ESC=$(printf '\033') RESET="${ESC}[0m" BLACK="${ESC}[30m" RED="${ESC}[31m"
GREEN="${ESC}[32m" BLUE="${ESC}[34m" YELLOW="${ESC}[33m"

greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }
blueprint() { printf "${BLUE}%s${RESET}\n" "$1"; }
redprint() { printf "${RED}%s${RESET}\n" "$1"; }
yellowprint() { printf "${YELLOW}%s${RESET}\n" "$1"; }


mainmenu() {
    echo -ne "
MAIN MENU
$(greenprint 'all)') Run all
$(greenprint 's)') Run 1,2,3

$(yellowprint '1)') Run 1-bootstrap
$(yellowprint '2)') Run 2-organization
$(yellowprint '3)') Run 3-shared
$(yellowprint '4)') Run 4-dev
$(yellowprint '5)') Run 5-qa
$(yellowprint '6)') Run 6-uat
$(yellowprint '7)') Run 7-prod

$(redprint '0)') Exit
Choose an option:  "
    read -r ans
    case $ans in
    1)
        echo "Running bootstrap"
        run_1_bootstrap
        echo "Completed boostrap"
        mainmenu
        ;;
    2)
        echo "Running organization"
        run_2_organization
        echo "Completed organization"
        mainmenu
        ;;
    3)
        echo "Running shared"
        run_3_shared
        echo "Completed shared"
        mainmenu
        ;;
    4)
        echo "Running dev"
        run_X_env "4-dev"
        echo "Completed dev"
        mainmenu
        ;;
    5)
        echo "Running qa"
        run_X_env "5-qa"
        echo "Completed qa"
        mainmenu
        ;;
    6)
        echo "Running uat"
        run_X_env "6-uat"
        echo "Completed uat"
        mainmenu
        ;;
    7)
        echo "Running prod"
        run_X_env "7-prod"
        echo "Completed prod"
        mainmenu
        ;;
    s)
        echo "Running setup"
        run_1_bootstrap
        echo "Completed bootstrap"
        run_2_organization
        echo "Completed organization"
        run_3_shared
        echo "Completed shared"
        mainmenu
        ;;
    all)
        echo "Running all"
        run_1_bootstrap
        echo "Completed bootstrap"
        run_2_organization
        echo "Completed organization"
        run_3_shared
        echo "Completed shared"

        echo "Running dev"
        run_X_env "4-dev"
        echo "Completed dev"

        echo "Running qa"
        run_X_env "5-qa"
        echo "Completed qa"

        echo "Running uat"
        run_X_env "6-uat"
        echo "Completed uat"

        echo "Running prod"
        run_X_env "7-prod"
        echo "Completed prod"
        mainmenu
        ;;
    0)
        echo "Bye bye."
        exit 0
        ;;
    *)
        echo "Invalid option."
        mainmenu
        ;;
    esac
}



######
## run_1_bootstrap
######
run_1_bootstrap() {

# Tier 1 Bootstrap
terraform -chdir=1-bootstrap init
if terraform -chdir=1-bootstrap plan --var-file=./terraform.tfvars | grep "No changes"; then
  echo "###Bootstrap is already deployed###";
else
  terraform -chdir=1-bootstrap apply --var-file=./terraform.tfvars --auto-approve
  # Check that command ran successfully.
  if [ $? != 0 ]; then
    echo "####Error on Step 1####"
    exit 1
  else
    echo "####Bootstrap deployed...migrating state...####"
  fi
fi


# Grab bucket output to use for future state checks
export BUCKET=$(terraform -chdir=1-bootstrap output | grep bucket)

cat <<EOF > ./1-bootstrap/provider.tf
terraform {
  backend "gcs" {
    $BUCKET
    prefix = "tf_state_bootstrap"
  }
}
EOF

# Migrate the backend to the GCS bucket
terraform -chdir=1-bootstrap init -force-copy;

if [ $? != 0 ]; then
  echo "####Error on migrating bootstrap state####"
  exit 1
else
  echo "####State migrated.####"
fi

}


######
## run_2_organization
######
run_2_organization() {

# Tier 2 Organization
export BUCKET=$(terraform -chdir=1-bootstrap output | grep bucket)

cat <<EOF > ./2-organization/provider.tf
terraform {
  backend "gcs" {
    $BUCKET
    prefix = "tf_state_organization"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider "google" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_bootstrap"
  }
}
EOF

terraform -chdir=2-organization init
if terraform -chdir=2-organization plan -var-file=terraform.tfvars | grep "No changes."; then
  echo "###Organization resources already deployed###"
else
  terraform -chdir=2-organization apply -var-file=terraform.tfvars --auto-approve;
  if [ $? != 0 ]; then
    echo "####Error on Step 2####"
    exit 1
  else
    echo "####Organization resources deployed.####"
  fi
fi

}


######
## run_3_shared
######
run_3_shared() {

# Setup tier 3 provider.tf
export BUCKET=$(terraform -chdir=1-bootstrap output | grep bucket)

cat <<EOF > ./3-shared/provider.tf
terraform {
  backend "gcs" {
    $BUCKET
    prefix = "tf_state_shared"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider "google" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_bootstrap"
  }
}

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_organization"
  }
}
EOF

# Tier 3 Shared Services
terraform -chdir=3-shared init 

####STOP HERE AND ADD THE TF SA TO THE BILLING ACCOUNT AS A BILLING USER IF USING THE TF SA.######

if terraform -chdir=3-shared plan -var-file=terraform.tfvars | grep "No changes."; then
  echo "###Shared resources already deployed###";
else
  terraform -chdir=3-shared apply --auto-approve -var-file=terraform.tfvars
  if [ $? != 0 ]; then
    echo "####Error on Step 3#####"
    exit 1
  else
    echo "######Shared resources deployed.######"
  fi
fi
}


######
## run_X_env
# Example:
# $ run_X_env 4-dev
######
run_X_env() {


THE_ENV=$1
case $THE_ENV in
  4-dev)
    PREFIX="tf_state_dev"
    ;;
  5-qa)
    PREFIX="tf_state_qa"
    ;;  
  6-uat)
    PREFIX="tf_state_uat"
    ;;
  7-prod)
    PREFIX="tf_state_prod"
    ;;
esac

THE_FILE="./$THE_ENV/provider.tf"
BUCKET=$(terraform -chdir=1-bootstrap output | grep bucket)

# Build the provider.tf file
cat <<EOF > $THE_FILE
terraform {
  backend "gcs" {
    $BUCKET
    prefix = "$PREFIX"
  }
}

###Uncomment the lines below to use the TF service account. Will require that the account have billing user privileges by step 3.###
# provider "google" {
#   impersonate_service_account = data.terraform_remote_state.bootstrap.outputs.bootstrap_automation_service_account
# }

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_bootstrap"
  }
}

data "terraform_remote_state" "organization" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_organization"
  }
}

data "terraform_remote_state" "shared" {
  backend = "gcs"
  config = {
    $BUCKET
    prefix = "tf_state_shared"
  }
}
EOF


terraform -chdir=$THE_ENV init
if terraform -chdir=$THE_ENV plan -var-file=terraform.tfvars | grep "No changes."; then
  echo "###Dev resources already deployed###"
else
  terraform -chdir=$THE_ENV apply --auto-approve -var-file=terraform.tfvars
  if [ $? != 0 ]; then
    echo "### Error on Step $THE_ENV ###"
    exit 1
  else
    echo "### $THE_ENV resources deployed. ###"
  fi
fi

}



echo "Hi. This will walk through deploying the foundations terraform."
mainmenu

