module "github_repository_renovate" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name        = "renovate"
  description = "Renovate repository with shared kickr configurations"
  visibility  = "public"

  topics = ["renovate", "renovate-configs", "shared-configuration"]
}

module "github_repository_settings_renovate" {
  source     = "./github_repository_settings"
  repository = module.github_repository_renovate.name

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  actions_disabled = true
  labels           = local.labels
}
