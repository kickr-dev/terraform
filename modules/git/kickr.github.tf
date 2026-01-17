module "github_repository_kickr" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name        = "kickr"
  description = "Kickr CLI for easy project kickstart generation"
  visibility  = "public"

  has_discussions = true
  topics          = ["generator", "golang", "layout", "repository-tools", "templates"]
}

module "github_repository_settings_kickr" {
  depends_on = [module.github_repository_kickr]
  source     = "./github_repository_settings"

  repository = module.github_repository_kickr.name

  default_branch     = "beta"
  protected_branches = [{ name = "beta" }]

  actions_disabled = true
  labels           = local.labels

}
