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
# Remove repo
echo "*** Remove SADA Foundation repo"
gcloud source repos delete sada-foundation --project $SEED_PROJECT_ID --quiet
#