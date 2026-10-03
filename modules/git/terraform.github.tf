module "github_repository_terraform" {
  depends_on = [github_organization_settings.kickr-dev]

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  description = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  name        = "terraform"
  plan        = local.github_plan
  visibility  = "public"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  has_issues = false

  topics = ["terraform", "terraform-resources"]

  actions_disabled = true
  labels           = local.labels
}
