#!/bin/bash
clear

####
# **Update these variables
####

export ADMIN_EMAIL="CHANGE_ME" # The email address of a user with Google Admin access. Typically this is the user deploying the foundation

# Update these variables per your GCP environment
export DOMAIN="CHANGE_ME"       # Your User verified Domain for GCP
export BILLING_ACCT="CHANGE_ME" # Your GCP BILLING ID (SADA Sub-Account or Direct ID);
export ORGANIZATION="CHANGE_ME" # Your GCP ORG ID
export REGION=US-WEST1          # Region to deploy the initial subnets
export USE_BUS_CODE="FALSE"      # Set to FALSE to remove the Business Code requirement
export BUS_CODE=zzzz            # The Department code or cost center associated with this Foudnation ; Leave like this if you've set USE_BUS_CODE to FALSE ; 
export APP_NAME=app1            # Short name of your workload

######
## 0.5-prep
######

# Getting the Project ID of the project that is authorized to make Workspace API calls
#
# Determine architecture CloudShell or raw Linux
#
echo "*** Checking system"

if [[ $(uname -a | grep -i 'Linux cs') ]]
then
  echo "*** CloudShell detected"
  export CLOUD_SHELL="TRUE"
  echo
  GCP_WS_PROJECT_ID=$(gcloud projects list | grep foundation-workspace | grep PROJECT_ID | awk 'NR==1 {print $2}')
else
  echo "*** Not running in CloudShell"
  export CLOUD_SHELL="FALSE"
  echo
  GCP_WS_PROJECT_ID=$(gcloud projects list | grep foundation-workspace | awk 'NR==1 {print $1}')  
fi

# Set the admin project ID
export ADMIN_PROJECT_ID=$GCP_WS_PROJECT_ID
# Name of service account
export ADMIN_SA="sa-admin-caller"

echo "** Checking python version"
if [[ $CLOUD_SHELL == "TRUE" ]];
then 
  export USE_PYTHON3="TRUE"
fi

if [[ $CLOUD_SHELL == "FALSE" ]];
then
  py3=$(python3 --version | wc -l);
  if [[ $py3 -eq 1 ]];
  then 
    export USE_PYTHON3="TRUE"
  fi
fi

printf "** Attempting to create groups via the python script.\n\n"

if [[ $USE_PYTHON3 == "TRUE" ]];
then
  python3 ./create_groups.py
else
  python ./create_groups.py
fi 

if [[ $? != 0 ]];
then
  echo "** Group creation script failed"
  exit 1
else
  echo "** Groups created"
fi

###
# Build some variables
# NOTE: These groups should already exist!
###
export BUS_CODE_L=$(echo "$BUS_CODE" | tr '[:upper:]' '[:lower:]')
export APP_NAME_L=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
export REGION_L=$(echo "$REGION" | tr '[:upper:]' '[:lower:]')


# Example: grp-gcp-t101-prj-term-admins@cyberdyne.com
export ADMINS="gcp-$APP_NAME-admins@$DOMAIN"
#export DEVELOPERS="grp-gcp-$BUS_CODE_L-prj-$APP_NAME_L-developers@$DOMAIN"
export DEVELOPERS="gcp-$APP_NAME-developers@$DOMAIN"
export DEV_OPS="gcp-$APP_NAME-devops@$DOMAIN"
#
export O_ADMINS="gcp-organization-admins@$DOMAIN"
export N_ADMINS="gcp-network-admins@$DOMAIN"
export B_ADMINS="gcp-billing-admins@$DOMAIN"
export SEC_ADMINS="gcp-security-admins@$DOMAIN"
export SUP_ADMINS="gcp-support-admins@$DOMAIN"
export AUDITORS="gcp-auditors@$DOMAIN"


echo 
echo ... Make sure the following groups already exist
echo
echo $ADMINS
echo $DEVELOPERS
echo $DEV_OPS
echo $B_ADMINS
echo $O_ADMINS
echo $N_ADMINS
echo $SUP_ADMINS
echo $AUDITORS
echo $SEC_ADMINS
echo
echo ...
echo 
echo  "Press a key when ready. Next steps will not be idempotent"
read  -n 1


###
# Determine architecture of execution context
###
echo "*** Checking system"

if [[ $(uname -a | grep Linux) ]]
then
  echo "*** Linux machine detected"
  echo
  export MAC_OS="FALSE"
elif [[ $(uname -a | grep Darwin) ]]
then
  echo "*** Macintosh machine detected"
  echo
  export MAC_OS="TRUE"
else
  echo "*** Could not determine system architecture. Scripts will use Linux variants in this case."
fi


###
# Replace default values
###
echo "*** Replacing Business Code"
echo
if [[ $USE_BUS_CODE == "TRUE" ]]
then
  if [ $MAC_OS == "TRUE" ]; then
    egrep -lRZ 'bc-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs sed -i -e "s/bc-change_me/$BUS_CODE_L/g"
  else
    egrep -lRZ 'bc-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/bc-change_me/$BUS_CODE_L/g"    
  fi
