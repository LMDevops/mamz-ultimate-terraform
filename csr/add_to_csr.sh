#!/bin/bash
clear
#
echo "*** Checking system"
#
if [[ $(uname -a | grep -i 'Linux cs') ]]
then
  echo "*** CloudShell detected"
  export CLOUD_SHELL="TRUE"
  echo
  SEED_PROJECT_ID=$(gcloud projects list | grep seed | grep PROJECT_ID | awk 'NR==1 {print $2}')
else
  echo "*** Not running in CloudShell"
  export CLOUD_SHELL="FALSE"
  echo
  SEED_PROJECT_ID=$(gcloud projects list | grep seed | awk 'NR==1 {print $1}')  
fi
#
# Create Enable API and Repo
echo "*** Enabling CSR API and creating SADA Foundation repo"
gcloud services enable sourcerepo.googleapis.com --project $SEED_PROJECT_ID
gcloud source repos create sada-foundation --project $SEED_PROJECT_ID
git init
#
# Set CSR credentials
echo "*** Set CSR credentials"
git config --global credential.https://source.developers.google.com.helper gcloud.sh
#
# Push to CSR sada-foundation Repo
echo "*** Push local foudnation code to CSR repo"
git remote add google https://source.developers.google.com/p/$SEED_PROJECT_ID/r/sada-foundation
git add .
git commit -m 'initial commit'
git push --all google
#