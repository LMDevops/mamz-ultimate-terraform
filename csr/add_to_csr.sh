#!/bin/bash
clear
#
# Get SEED project ID
echo "*** YOUR PROJECTS"
gcloud projects list
echo -n "Enter your SEED Project ID: "
read PROJECT_ID
clear
#
# Create Enable API and Repo
echo "*** Enabling CSR API and creating SADA Foundation repo"
gcloud services enable sourcerepo.googleapis.com --project $PROJECT_ID
gcloud source repos create sada-foundation --project $PROJECT_ID
git init
#
# Set CSR credentials
echo "*** Set CSR credentials"
git config --global credential.https://source.developers.google.com.helper gcloud.sh
#
# Push to CSR sada-foundation Repo
echo "*** Push local foudnation code to CSR repo"
git remote add google https://source.developers.google.com/p/$PROJECT_ID/r/sada-foundation
git add .
git commit -m 'initial commit'
git push --all google
#