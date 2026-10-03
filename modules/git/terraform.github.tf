module "github_repository_terraform" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  name = "terraform"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  visibility         = "public"
  plan               = local.github_plan

  has_issues = false

  topics = ["terraform", "terraform-resources"]

  actions_disabled = true
  labels           = local.labels
}
