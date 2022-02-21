#!/bin/bash

######
## 0-prep
######

# Update these variables per your environment
export DOMAIN="CHANGE_ME"
export BILLING_ACCT="CHANGE_ME"
export ORGANIZATION="CHANGE_ME"
export REGION=US-WEST1     # Region to deploy the initial subnets

export USE_BUS_CODE="TRUE" # Set to FALSE to remove the Business Code requirement
export BUS_CODE=zzzz       # Leave like this if USE_BUS_CODE is set to FALSE.
export APP_NAME=app1

###
# Build some variables
# NOTE: These groups should already exist!
###

export BUS_CODE_L=$(echo "$BUS_CODE" | tr '[:upper:]' '[:lower:]')
export APP_NAME_L=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
export REGION_L=$(echo "$REGION" | tr '[:upper:]' '[:lower:]')



# Example: grp-gcp-t101-prj-term-admins@cyberdyne.com
export ADMINS="gcp-admins@$DOMAIN"
#export DEVELOPERS="grp-gcp-$BUS_CODE_L-prj-$APP_NAME_L-developers@$DOMAIN"
export DEVELOPERS="gcp-developers@$DOMAIN"
export DEV_OPS="gcp-devops@$DOMAIN"

export O_ADMINS="gcp-organization-admins@$DOMAIN"
export N_ADMINS="gcp-network-admins@$DOMAIN"
export B_ADMINS="gcp-billing-admins@$DOMAIN"
export SEC_ADMINS="gcp-security-admins@$DOMAIN"

export SUP_ADMINS="gcp-support-admins@$DOMAIN"
export AUDITORS="gcp-auditors@$DOMAIN"




echo 
echo ... Make sure the following groups already exist
echo $ADMINS
echo $DEVELOPERS
echo $DEV_OPS
echo
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
# Replace default values
###
echo "*** Replacing Business Code"
if [[ $USE_BUS_CODE == "TRUE" ]]
then
  egrep -lRZ 'bc-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/bc-change_me/$BUS_CODE_L/g"
elif [[ $USE_BUS_CODE == "FALSE" ]]
then
  egrep -lRZ '\$\{local.business_code}-' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs -r -0 -l sed -i -e 's/${local.business_code}-//g'
  egrep -lRZ '\$\{local.business_code}_' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . |  xargs -r -0 -l sed -i -e 's/${local.business_code}_//g'
  sed -i -e 's/${local.resource_base_name}-//g' modules/bootstrap_setup/locals.tf
else
  echo
  echo ":( Invalid Business Code Usage value, exiting."
  echo
  exit 0;
fi


echo "*** App Name"
egrep -lRZ 'app-change_me' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/app-change_me/$APP_NAME_L/g"

echo "*** Replacing Domain and Org"
egrep -lRZ 'example.com' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/example\.com/$DOMAIN/g"
egrep -lRZ '000000000000' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/000000000000/$ORGANIZATION/g"

echo "*** Replacing Region"
egrep -lRZ 'US-WEST1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/US-WEST1/$REGION/g"
egrep -lRZ 'us-west1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -r -0 -l sed -i -e "s/us-west1/$REGION_L/g"


echo "*** Building .tfvars files"
######
## 1-bootstrap
######


cat <<EOF > ./1-bootstrap/terraform.tfvars
billing_account = "$BILLING_ACCT"
organization_id = "$ORGANIZATION"
users           = ["group:$ADMINS"]
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
