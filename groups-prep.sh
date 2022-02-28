#!/bin/bash

export ADMIN_PROJECT_ID="CHANGE_ME" # For creating groups
export ADMIN_EMAIL="CHANGE_ME" # Also for creating groups
export ORGANIZATION="CHANGE_ME" # Your GCP ORG ID
export DOMAIN="CHANGE_ME" #  Your User verified Domain for GCP
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
###
# Create the oauth app so that we can generate credentials for admin API calls
###
gcloud alpha iap oauth-brands create --application_title="admin-sdk-app" --support_email=$ADMIN_EMAIL --project=$ADMIN_PROJECT_ID

if [ $? != 0 ]; then
  echo "*** Error creating brand"
  exit 1
else
  echo "*** Brand created"
fi

# printf "*** Script ran successfully. \n\n\nPlease manually create 'desktop app' credentials for the create_groups.py script by going to: \n\nhttps://console.cloud.google.com/apis/credentials?project=$ADMIN_PROJECT_ID&supportedpurview=project \n\nand clicking 'Create credentials and selecting OAuth client ID'\n\n"
printf "*** Attempting to create oauth client ID \n"

# Commented out for now but will be used for future automated steps
var=$(gcloud alpha iap oauth-brands list --project=$ADMIN_PROJECT_ID | grep name) 

BRAND=$(echo ${var##*/})

# echo $BRAND

gcloud beta iap oauth-clients create $BRAND --display_name="automatedGroup" --project=$ADMIN_PROJECT_ID

if [ $? != 0 ]; then
  echo "*** Error creating OAuth client"
  exit 1
else
  echo "*** OAuth client created"
fi

var=$(gcloud beta iap oauth-clients list $BRAND --project=$ADMIN_PROJECT_ID --filter="displayName: automatedGroup" | grep name)

NAME=$(echo ${var##*/})

# echo $NAME

var=$(gcloud beta iap oauth-clients list $BRAND --project=$ADMIN_PROJECT_ID --filter="displayName: automatedGroup" | grep secret)

SECRET=$(echo ${var##*:})

# echo $SECRET

echo "Setting client_id and client secret in creds.json"

cat <<EOF >./creds.json
{"installed":{"client_id":"$NAME","project_id":"$ADMIN_PROJECT_ID","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"$SECRET","redirect_uris":["urn:ietf:wg:oauth:2.0:oob","http://localhost"]}}
EOF

echo "Attempting to create groups via the create_groups.py script."

python ./create_groups.py
exit 0