module "github_repository_renovate" {
  depends_on = [github_organization_settings.kickr-dev]

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  description = "Renovate repository with shared kickr configurations"
  name        = "renovate"
  plan        = local.github_plan
  visibility  = "public"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  topics = ["renovate", "renovate-configs", "shared-configuration"]

  actions_disabled = true
  labels           = local.labels
}
