provider "github" {
  owner = "kickr-dev"
  token = local.secrets.github.terraform_token
}

provider "gitlab" {
  token = local.secrets.gitlab.terraform_token
}

provider "sops" {}
