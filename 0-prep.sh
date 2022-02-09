#!/bin/bash

######
## 0-prep
######

# Update these variables per your environment
export DOMAIN="techjunkie4hire.com"
export BILLING_ACCT="0104BF-0E14A9-484586"
export ORGANIZATION="907565456311"
export REGION=NORTHAMERICA-NORTHEAST2

export BUS_CODE=zzz
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
echo "Replacing Business Code and App Name"
echo 'An "illegal byte sequence" error can be ignored.'

egrep -lRZ 'zzzz' --exclude="*.md" --exclude="*.sh" --exclude="*.example" .         | xargs -0 -l sed -i -e "s/zzzz/$BUS_CODE_L/g"
egrep -lRZ 'app1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" .         | xargs -0 -l sed -i -e "s/app1/$APP_NAME_L/g"

echo "Replacing Domain and Org"
egrep -lRZ 'example.com' --exclude="*.md" --exclude="*.sh" --exclude="*.example" .  | xargs -0 -l sed -i -e "s/example\.com/$DOMAIN/g"
egrep -lRZ '000000000000' --exclude="*.md" --exclude="*.sh" --exclude="*.example" . | xargs -0 -l sed -i -e "s/000000000000/$ORGANIZATION/g"

echo "Replacing Region"
egrep -lRZ 'US-WEST1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" .     | xargs -0 -l sed -i -e "s/US-WEST1/$REGION/g"
egrep -lRZ 'us-west1' --exclude="*.md" --exclude="*.sh" --exclude="*.example" .     | xargs -0 -l sed -i -e "s/us-west1/$REGION_L/g"


echo "Building .tfvars files"
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
