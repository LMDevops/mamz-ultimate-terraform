# terraform-sada-foundation

This is an example repo showing how SADA can use Terraform modules to build a secure GCP foundation, based on the [Google Cloud security foundations guide](https://services.google.com/fh/files/misc/google-cloud-security-foundations-guide.pdf) and combined with SADA best practice.

The supplied structure and code is intended to form a starting point for building your own foundation with pragmatic defaults you can customize to meet your own requirements.

## Overview

This repo contains several distinct Terraform projects each within their own directory that must be applied separately, but in sequence.
Each of these Terraform projects are to be layered on top of each other, running in the following order.

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

#### Monitoring

Under each environment folder, a project is created per environment (`dev`, `prod`, `uat` & `qa`).
Please note that creating the [workspace and linking projects](https://cloud.google.com/monitoring/workspaces/create) can currently only be completed through the Cloud Console.

If you have strong IAM requirements for these monitoring workspaces, it is worth considering creating these at a more granular level, such as per business unit or per application.

#### Networking

Under the shared folder one project is created which contains 4 vpc networks, one per environment (`dev`, `prod`, `qa` & `uat`) which is intended to be used as a [Shared VPC Host project](https://cloud.google.com/vpc/docs/shared-vpc) for all projects in the foundation. The underlying TF modules for creating the networking are complex and thus configuration should be done using the json schema's provided in the "config" folder under shared/networking.

### Networks

VPC networks are deployed per environment with baseline firewall rules and cloud NAT'ing in place. Each network has it's configuration stored in a json schema which can be updated and the terraform re-deployed to customize the network attributes.

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

## Pre-Requisites

The TL;DR Pre-Requisites and customization instructions can be found [here](PRE_REQS-CHECKLISTS.md).
