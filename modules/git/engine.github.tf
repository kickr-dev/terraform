module "github_repository_engine" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name = "engine"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Kickr engine for those who want to use their own generation schema and templates"
  visibility         = "public"

  has_discussions = true
  topics          = ["golang", "golang-library", "layout", "repository-tools", "templates"]

  actions_disabled = true
  labels           = local.labels
}
