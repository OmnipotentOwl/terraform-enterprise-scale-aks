terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
  required_version = ">= 0.13.0"
}
