terraform {
  required_version = "~> 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.10.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 6.10.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}

provider "aws" {
  region = local.aws_region
  default_tags {
    tags = {
      app = local.app_name
      env = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "google" {
  region = local.google_region
  default_labels = {
    app = local.app_name
    env = "terraform"
  }
}