elif [[ $USE_BUS_CODE == "FALSE" ]]
then
  if [ $MAC_OS == "TRUE" ]
  then
    egrep -lRZ '\$\{local.business_code}-' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs sed -i -e 's/${local.business_code}-//g'
    egrep -lRZ '\$\{local.business_code}_' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs sed -i -e 's/${local.business_code}_//g'
    sed -i -e 's/${local.resource_base_name}-//g' modules/bootstrap_setup/locals.tf
  else
    egrep -lRZ '\$\{local.business_code}-' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs -r -0 -l sed -i -e 's/${local.business_code}-//g'
    egrep -lRZ '\$\{local.business_code}_' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs -r -0 -l sed -i -e 's/${local.business_code}_//g'    
    sed -i -e 's/${local.resource_base_name}-//g' modules/bootstrap_setup/locals.tf
  fi
else
  echo
  echo ":( Invalid Business Code Usage value, exiting."
  echo
  exit 0;
fi


echo "*** Replacing App Name"
echo
if [ $MAC_OS == "TRUE" ]
then
  egrep -lRZ 'app-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs sed -i -e "s/app-change_me/$APP_NAME_L/g"
else
  egrep -lRZ 'app-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/app-change_me/$APP_NAME_L/g"
fi


echo "*** Replacing Domain and Org"
echo
if [ $MAC_OS == "TRUE" ]
then
  egrep -lRZ 'example.com' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | LC_ALL=C xargs sed -i "" -e "s/example\.com/$DOMAIN/g"
  egrep -lRZ '000000000000' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | LC_ALL=C xargs sed -i "" -e "s/000000000000/$ORGANIZATION/g"
else
  egrep -lRZ 'example.com' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/example\.com/$DOMAIN/g"
  egrep -lRZ '000000000000' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/000000000000/$ORGANIZATION/g"
fi


echo "*** Replacing Region"
echo
if [ $MAC_OS == "TRUE" ]
then
  egrep -lRZ 'US-WEST1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs sed -i -e "s/US-WEST1/$REGION/g" #does not throw error
  egrep -lRZ 'us-west1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | LC_ALL=C xargs sed -i "" -e "s/us-west1/$REGION_L/g" #throws error
else
  egrep -lRZ 'US-WEST1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/US-WEST1/$REGION/g"
  egrep -lRZ 'us-west1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/us-west1/$REGION_L/g"
fi


echo "*** Building .tfvars files"
echo
######
## 1-bootstrap
######
cat <<EOF > ./1-bootstrap/terraform.tfvars
billing_account = "$BILLING_ACCT"
organization_id = "$ORGANIZATION"
users           = ["group:$O_ADMINS"]
EOF


######
## 2-organization
######
cat <<EOF > ./2-organization/terraform.tfvars
domain = "$DOMAIN"
organization_id = "$ORGANIZATION"
billing_admin_group  = "$B_ADMINS"
org_admin_group      = "$O_ADMINS"
network_admin_group  = "$N_ADMINS"
support_admin_group  = "$SUP_ADMINS"
auditor_group        = "$AUDITORS"
security_admin_group = "$SEC_ADMINS"
EOF


######
## 3-shared
######
cat <<EOF > ./3-shared/terraform.tfvars
billing_account = "$BILLING_ACCT"

##Groups are created in Google admin and must exist prior to deploying this step.###
billing_admin_group_email = "$B_ADMINS"
network_user_groups = [
  "$N_ADMINS",
  "$DEVELOPERS"
]
EOF


######
## 4-dev
######
cat <<EOF > ./4-dev/terraform.tfvars
billing_account = "$BILLING_ACCT"

##Groups are created in Google admin and must exist prior to deploying this step.###
admin_group_name     = "$ADMINS"
developer_group_name = "$DEVELOPERS"
devops_group_name    = "$DEV_OPS"
EOF


######
## 5-qa
######
cat <<EOF > ./5-qa/terraform.tfvars
billing_account = "$BILLING_ACCT"

##Groups are created in Google admin and must exist prior to deploying this step.###
admin_group_name     = "$ADMINS"
developer_group_name = "$DEVELOPERS"
devops_group_name    = "$DEV_OPS"
EOF


######
## 6-uat
######
cat <<EOF > ./6-uat/terraform.tfvars
billing_account = "$BILLING_ACCT"

##Groups are created in Google admin and must exist prior to deploying this step.###
admin_group_name     = "$ADMINS"
developer_group_name = "$DEVELOPERS"
devops_group_name    = "$DEV_OPS"
EOF


######
## 7-prod
######
cat <<EOF > ./7-prod/terraform.tfvars
billing_account ="$BILLING_ACCT"

##Groups are created in Google admin and must exist prior to deploying this step.###
admin_group_name     = "$ADMINS"
developer_group_name = "$DEVELOPERS"
devops_group_name    = "$DEV_OPS"
EOF


echo "Done..."
echo
