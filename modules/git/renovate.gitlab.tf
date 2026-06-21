module "gitlab_project_renovate" {
  source = "./gitlab_project"

  namespace_id = gitlab_group.kickr-dev.id
  name         = "renovate"
  avatar       = "${path.module}/avatars/renovate.png"

  default_branch   = "main"
  description      = "Renovate repository with shared kickr configurations and sheduled maintainance"
  visibility_level = "public"

  analytics_access_level               = "disabled"
  container_registry_access_level      = "disabled"
  environments_access_level            = "disabled"
  feature_flags_access_level           = "disabled"
  infrastructure_access_level          = "disabled"
  model_experiments_access_level       = "disabled"
  model_registry_access_level          = "disabled"
  monitor_access_level                 = "disabled"
  pages_access_level                   = "disabled"
  requirements_access_level            = "disabled"
  security_and_compliance_access_level = "disabled"
  snippets_access_level                = "disabled"
  wiki_access_level                    = "disabled"

  branch_name_regex    = local.branch_name_regex
  commit_message_regex = local.commit_message_regex
}

module "gitlab_project_settings_renovate" {
  source  = "./gitlab_project_settings"
  project = module.gitlab_project_renovate.id

  protected_branches = ["main"]

  mirror = {
    token = sensitive(local.secrets.git.github_mirror_token)
    url   = module.github_repository_renovate.http_clone_url
  }

  schedules = [
    {
      active      = true
      cron        = local.schedules.kickr
      description = "Scheduled pipeline for kickr layout updates"
      name        = "kickr"
      ref         = "refs/heads/main"
      variables = [
        {
          key   = "RENOVATE_DISABLED"
          value = "true"
        }
      ]
    },
    {
      cron        = local.schedules.renovate
      description = "Scheduled pipeline for Renovate maintainance"
      name        = "renovate"
      ref         = "refs/heads/main"
      variables = [
        {
          key   = "KICKR_DISABLED"
          value = "true"
        }
      ]
    }
  ]

  variables = [
    {
      key         = "GITHUB_COM_TOKEN"
      description = "GitHub token to retrieve release notes associated with versions updates"
      protected   = true
      raw         = true
      sensitive   = true
      value       = sensitive(local.secrets.git.github_com_token)
    },
    {
      key         = "RENOVATE_TOKEN"
      description = local.descriptions.renovate
      protected   = true
      raw         = true
      sensitive   = true
      value       = sensitive(gitlab_group_service_account_access_token.access_tokens["renovate"].token)
    }
  ]
}
