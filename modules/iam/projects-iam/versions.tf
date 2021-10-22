terraform {
  required_version = ">= 0.15.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.45, < 4.0"
    }
  }
}