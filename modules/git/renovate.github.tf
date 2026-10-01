module "github_repository_renovate" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name = "renovate"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Renovate repository with shared kickr configurations"
  visibility         = "public"

  topics = ["renovate", "renovate-configs", "shared-configuration"]

  actions_disabled = true
  labels           = local.labels
}
