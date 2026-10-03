module "github_repository_kickr" {
  depends_on = [github_organization_settings.kickr-dev]
  source     = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  name = "kickr"

  default_branch     = "beta"
  protected_branches = [{ name = "beta" }]
  description        = "Kickr CLI for easy project kickstart generation"
  visibility         = "public"
  plan               = local.github_plan

  has_discussions = true
  topics          = ["generator", "golang", "layout", "repository-tools", "templates"]

  actions_disabled = true
  labels           = local.labels
}
