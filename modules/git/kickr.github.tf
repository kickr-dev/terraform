module "github_repository_kickr" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "./github_repository"

  name = "kickr"

  default_branch     = "beta"
  protected_branches = [{ name = "beta" }]
  description        = "Kickr CLI for easy project kickstart generation"
  visibility         = "public"

  has_discussions = true
  topics          = ["generator", "golang", "layout", "repository-tools", "templates"]

  actions_disabled = true
  labels           = local.labels
}
