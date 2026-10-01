module "gitlab_project_renovate" {
  source       = "./gitlab_project"
  gitlab_token = ephemeral.sops_file.providers.data["gitlab_terraform_token"]

  namespace_id = gitlab_group.kickr-dev.id
  name         = "renovate"
  avatar       = "${path.module}/avatars/renovate.png"

  default_branch     = "main"
  protected_branches = ["main"]
  description        = "Renovate repository with shared kickr configurations and sheduled maintainance"
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
      variables = [
        {
          key   = "RENOVATE_DISABLED"
          value = "true"
        }
      ]
    },
    {
      active      = local.schedulers.renovate.active
      cron        = local.schedulers.renovate.schedule
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
      key         = "RENOVATE_GITHUB_COM_TOKEN"
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

resource "gitlab_project_integration_github" "renovate" {
  project = module.gitlab_project_renovate.id

  token          = sensitive(local.secrets.git.github_mirror_token)
  repository_url = module.github_repository_renovate.http_clone_url
}

resource "gitlab_project_push_mirror" "renovate" {
  project = module.gitlab_project_renovate.id

  auth_method             = "password"
  enabled                 = true
  keep_divergent_refs     = false
  only_protected_branches = true
  url                     = "https://mirror:${sensitive(local.secrets.git.github_mirror_token)}@${trimprefix(module.github_repository_renovate.http_clone_url, "https://")}"
}
