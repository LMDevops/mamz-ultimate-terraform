# Table of Contents
1. [Material](#Foundation-V2-Material)
2. [Pre-Reqs](#Pre-Requisites)
3. [Repo](#Getting-the-Foundation-V2-Repo-to-the-customer)
4. [Terraform Variables](#Terraformtfvars)
5. [Customization](#Customize-Business-Code-App-Name-and-Networking)
6. [Execution](#Execution)

# Foundation V2 Material

- Run book: https://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M/edit#
- IAM Workseet: https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0
- ProServ catalog - Foundation delivery: https://drive.google.com/drive/folders/1_wvltngtAzICIa6nhrZBMgXYX5I7XDcD?usp=sharing
- Walkthrough video: https://www.loom.com/team-videos/Foundation 

# Pre-Requisites

- Make sure the **GCP User** who runs the script has **BILLING ACCOUNT ADMIN**, **ORG ADMIN**, **Folder Admin** and **ORG POLICY ADMIN** roles and is already in all the **Billing**, **Org** and **Network** admins groups.

# Getting the Foundation V2 Repo to the customer
- Prep:
```bash
git clone git@github.com:sadasystems/proserv-foundations.git
rm -rf ./proserv-foundations/.git
mv proserv-foundations sada-foundation
tar czvf sada-foundation.tgz sada-foundation
```
- Copy the .tgz file to your SADA Google Drive
- Send link to customer (viewer)
- Customer can now extract it where the code will be executed.
  - Make sure the customer commits the changes to a Git Repo to keep their configuration.

# Terraform.tfvars

In each section (1-7) there is a **terraform.tfvars.example** file that needs to be copied to **terraform.tfvars** and filled-in with all the required information.

The `0-prep.sh` script consolidates all the changes needed into one script. Open this `0-prep.sh` script and edit the top section. **NOTE**: It is recommended to commit the changes after editing this file and **before** executing the `auto_deploy.sh` script below. This allows for easy rollback if needed. 

The Domain, BILLING and ORG informations can get gathered on screen for you if you run the `get-gcp-infos.sh` script.

```bash
export DOMAIN="example.com"
export BILLING_ACCT="111111-222222-333333"
export ORGANIZATION="12345678901"

# Region to deploy the initial subnets
export REGION=US-CENTRAL1

export BUS_CODE=zzz
export APP_NAME=app1
```

The specific changes can be found in (the section below)[#customize-parameters]

Additionally, the group names can be altered by editing the names in the `0-prep.sh` script. 


# Execution

After executing the `0-prep.sh` script, you can now execute the deployment.

## Authenticate to Google
This will set the app credentials required to execute:
```bash
gcloud auth application-default login
```

## Deploy
To start the deployment:
```bash
./auto_deploy.sh
```

The menu will allow for selection of what to deploy.  

## Destroy
To destroy everything that was deployed.
```bash
./destroy.sh
```

To destroy from a specific step
```bash
./destroy.sh [Step Number]
```

For example, to destroy 7-prod and below:
```bash
./destroy.sh 7
```


# Customize Parameters

## Business Code and App Name

- business_code = A department ID (eg. 90210) - This helps ensure project global uniqueness
- app_name = The name of the app we are creating this structure for. (i.e.: coolgm)

- locals.tf files to change:
  - shared/locals.tf:  business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 4-dev/locals.tf:   app_name         = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 4-dev/locals.tf:   business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 5-qa/locals.tf:    app_name         = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 5-qa/locals.tf:    business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 6-uat/locals.tf:   app_name         = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 6-uat/locals.tf:   business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - 7-prod/locals.tf:  app_name         = "app1" # APP_CHANGE_ME - Limit to 6 characters
  - 7-prod/locals.tf:  business_code    = "zzzz" # BC_CHANGE_ME  - Limit to 4-6 caracters
  - modules/bootstrap_setup/locals.tf:  resource_base_name  = "zzzz" # BC_CHANGE_ME - Limit to 4-6 caracters

- **Quick Search and Replace Example (Recursive):** (The `0-prep.sh` script does this replaces.
```bash
export BUS_CODE=T101
export APP_NAME=term
egrep -lRZ 'zzzz' --exclude="*.md" . | xargs sed -i "s/zzzz/$BUS_CODE/g"
egrep -lRZ 'app1' --exclude="*.md" . | xargs sed -i "s/app1/$APP_NAME/g"
```
  - Make sure the **app name (i.e. app1)** is also in your GCP Groups like, i.e.: grp-gcp-it-prj-**app1**-devops@domain.com


## Networking Region

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
```bash
export REGION=us-central1
egrep -lRZ 'US-WEST1' --exclude="*.md" . | xargs -0 -l sed -i -e "s/US-WEST1/$REGION/g"
egrep -lRZ 'us-west1' --exclude="*.md" . | xargs -0 -l sed -i -e "s/us-west1/$REGION/g"
```

