module "gitlab_project_terraform-github-repository" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-gitlab-project.git?ref=main"

  avatar           = "${path.module}/avatars/terraform.png"
  description      = "Terraform module for creating GitHub repositories"
  name             = "terraform-github-repository"
  namespace_id     = gitlab_group.kickr-dev.id
  tier             = local.gitlab_tier
  visibility_level = "public"

  default_branch     = "main"
  protected_branches = ["main"]

  analytics_access_level          = "disabled"
  container_registry_access_level = "disabled"
  environments_access_level       = "disabled"
  feature_flags_access_level      = "disabled"
  infrastructure_access_level     = "disabled"
  model_experiments_access_level  = "disabled"
  model_registry_access_level     = "disabled"
  monitor_access_level            = "disabled"
  pages_access_level              = "disabled"
  requirements_access_level       = "disabled"
  snippets_access_level           = "disabled"
  wiki_access_level               = "disabled"

  schedules = [
    {
      active      = local.schedulers.kickr.active
      cron        = local.schedulers.kickr.schedule
      description = "Scheduled pipeline for kickr layout updates"
      name        = "kickr"
      ref         = "refs/heads/main"
      timezone    = local.schedulers.kickr.timezone
    }
  ]
}
