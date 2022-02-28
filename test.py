import json
import requests
from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials

# Email of the Service Account
# SERVICE_ACCOUNT_EMAIL = '<some-id>@developer.gserviceaccount.com'
SERVICE_ACCOUNT_EMAIL = 'testing@sada-cf-admin-prj-003.iam.gserviceaccount.com'


# Path to the Service Account's Private Key file
SERVICE_ACCOUNT_PKCS12_FILE_PATH = './sada-cf-test.p12'


def create_directory_service(user_email):
    """Build and returns an Admin SDK Directory service object authorized with the service accounts
    that act on behalf of the given user.

    Args:
      user_email: The email of the user. Needs permissions to access the Admin APIs.
    Returns:
      Admin SDK directory service object.
    """

    credentials = ServiceAccountCredentials.from_p12_keyfile(
        SERVICE_ACCOUNT_EMAIL,
        SERVICE_ACCOUNT_PKCS12_FILE_PATH,
        'notasecret',
        scopes=['https://www.googleapis.com/auth/admin.directory.group'])

    credentials = credentials.create_delegated(user_email)
    service = build('admin', 'directory_v1', credentials=credentials)
    result = service.groups().list(customer='my_customer').execute()
    # print(result)
    group = {  # JSON template for Group resource in Directory API.
        "nonEditableAliases": [  # List of non editable aliases (Read-only)
            "A String",
        ],
        "kind": "admin#directory#group",  # Kind of resource this is.
        "description": "A String",  # Description of the group
        "name": "A String",  # Group name
        # Is the group created by admin (Read-only) *
        "adminCreated": True,
        "directMembersCount": "5",  # Group direct members count

        "email": "test4@cf-0003.sadaess.com",  # Email of Group
        "aliases": [  # List of aliases (Read-only)
            "A String",
        ],
    }
    group_add = service.groups().insert(body=group).execute()
    print(group_add)

    # return build('admin', 'directory_v1', credentials=credentials)


create_directory_service("barclay@cf-0003.sadaess.com")
