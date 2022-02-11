# Leveraging Cloud Source Repository (CSR)

This folder contains the script to create a Source Repository in the Bootstrap project on GCP and store the code from this foundation for future use.

# Deployment

- From root folder of repo
  - gcloud config set project PROJECT_ID
  - csr/add_to_csr.sh

# Removal

- From root folder of repo
  - gcloud config set project PROJECT_ID
  - csr/remove_from_csr.sh
