module "gitlab_project_kickr" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-gitlab-project.git?ref=main"

  namespace_id = gitlab_group.kickr-dev.id
  name         = "kickr"
  avatar       = "${path.module}/avatars/kickr.png"

  default_branch     = "beta"
  protected_branches = ["beta"]
  description        = "Kickr CLI for easy project kickstart generation"
  visibility_level   = "public"
  tier               = local.gitlab_tier

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
      ref         = "refs/heads/beta"
      timezone    = local.timezone
    }
  ]
}

resource "gitlab_project_integration_github" "kickr" {
  project = module.gitlab_project_kickr.id

  token          = sensitive(local.secrets.git.github_mirror_token)
  repository_url = module.github_repository_kickr.http_clone_url
}

resource "gitlab_project_push_mirror" "kickr" {
  project = module.gitlab_project_kickr.id

  auth_method             = "password"
  enabled                 = true
  keep_divergent_refs     = false
  only_protected_branches = true
  url                     = "https://mirror:${sensitive(local.secrets.git.github_mirror_token)}@${trimprefix(module.github_repository_kickr.http_clone_url, "https://")}"
}
