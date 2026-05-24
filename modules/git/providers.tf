provider "github" {
  owner = "kickr-dev"
  token = ephemeral.sops_file.providers.data["github_terraform_token"]
}

provider "gitlab" {
  token = ephemeral.sops_file.providers.data["gitlab_terraform_token"]
}

provider "sops" {}
