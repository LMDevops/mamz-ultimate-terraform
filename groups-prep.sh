#!/bin/bash

export ADMIN_PROJECT_ID="CHANGE_ME" # For creating groups
export ADMIN_EMAIL="CHANGE_ME" # Also for creating groups
export ORGANIZATION="CHANGE_ME" # Your GCP ORG ID
###
# Create the project that will be used to make Workspace Admin API calls.
###

gcloud projects create $ADMIN_PROJECT_ID --organization=$ORGANIZATION;

if [ $? != 0 ]; then
  echo "*** Error creating admin project"
  exit 1
else
  echo "*** Project deployed"
fi

echo "*** Waiting for project to be ready..."
sleep 20;

FAILCOUNT=0

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
  gcloud services enable iap.googleapis.com --project=$ADMIN_PROJECT_ID;

  if [ $? != 0 ]; then
    echo "*** Failed enabling IAP API, will try again up to 3 times."
    FAILCOUNT+= 1;
    if [ FAILCOUNT > 3 ]; then
      echo "####Error enabling IAP API####"
      exit 1
    else
      sleep 30
    fi
  else
    echo "IAP API enabled"
    break
  fi
done
### Yes, application title is hardcoded here because we're only using this once, we can delete it after we are done. 
gcloud alpha iap oauth-brands create --application_title="admin-sdk-app" --support_email=$ADMIN_EMAIL --project=$ADMIN_PROJECT_ID

if [ $? != 0 ]; then
  echo "*** Error creating brand"
  exit 1
else
  echo "*** Brand created"
fi

echo "*** Script ran successfully. Please manually create desktop credentials for the create_groups.py script"

# Commented out for now but will be used for future automated steps
# var=$(gcloud alpha iap oauth-brands list --project=$ADMIN_PROJECT_ID | grep name) 

# BRAND=$(echo ${var##*/})

# echo $BRAND

exit 0