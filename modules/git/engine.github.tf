module "github_repository_engine" {
  depends_on = [github_organization_settings.kickr-dev]

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  name = "engine"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Kickr engine for those who want to use their own generation schema and templates"
  visibility         = "public"
  plan               = local.github_plan

  has_discussions = true
  topics          = ["golang", "golang-library", "layout", "repository-tools", "templates"]

  actions_disabled = true
  labels           = local.labels
}
