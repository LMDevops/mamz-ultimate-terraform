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
# Remove repo
echo "*** Remove SADA Foundation repo"
gcloud source repos delete sada-foundation --project $PROJECT_ID --quiet
#