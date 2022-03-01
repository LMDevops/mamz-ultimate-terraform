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

## May not be needed anymore.
# for i in 1 2 3
# do
#   gcloud services enable iap.googleapis.com --project=$ADMIN_PROJECT_ID;

#   if [ $? != 0 ]; then
#     echo "*** Failed enabling IAP API, will try again up to 3 times."
#     FAILCOUNT+= 1;
#     if [ FAILCOUNT > 3 ]; then
#       echo "####Error enabling IAP API####"
#       exit 1
#     else
#       sleep 30
#     fi
#   else
#     echo "IAP API enabled"
#     break
#   fi
# done

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

# gcloud iam service-accounts create $ADMIN_SA --description="Used for making Workspace admin API calls" --display-name="workspace-admin-api-caller" --project=$ADMIN_PROJECT_ID 

if [ $? != 0 ]; then
  echo "*** Error creating admin service account"
  exit 1
else
  echo "*** Service account created"
fi

# gcloud iam service-accounts keys create ./sada-cf-admin --iam-account=$ADMIN_SA@$ADMIN_PROJECT_ID.iam.gserviceaccount.com

if [ $? != 0 ]; then
  echo "*** Error creating service account keys"
  exit 1
else
  echo "*** Service account keys created"
fi

printf "The script has completed successfully. In order to finish provisioning the environment, please follow the instructions at: \n\nhttps://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M \n"

exit 0

# ##
# Create the oauth app so that we can generate credentials for admin API calls
# ##
# gcloud alpha iap oauth-brands create --application_title="admin-sdk-app" --support_email=$ADMIN_EMAIL --project=$ADMIN_PROJECT_ID

# if [ $? != 0 ]; then
#   echo "*** Error creating brand"
#   exit 1
# else
#   echo "*** Brand created"
# fi

# # printf "*** Script ran successfully. \n\n\nPlease manually create 'desktop app' credentials for the create_groups.py script by going to: \n\nhttps://console.cloud.google.com/apis/credentials?project=$ADMIN_PROJECT_ID&supportedpurview=project \n\nand clicking 'Create credentials and selecting OAuth client ID'\n\n"
# printf "*** Attempting to create oauth client ID \n"

# # Commented out for now but will be used for future automated steps
# var=$(gcloud alpha iap oauth-brands list --project=$ADMIN_PROJECT_ID | grep name) 

# BRAND=$(echo ${var##*/})

# # echo $BRAND

# gcloud beta iap oauth-clients create $BRAND --display_name="automatedGroup" --project=$ADMIN_PROJECT_ID

# if [ $? != 0 ]; then
#   echo "*** Error creating OAuth client"
#   exit 1
# else
#   echo "*** OAuth client created"
# fi

# var=$(gcloud beta iap oauth-clients list $BRAND --project=$ADMIN_PROJECT_ID --filter="displayName: automatedGroup" | grep name)

# NAME=$(echo ${var##*/})

# # echo $NAME

# var=$(gcloud beta iap oauth-clients list $BRAND --project=$ADMIN_PROJECT_ID --filter="displayName: automatedGroup" | grep secret)

# SECRET=$(echo ${var##*:})

# # echo $SECRET

# echo "Setting client_id and client secret in creds.json"

# cat <<EOF >./creds.json
# {"installed":{"client_id":"$NAME","project_id":"$ADMIN_PROJECT_ID","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"$SECRET","redirect_uris":["urn:ietf:wg:oauth:2.0:oob",""]}}
# EOF

# cat <<EOF >./creds.json
# {"web":{"client_id":"1013927195558-gn6ub008aogvpeb41dgas70cmj7qp2u4.apps.googleusercontent.com","project_id":"sada-cf-admin-prj-003","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"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","redirect_uris":["http://localhost"],"javascript_origins":["http://localhost"]}}
# EOF