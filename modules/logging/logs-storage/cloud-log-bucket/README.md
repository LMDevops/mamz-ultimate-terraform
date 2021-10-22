# Log Export: Cloud bucket destination submodule

This submodule allows you to configure a Cloud Logging bucket destination that
can be used by the log export created in the root module.

## IMPORTANT NOTE

This resource will NOT be deleted when a terraform destroy is issued. You can run the destroy, but go back in the console
and delete the bucket manually.

## Usage

Consider the following
example that will configure a storage bucket destination and a log export at the project level:

```hcl
module "log_export" {
  source                 = "../modules/logging/logs-storage/cloud-log-bucket"
  destination_uri        = module.destination.destination_uri
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = "sample-project"
  parent_resource_type   = "organization"
  unique_writer_identity = true
}

module "destination" {
  source                   = "../modules/logging/log-router"
  project_id               = "sample-project"
  bucket_id                = "sample_cloud_bucket"
  log_sink_writer_identity = module.log_export.writer_identity
}
```

At first glance that example seems like a circular dependency as each module declaration is
using an output from the other, however Terraform is able to collect and order all the resources
so that all dependencies are met.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location of the cloud logging bucket. | `string` | `"global"` | no |
| log\_sink\_writer\_identity | The service account that logging uses to write log entries to the destination. (This is available as an output coming from the root module). | `string` | n/a | yes |
| project\_id | The ID of the project in which the storage bucket will be created. | `string` | n/a | yes |
| retention\_days | Log retention in days. |  `number`  | `null` | no |
| bucket\_id | The name of the cloud bucket to be created and used for log entries matching the filter. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination\_uri | The destination URI for the cloud storage bucket. |
| project | The project in which the cloud logging bucket was created. |
| resource\_id | The resource id for the destination cloud storage bucket |
| resource\_name | The resource name for the destination cloud storage bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
