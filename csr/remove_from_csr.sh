#!/bin/bash
clear
#
# Get SEED project ID
echo "*** Get SEED Project ID"
export PROJECT_ID=$(gcloud projects list | grep tfseed | awk ''NR==1' {print $2}')
echo "SEED Project ID:" $PROJECT_ID
#
# Remove repo
echo "*** Remove SADA Foundation repo"
gcloud source repos delete sada-foundation --project $PROJECT_ID --quiet
#