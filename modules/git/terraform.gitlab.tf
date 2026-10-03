module "gitlab_project_terraform" {
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://gitlab.com/kickr-dev/terraform-gitlab-project.git?ref=main"

  avatar           = "${path.module}/avatars/terraform.png"
  description      = "Kickr terraform resources (GitHub, GitLab, cloud instances)"
  name             = "terraform"
  namespace_id     = gitlab_group.kickr-dev.id
  tier             = local.gitlab_tier
  visibility_level = "public"

  default_branch     = "main"
  protected_branches = ["main"]

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

  environments = [
    {
      environment = "production"
      description = "Terraform production environment (state separation)"
      tier        = "production"
    }
  ]

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

resource "gitlab_project_integration_github" "terraform" {
  project = module.gitlab_project_terraform.id

  token          = sensitive(local.secrets.git.github_mirror_token)
  repository_url = module.github_repository_terraform.http_clone_url
}

resource "gitlab_project_push_mirror" "terraform" {
  project = module.gitlab_project_terraform.id

  auth_method             = "password"
  enabled                 = true
  keep_divergent_refs     = false
  only_protected_branches = true
  url                     = "https://mirror:${sensitive(local.secrets.git.github_mirror_token)}@${trimprefix(module.github_repository_terraform.http_clone_url, "https://")}"
}
