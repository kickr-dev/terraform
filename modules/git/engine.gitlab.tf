module "gitlab_project_engine" {
  source = "./gitlab_project"

  namespace_id = gitlab_group.kickr-dev.id
  name         = "engine"
  avatar       = "${path.module}/avatars/kickr.png"

  default_branch   = "main"
  description      = "Kickr engine for those who want to use their own generation schema and templates"
  visibility_level = "public"

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
}

module "gitlab_project_settings_engine" {
  source       = "./gitlab_project_settings"
  project      = module.gitlab_project_engine.id
  gitlab_token = ephemeral.sops_file.providers.data["gitlab_terraform_token"]

  protected_branches = ["main"]

  mirror = {
    token = sensitive(local.secrets.git.github_mirror_token)
    url   = module.github_repository_engine.http_clone_url
  }

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
