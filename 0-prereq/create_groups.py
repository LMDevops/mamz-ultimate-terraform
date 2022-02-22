from __future__ import print_function

import os.path
import requests
import json

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build

# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/admin.directory.group']


def main():
    """
      Create groups required for foundation deployment
    """
    creds = None
    print('main called')
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'desktop-creds.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    # service = build('admin', 'directory_v1', credentials=creds)

    # Call the Admin SDK Directory API

    # print(creds.to_json())
    creds = creds.to_json()
    creds = json.loads(creds)
    # print("####################", creds['token'])

    groups = ['grp-gcp-it-org-billing-admins', 'grp-gcp-it-org-network-admins', 'grp-gcp-it-org-organization-admins',
              'grp-gcp-it-org-auditors', 'grp-gcp-it-org-security-admins', 'grp-gcp-it-org-support-admins']
    for i in range(0, len(groups)):

        data = {
            "email": groups[i] + "@cf-0003.sadaess.com",
            "name": groups[i],
            "aliases": [
            ],
            "nonEditableAliases": [
            ]
        }
        headers = {"Authorization": "Bearer " + creds['token']}
        result = requests.post(
            'https://admin.googleapis.com/admin/directory/v1/groups', json=data, headers=headers)

        result = json.loads(result.text)
        print(result)
        # print(result['error']['code'])
        # print(result['error'])


if __name__ == '__main__':
    main()
