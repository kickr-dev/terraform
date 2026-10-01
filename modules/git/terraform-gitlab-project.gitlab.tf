module "gitlab_project_terraform-gitlab-project" {
  source       = "./gitlab_project"
  gitlab_token = ephemeral.sops_file.providers.data["gitlab_terraform_token"]

  namespace_id = gitlab_group.kickr-dev.id
  name         = "terraform-gitlab-project"
  avatar       = "${path.module}/avatars/terraform.png"

  default_branch     = "main"
  protected_branches = ["main"]
  description        = "Terraform module for creating GitLab projects"
  visibility_level   = "public"

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

  branch_name_regex    = local.branch_name_regex
  commit_message_regex = local.commit_message_regex

  schedules = [
    {
      active      = local.schedulers.kickr.active
      cron        = local.schedulers.kickr.schedule
      description = "Scheduled pipeline for kickr layout updates"
      name        = "kickr"
      ref         = "refs/heads/main"
    }
  ]
}
