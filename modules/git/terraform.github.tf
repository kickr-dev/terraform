module "github_repository_terraform" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name = "terraform"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  visibility         = "public"

  has_issues = false

  topics = ["terraform", "terraform-resources"]

  actions_disabled = true
  labels           = local.labels
}
