# Foundation V2 Material

- Run book: https://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M/edit#
- IAM Workseet: https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0
- ProServ catalog - Foundation delivery: https://drive.google.com/drive/folders/1_wvltngtAzICIa6nhrZBMgXYX5I7XDcD?usp=sharing


# Pre-Requisites

- Make sure the **GCP User** who runs the script has **BILLING ACCOUNT ADMIN**, **ORG ADMIN** and **ORG POLICY ADMIN** roles and put in the right groups.

# Customize Business Code, App Name and Networking

- business_code = numeric ID (i.e.: 90210)
- app_name = The name of the app we are creating this structure for. (i.e.: app1)

- locals.tf files to change:
  - shared/locals.tf:  business_code  = "zzzz" # BC_CHANGE_ME - Limit to 4-6 caracters
  - 4-dev/locals.tf:  app_name          = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 4-dev/locals.tf:  business_code     = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 5-qa/locals.tf:  app_name           = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 5-qa/locals.tf:  business_code      = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 6-uat/locals.tf:  app_name          = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 6-uat/locals.tf:  business_code     = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 7-prod/locals.tf:  app_name         = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 7-prod/locals.tf:  business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - modules/bootstrap_setup/locals.tf:  resource_base_name  = "zzzz" # BC_CHANGE_ME - Limit to 4-6 caracters

- **Quick Search and Replace Example:**
  - egrep -lRZ 'zzzz' . --exclude=*.md | xargs -0 -l sed -i -e "s/zzzz/***YOUR_NEW_VALUE***/g"
  - egrep -lRZ 'app1' . --exclude=*.md | xargs -0 -l sed -i -e "s/app1/***YOUR_NEW_VALUE***/g"
  - Make sure the **app name (i.e. app1)** is also in your GCP Groups like, i.e.: grp-gcp-it-prj-**app1**-devops@domain.com


## NETWORKING REGION

If you need to change the default REGION for the Shared VPC.  It's all inthe JSON files.

- 3-shared/config/networking/*.json
  - dev.json:  "name" : "sb-p-shared-base-**us-west1**-net1",
  - dev.json:  "region": "**US-WEST1**",
  - dev.json:  "region": "**US-WEST1**",
  - prod.json: "region": "**US-WEST1**",
  - prod.json: "region": "**US-WEST1**",
  - qa.json:   "name" : "sb-p-shared-base-**us-west1**-net1",
  - qa.json:   "region": "**US-WEST1**",
  - qa.json:   "region": "**US-WEST1**",
  - uat.json:  "name" : "sb-p-shared-base-**us-west1**-net1",
  - uat.json:  "region": "**US-WEST1**",
  - uat.json:  "region": "**US-WEST1**",

- **Quick Search and Replace Example:**
  - egrep -lRZ 'US-WEST1' . --exclude=*.md | xargs -0 -l sed -i -e "s/US-WEST1/***YOUR_NAEW_VALUE***/g"
  - egrep -lRZ 'us-west1' . --exclude=*.md | xargs -0 -l sed -i -e "s/us-west1/***YOUR_NEW_VALUE***/g"

## Required credentials to execute auto_deploy.sh
This will set the app credentials required to execute
- gcloud auth application-default login 

or

- gcloud auth application-default login --no-launch-browser

## Getting the Foundation V2 Repo to the customer
- Prep
  - git clone git@github.com:sadasystems/proserv-foundations.git
  - rm -rf ./proserv-foundations/.git
  - mv proserv-foundations sada-foundation
  - tar czvf sada-foundation.tgz sada-foundation
  - Put in your SADA Google Drive
- Send link to customer (viewer)
- Customer can now extract it where the code will be executed.
  - Make sure the customer commits the changes to a Git Repo to keep their configuration.
