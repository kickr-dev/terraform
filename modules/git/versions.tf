terraform {
  required_version = ">= 1.10.0"

  backend "http" {}

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 6.12.0, < 7.0.0"
    }

    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 19.4.0, < 20.0.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "< 2.0.0"
    }
  }
}
