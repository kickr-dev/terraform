module "github_repository_terraform" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name        = "terraform"
  description = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  visibility  = "public"

  has_issues = false

  topics = ["terraform", "terraform-resources"]
}

module "github_repository_settings_terraform" {
  source     = "./github_repository_settings"
  repository = module.github_repository_terraform.name

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  actions_disabled = true
  labels           = local.labels
}
