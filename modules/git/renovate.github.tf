module "github_repository_renovate" {
  depends_on = [github_organization_settings.kickr-dev]

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  name = "renovate"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]
  description        = "Renovate repository with shared kickr configurations"
  visibility         = "public"
  plan               = local.github_plan

  topics = ["renovate", "renovate-configs", "shared-configuration"]

  actions_disabled = true
  labels           = local.labels
}
