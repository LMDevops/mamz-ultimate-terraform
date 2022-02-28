# Table of Contents

1. [Pre-Reqs](#Pre-Requisites)
2. [Terraform Variables](#Terraformtfvars)
3. [Execution](#Execution)
4. [Customize Parameters](#Customize-Parameters)
5. [Post-Deployment](#Post-Deployment)

# Pre-Requisites

1. Permissions
   Make sure the **GCP User** who runs the script has the following roles at the org level:

- BILLING ACCOUNT ADMIN
- ORG ADMIN
- Folder Admin
- ORG POLICY ADMIN
- Project creator

2. Groups
   Step 1 will attempt to create IAM bindings for groups in the GCP organization. These groups MUST exist prior to running step 1. The `0-prep.sh` script should automate these steps.

** Head to the Execution section if you want to skip explanation of the scripts **

# Terraform.tfvars

In each section (1-7) there is a **terraform.tfvars.example** file that needs to be copied to **terraform.tfvars** and filled-in with all the required information.

- The `0-prep.sh` script consolidates all the changes needed in the Terraform code into one script. Open this script as well and edit the top section.

**NOTE**: It is recommended to commit the changes after editing the `groups-prep.sh` & `0-prep.sh` files and **before** executing the `auto_deploy.sh` script below. This allows for easy rollback if needed.

The Domain, BILLING and ORG informations can get gathered on screen for you if you run the `get-gcp-infos.sh` script.

```bash
# Update these variables IN THE PREP SCRIPTS per your environment. Lines 38-46 are just an example.
export DOMAIN="CHANGE_ME"
export BILLING_ACCT="CHANGE_ME"
export ORGANIZATION="CHANGE_ME"
export REGION=US-WEST1     # Region to deploy the initial subnets
export ADMIN_PROJECT_ID="CHANGE_ME" # Used for group creation

export USE_BUS_CODE="TRUE" # Set to FALSE to remove the Business Code requirement
export BUS_CODE=zzzz       # Leave like this if USE_BUS_CODE is set to FALSE
export APP_NAME=app1
```

The specific changes can be found in (the section below)[#customize-parameters]

Additionally, the group names can be altered by editing the names in the `0-prep.sh` script.

# Execution

## Update 0-prep.sh then run it

This will create an Admin API project, credentials for access, organization level groups and replace variables across the TF code.

```bash
nano 0-prep.sh
./0-prep.sh
```

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

The menu will allow for selection of what to deploy. The runtime is around 20 minutes if you select ALL.

## Add code to Cloud Source Repository

```bash
gcloud config set project PROJECT_ID
csr/add_to_csr.sh
```

## Destroy

To destroy everything that was deployed.

```bash
./destroy.sh
```

To destroy from a specific step

```bash
./destroy.sh [Step Number]
```

# Customize Parameters

## Business Code and App Name

- business_code = A department ID (eg. 90210) - This helps ensure project global uniqueness
- app_name = The name of the app we are creating this structure for. (i.e.: coolgm)

- locals.tf files to change:

  - shared/locals.tf: business_code = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  - 4-dev/locals.tf: app_name = "app-change_me" # APP_CHANGE_ME - Limit to 6 characters
  - 4-dev/locals.tf: business_code = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  - 5-qa/locals.tf: app_name = "app-change_me" # APP_CHANGE_ME - Limit to 6 characters
  - 5-qa/locals.tf: business_code = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  - 6-uat/locals.tf: app_name = "app-change_me" # APP_CHANGE_ME - Limit to 6 characters
  - 6-uat/locals.tf: business_code = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  - 7-prod/locals.tf: app_name = "app-change_me" # APP_CHANGE_ME - Limit to 6 characters
  - 7-prod/locals.tf: business_code = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters
  - modules/bootstrap_setup/locals.tf: resource_base_name = "bc-change_me" # BC_CHANGE_ME - Limit to 4-6 caracters

- **Quick Search and Replace Example (Recursive):** (The `0-prep.sh` script does this)

```bash
export BUS_CODE=t100
export APP_NAME=term
export BUS_CODE_L=$(echo "$BUS_CODE" | tr '[:upper:]' '[:lower:]')
export APP_NAME_L=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
egrep -lRZ 'bc-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/bc-change_me/$BUS_CODE_L/g"
egrep -lRZ 'app-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/app-change_me/$APP_NAME_L/g"
```

## Networking Region

If you need to change the default REGION for the Shared VPC. It's all in the JSON files.

- 3-shared/config/networking/\*.json

  - dev.json: "name" : "sb-p-shared-base-**us-west1**-net1",
  - dev.json: "region": "**US-WEST1**",
  - dev.json: "region": "**US-WEST1**",
  - prod.json: "name" : "sb-p-shared-base-**us-west1**-net1",
  - prod.json: "region": "**US-WEST1**",
  - prod.json: "region": "**US-WEST1**",
  - qa.json: "name" : "sb-p-shared-base-**us-west1**-net1",
  - qa.json: "region": "**US-WEST1**",
  - qa.json: "region": "**US-WEST1**",
  - uat.json: "name" : "sb-p-shared-base-**us-west1**-net1",
  - uat.json: "region": "**US-WEST1**",
  - uat.json: "region": "**US-WEST1**",

- **Quick Search and Replace Example:**

```bash
export REGION=US-CENTRAL1
export REGION_L=$(echo "$REGION" | tr '[:upper:]' '[:lower:]')
egrep -lRZ 'US-WEST1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/US-WEST1/$REGION/g"
egrep -lRZ 'us-west1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/us-west1/$REGION_L/g"
```

# Post-Deployment

## Billing Export

- From the Billing / Billing export menu
  - For **Standard usage cost**, **Detailed usage cost** and **Pricing**
    - Select the bqds_s_xxxx_billing_data Dataset from the prj-xxxx-s-log-mon project as the target
- With this in place, you can create a Datastudio dashboard to visualize your spend over time.
  - https://cloud.google.com/billing/docs/how-to/visualize-data

## Budgets & Alerts

- From Billing / Budgets & alerts
  - Set a basic Budget for all Projects and Services
    - i.e.: Target amount = $1000
  - Hit Finish

## Logging

- Centralized VPC Flow Logs:
  - From the **prj-xxxx-s-log-mon** project, go to Logging / Logs Storage
    - You can see the VPC Flow Logs Storage bucket there
- Viewing the VPC Flow Logs:
  - From the **prj-xxxx-s-svpc** project, go to Logging / Logs Explorer
    - From the Query Window
      ```bash
      resource.type="gce_subnetwork"
      logName="projects/prj-xxxx-s-svpc/logs/compute.googleapis.com%2Fvpc_flows"
      ```
    - You won't see any logs unless you have flow logs turned on for a subnet and actually have traffic traversing said subnet.

## Monitoring

- From the **prj-xxxx-s-log-mon** project, go to Monitoring / Settings
  - Click **Add GCP Projects**
    - Select all the Foudation Projects
    - In Select Scoping Project, select _Use this project as the scoping project_
      Click Add Projects then click Confirm
- The **prj-xxxx-s-log-mon** projects is now your Monitoring hub for all selected projects. You can now start setting up Dashboards and Alerts.

## Security Command Center

- From Security / Security Command Center menu
  - Enable the Free version of SCC for the Organization
