terraform {
  required_version = ">= 0.14.0"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 19.0.0, < 20.0.0"
    }
  }
}
