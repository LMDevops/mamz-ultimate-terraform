#!/bin/bash

######
## 0-prep
######

# Update these variables per your GCP environment
export DOMAIN="CHANGE_ME"       # Your User verified Domain for GCP
export BILLING_ACCT="CHANGE_ME" # Your GCP BILLING ID (SADA Sub-Account or Direct ID);
export ORGANIZATION="CHANGE_ME" # Your GCP ORG ID
export REGION=US-WEST1          # Region to deploy the initial subnets
export ADMIN_PROJECT_ID="CHANGE_ME" # The project ID of the project that will be authorized to make workspace API calls
## May not need admin email if using DWD with SA
export ADMIN_EMAIL="CHANGE_ME" # The email address of the user deploying the foundation 
## This replaces the admin email
export ADMIN_SA="CHANGE_ME"
export USE_BUS_CODE="TRUE"      # Set to FALSE to remove the Business Code requirement
export BUS_CODE=zzzz            # The Department code or cost center associated with this Foudnation ; Leave like this if you've set USE_BUS_CODE to FALSE ; 
export APP_NAME=app1            # Short name of your workload

##
# Create the project that will be used to make Workspace Admin API calls.
##

gcloud projects create $ADMIN_PROJECT_ID --organization=$ORGANIZATION;

if [ $? != 0 ]; then
  echo "*** Error creating admin project"
  exit 1
else
  echo "*** Project deployed"
fi

echo "*** Waiting for project to be ready..."
sleep 10;

FAILCOUNT=0

###
# Enable the neccessary API's
###

for i in 1 2 3
do
  gcloud services enable admin.googleapis.com --project=$ADMIN_PROJECT_ID;

  if [ $? != 0 ]; then
    echo "*** Failed enabling Admin API, will try again up to 3 times."
    FAILCOUNT+= 1;
    if [ FAILCOUNT > 3 ]; then
      echo "*** Error enabling Admin API"
      exit 1
    else
      sleep 30
    fi
  else
    echo "*** Admin API enabled"
    break
  fi
done

for i in 1 2 3
do
  gcloud services enable iam.googleapis.com --project=$ADMIN_PROJECT_ID;

  if [ $? != 0 ]; then
    echo "*** Failed enabling IAM API, will try again up to 3 times."
    FAILCOUNT+= 1;
    if [ FAILCOUNT > 3 ]; then
      echo "####Error enabling IAM API####"
      exit 1
    else
      sleep 30
    fi
  else
    echo "IAM API enabled"
    break
  fi
done

##
# Create the service account that will perform Admin API calls
##

gcloud iam service-accounts create $ADMIN_SA --description="Used for making Workspace admin API calls" --display-name="workspace-admin-api-caller" --project=$ADMIN_PROJECT_ID 

if [ $? != 0 ]; then
  echo "*** Error creating admin service account"
  exit 1
else
  echo "*** Service account created"
fi

gcloud iam service-accounts keys create ./sa-admin-caller.p12 --key-file-type=p12 --iam-account=$ADMIN_SA@$ADMIN_PROJECT_ID.iam.gserviceaccount.com 

if [ $? != 0 ]; then
  echo "*** Error creating service account keys"
  exit 1
else
  echo "*** Service account keys created"
fi

printf "The script has completed successfully. In order to finish provisioning the environment, please follow the instructions at: \n\nhttps://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M/edit#heading=h.nfzma1molxm2 \n"

exit 0