provider "external" {}

provider "github" {
  owner = "kickr-dev"
  token = data.sops_file.sops["github"].data["terraform_token"]
}

provider "gitlab" {
  token = data.sops_file.sops["gitlab"].data["terraform_token"]
}

provider "sops" {}
