module "gitlab_project_terraform" {
  source = "./gitlab_project"

  namespace_id = gitlab_group.kickr-dev.id
  name         = "terraform"

  default_branch   = "main"
  description      = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  visibility_level = "public"

  analytics_access_level          = "disabled"
  container_registry_access_level = "disabled"
  feature_flags_access_level      = "disabled"
  forking_access_level            = "disabled"
  issues_access_level             = "disabled"
  model_experiments_access_level  = "disabled"
  model_registry_access_level     = "disabled"
  monitor_access_level            = "disabled"
  pages_access_level              = "disabled"
  releases_access_level           = "disabled"
  requirements_access_level       = "disabled"
  snippets_access_level           = "disabled"
  wiki_access_level               = "disabled"

  branch_name_regex    = local.branch_name_regex
  commit_message_regex = local.commit_message_regex
}

module "gitlab_project_settings_terraform" {
  source  = "./gitlab_project_settings"
  project = module.gitlab_project_terraform.id

  environments = [
    {
      environment = "production"
      description = "Terraform production environment (state separation)"
      tier        = "production"
    }
  ]
  protected_branches = ["main"]

  mirror = {
    token = sensitive(data.sops_file.sops["gitlab"].data["github_mirror_token"])
    url   = module.github_repository_terraform.http_clone_url
  }

  schedules = [
    {
      active      = true
      cron        = "0 12 * * 3"
      description = "Scheduled pipeline for kickr layout updates"
      name        = "kickr"
      ref         = "refs/heads/main"
      variables = [
        {
          key   = "TF_PROD_ENABLED"
          value = "false"
        }
      ]
    }
  ]
}
