module "github_repository_engine" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name        = "engine"
  description = "Kickr engine for those who want to use their own generation schema and templates"
  visibility  = "public"

  has_discussions = true
  topics          = ["golang", "golang-library", "layout", "repository-tools", "templates"]
}

module "github_repository_settings_engine" {
  source = "./github_repository_settings"

  repository = module.github_repository_engine.name

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  actions_disabled = true
  labels           = local.labels
}
