import json
import requests
import os
from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials

# Email of the Service Account
# SERVICE_ACCOUNT_EMAIL = '<some-id>@developer.gserviceaccount.com'
# SERVICE_ACCOUNT_EMAIL = 'testing@sada-cf-admin-prj-003.iam.gserviceaccount.com'
SERVICE_ACCOUNT_EMAIL = os.environ['ADMIN_SA']+'@' + \
    os.environ['ADMIN_PROJECT_ID'] + '.iam.gserviceaccount.com'


# Path to the Service Account's Private Key file
SERVICE_ACCOUNT_PKCS12_FILE_PATH = './'+os.environ['ADMIN_SA']+'.p12'


def create_directory_service(user_email):
    """Build and returns an Admin SDK Directory service object authorized with the service accounts
    that act on behalf of the given user.

    Args:
      user_email: The email of the user. Needs permissions to access the Admin APIs.
    """

    credentials = ServiceAccountCredentials.from_p12_keyfile(
        SERVICE_ACCOUNT_EMAIL,
        SERVICE_ACCOUNT_PKCS12_FILE_PATH,
        'notasecret',
        scopes=['https://www.googleapis.com/auth/admin.directory.group'])

    credentials = credentials.create_delegated(user_email)
    service = build('admin', 'directory_v1', credentials=credentials)
    # print(result)

    groups = [
        'gcp-billing-admins',
        'gcp-network-admins',
        'gcp-organization-admins',
        'gcp-auditors',
        'gcp-security-admins',
        'gcp-support-admins'
    ]

    for i in range(len(groups)):

        group = {  # JSON template for Group resource in Directory API.
            "nonEditableAliases": [  # List of non editable aliases (Read-only)
            ],
            "kind": "admin#directory#group",  # Kind of resource this is.
            "description": "A String",  # Description of the group
            "name": groups[i],  # Group name
            # Is the group created by admin (Read-only) *
            "adminCreated": True,
            "directMembersCount": "5",  # Group direct members count

            "email": groups[i]+"@"+os.environ['DOMAIN'],  # Email of Group
            "aliases": [  # List of aliases (Read-only)
            ],
        }
        group_add = service.groups().insert(body=group).execute()
        print(group_add)

    # return build('admin', 'directory_v1', credentials=credentials)


create_directory_service(os.environ['ADMIN_EMAIL'])
