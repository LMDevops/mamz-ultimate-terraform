# terraform-gcloud-foundation

This is repo shows how you can use shell scripts & Terraform modules to build a GCP foundation, based on the [Google Cloud security foundations guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf) and combined with the best practices.

The supplied structure and code is intended to form a starting point for building your own foundation with pragmatic defaults you can customize to meet your own requirements.

## Getting Started Fast/Prereqs

The TL;DR Pre-Requisites, customization and execution instructions can be found [here](docs/getting_started_fast.md).

## Overview

This repo contains several distinct Terraform scripts each within their own directory that must be applied separately, but in sequence. The prereqs must be completed before any Terraform is run in the environment. Each of these Terraform scripts are to be layered on top of each other, running in the following order.

### [0. Prereqs](0-prep.sh & 0.5-prep.sh)

**THIS REQUIRES MANUAL STEPS!!**
Currently, GCP offers absolutely no possible means of fully automating group creation end to end in Google workspace. The two options you are left with for automating group creation as much as possible are:

- Creating app credentials for the group creation script and authorizing it in the browser
- Enabling domain wide delegation for a service account in the google admin console (this is the method we'll use)

The **0-prep.sh** & **0.5-prep.sh** scripts will perform all the neccessary steps to prep the environment for applying the Terraform. Make sure the values at the top of the prep scripts are changed to align with your specific environment.

**USER PERMISSION**

Make sure the **GCP User** who runs the Foundation scripts has the following roles at the org level:

- Billing Account User
- Org Admin
- Folder Admin
- Org Policy Admin
- Project Creator
- Compute Shared VPC Admin
- Logging Admin
- Storage Admin
- security admin
- se

### [1. bootstrap](./1-bootstrap/)

This stage executes the Bootstrap module which bootstraps an existing GCP organization.

The bootstrap step includes:

- The `prj-zzzz-b-seed` project, which contains:
  - Terraform state bucket
  - Custom Service Account used by Terraform to create new resources in GCP

After executing this step, you will have the following structure:

```
example-organization/
└── fldr-bootstrap
    └── prj-zzzz-b-tfseed
```

### [2. Organization](./2-organization/)

The purpose of this stage is to set up Org policies, Org level IAM and folder hierarchy.
After executing this step you will have additional folders underneath the organization:

```
example-organization/
├── fldr-bootstrap
├── fldr-dev
├── fldr-prod
├── fldr-qa
├── fldr-shared
└── fldr-uat
```

### [3. Shared](./3-shared/)

This will create tree projects underneath the shared folder:

```
example-organization
└── fldr-shared
    ├── prj-zzzz-s-log-mon
    └── prj-zzzz-s-svpc
    └── prj-zzzz-s-secrets-kms

```

**Notes**:

- For billing data, a BigQuery dataset is created with permissions attached, however you will need to configure a billing export [manually](https://cloud.google.com/billing/docs/how-to/export-data-bigquery), as there is no easy way to automate this at the moment.

#### Logging

- The logging strategy of this foundation is around VPC Flow Logs. Each VPC's and Subnets under the Shared VPCs project send their logs in a Sync hosted in a bucket in the log-mon shared project.

#### Monitoring

- Under each environment folder, a project is created per environment (`dev`, `prod`, `uat` & `qa`).
  Please note that creating the [workspace and linking projects](https://cloud.google.com/monitoring/workspaces/create) can currently only be completed through the Cloud Console.

- If you have strong IAM requirements for these monitoring workspaces, it is worth considering creating these at a more granular level, such as per business unit or per application.

#### Networking

- Under the shared folder one project is created which contains 4 vpc networks, one per environment (`dev`, `prod`, `qa` & `uat`) which is intended to be used as a [Shared VPC Host project](https://cloud.google.com/vpc/docs/shared-vpc) for all projects in the foundation. The underlying TF modules for creating the networking are complex and thus configuration should be done using the json schema's provided in the "config" folder under shared/networking.

### Networks

- VPC networks are deployed per environment with baseline firewall rules and cloud NAT'ing in place. Each network has it's configuration stored in a json schema which can be updated and the terraform re-deployed to customize the network attributes.

### Secrets and KMS

- There is nothing put in place regarding Secrats Management and KMS in this foundation beside a host project dedicated to this task. Both APIs are enabled at project creation.

### [4. dev](./4-dev/)

The purpose of this stage is to set up the environment projects which contain the resources for individual business units.

This will create the following project structure:

```
example-organization
└── fldr-dev
    └── prj-zzzz-d-app1
└── fldr-prod
    └── prj-zzzz-p-app1
└── fldr-qa
    └── prj-zzzz-q-app1
└── fldr-uat
    └── prj-zzzz-u-app1
```

### Final View

Once all steps above have been executed your GCP organization should represent the structure shown below, with projects being the lowest nodes in the tree.

```
example-organization/
└── fldr-bootstrap
    └── prj-zzzz-b-tfseed
└── fldr-dev
    └── prj-zzzz-d-app1
└── fldr-prod
    └── prj-zzzz-p-app1
└── fldr-qa
    └── prj-zzzz-q-app1
└── fldr-uat
    └── prj-zzzz-u-app1
└── fldr-shared
    ├── prj-zzzz-s-log-mon
    ├── prj-zzzz-s-svpc
    └── prj-zzzz-s-secrets-kms
```

### Branching strategy

The foundations repo was meant to be built upon, cut a branch, make an improvement and create a pull request or fork for a different type of foudation entirely using this repo as a starting point.

### Locals vs. tfvars

locals used to deploy the steps have default values, whereas tfvars files do not. Check tfvars files **before deployment** and ensure that it aligns with your needs.
