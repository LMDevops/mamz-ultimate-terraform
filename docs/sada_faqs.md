# Frequently encountered scenarios and questions (SADA ONLY)

## Walkthrough videos
  - [Part 1 - Structure](https://www.loom.com/share/6e69ea7b03bb42a48fb0219d200d3600?sharedAppSource=team_library) 
  - [Part 2 - Customization](https://www.loom.com/share/de0d92fecfe1480496e6aa4201b10dab?sharedAppSource=team_library)
  - [Part 3 - Execution](https://www.loom.com/share/b74e5151c22041adb0abb7c30869b9af?sharedAppSource=team_library)
  - [Part 4 - Post-Deployment](https://www.loom.com/share/d5610da0e9e04138800a8461b346002f?sharedAppSource=team_library)

## Getting started with this Foundation

- [Getting started](getting_started_fast.md)

## Getting the Foundation V2 Repo to the customer
- Create the TGZ to send to customer and cleanup the repo:
```bash
git clone git@github.com:sadasystems/proserv-foundations.git
cd proserv-foundation
./package_for_customer.sh
```
- Copy the .tgz file to your SADA Google Drive
- Send link to customer (viewer)
- Customer can now extract it where the code will be executed.
  - **Strongly suggest this is done in CloudShell**
- Make sure the customer commits the changes to a Git Repo to keep their configuration.
  - use **add_to_csr.sh** script in CSR folder if needed.

## Foundation V2 Material

- Run book: https://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M/edit#
- IAM Workseet: https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0
- ProServ catalog - Foundation delivery: https://drive.google.com/drive/folders/1_wvltngtAzICIa6nhrZBMgXYX5I7XDcD?usp=sharing
- Quickstart Proposal: https://docs.google.com/presentation/d/1qxwVw-qW2RfJBclE__I__z4rIOqhTYP2M7Rytl3mSYc/edit?usp=sharing 

## Foundation checklist from Google

- https://cloud.google.com/docs/enterprise/setup-checklist

## SADA LZL Tracker (CE)

- https://docs.google.com/spreadsheets/d/1Lt9lJvPKLFRipeHZ75ATdvPhHlHG4U2KIlo9bRFq_XQ/edit#gid=773667172

## Security items included in a Foundation

- https://docs.google.com/document/d/1JozGlSWxfNOVYivqCCalTkpNYuO2woBHZdusWIcq-0Q/edit#

## Network Foundation JSON Generator

- https://r-teller.github.io/terraform-google-foundation-network/

## IAM roles per group name in Foudnation

- https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0

## Adding the Foundation code to Cloud Source Repository

- [Adding foundation code to CSR](../csr/README.md)
