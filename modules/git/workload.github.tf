module "github_repository_workload" {
  depends_on = [github_organization_settings.kickr-dev]

  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-github-repository.git?ref=main"

  description = "Helm library chart for rendering workloads and their related Kubernetes resources from values"
  name        = "workload"
  plan        = local.github_plan
  visibility  = "public"

  default_branch     = "main"
  protected_branches = [{ name = "main" }]

  topics = ["helm", "helm-chart", "kubernetes", "library-chart"]

  actions_disabled = true
  labels           = local.labels
}
