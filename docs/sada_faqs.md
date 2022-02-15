# Frequently encountered scenarios and questions (SADA ONLY)

## Walkthrough videos
  - [Part 1 - Structure](https://www.loom.com/share/405a2965229543f2a974e039a2a5f312?sharedAppSource=team_library) 
  - [Part 2 - Deployment](https://www.loom.com/share/cfb5055693b740d4a227adf54a857bc8?sharedAppSource=team_library)

## Getting started with the CE-Led foundation

- [Getting started](getting_started_fast.md)

## Getting the Foundation V2 Repo to the customer
- Create the TGZ to send to customer and cleanup the repo:
```bash
git clone git@github.com:sadasystems/proserv-foundations.git
cd proserv-foundation
./package_for_customer.sh
mv sada-foundation.tgz ..
rm -rf sada-foundation
```
- Copy the .tgz file to your SADA Google Drive
- Send link to customer (viewer)
- Customer can now extract it where the code will be executed.
  - Strongly suggest this is done in CloudShell
- Make sure the customer commits the changes to a Git Repo to keep their configuration.
  - use CSR script in CSR fodler

## Foundation V2 Material

- Run book: https://docs.google.com/document/d/12t9TsbVwGFIUc0D0I263NqgT3m_pch1PiproqfWCo0M/edit#
- IAM Workseet: https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0
- ProServ catalog - Foundation delivery: https://drive.google.com/drive/folders/1_wvltngtAzICIa6nhrZBMgXYX5I7XDcD?usp=sharing

## Foundation checklist from Google

- https://cloud.google.com/docs/enterprise/setup-checklist

## SADA LZ Tracker

- https://docs.google.com/spreadsheets/d/1Lt9lJvPKLFRipeHZ75ATdvPhHlHG4U2KIlo9bRFq_XQ/edit#gid=773667172

## Security items included in a Foundation

- https://docs.google.com/document/d/1JozGlSWxfNOVYivqCCalTkpNYuO2woBHZdusWIcq-0Q/edit#

## Network Foundation JSON Generator

- https://r-teller.github.io/terraform-google-foundation-network/

## IAM roles per group name in Foudnation

- https://docs.google.com/spreadsheets/d/1Ghv9MGBZHAgFZfXE5BVQTO8RuBnZIZyZ_H8jb3MFsLo/edit#gid=0

## Adding the Foundation code to Cloud Source Repository

- [Adding foundation code to CSR](../csr/README.md)
