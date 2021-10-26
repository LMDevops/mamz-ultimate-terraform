terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.49.0"
    }
    null = {
      source = "hashicorp/null"
    }
    template = {
      source = "hashicorp/template"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}
