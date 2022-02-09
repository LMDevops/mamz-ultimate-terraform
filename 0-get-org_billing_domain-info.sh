#!/bin/bash
#
clear
echo "*** YOUR PROJECTS"
gcloud projects list
echo -n "Enter any GCP project ID: "
read GCP_PROJECT_ID
clear
#
echo
echo "*** YOUR ORGANIZATIONS"
gcloud organizations list
#
echo
echo "*** YOUR BILLING ACCOUNTS"
gcloud beta billing accounts list
#
echo
echo "*** YOUR USER VERIFIED DOMAINS"
gcloud domains list-user-verified --project $GCP_PROJECT_ID
#