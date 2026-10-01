resource "gitlab_project" "default" {
  namespace_id = var.namespace_id
  name         = var.name
  path         = var.name

  default_branch   = var.default_branch
  description      = var.description
  visibility_level = var.visibility_level

  avatar      = var.avatar
  avatar_hash = var.avatar != null ? filesha256(var.avatar) : null

  archived                = var.archived
  archive_on_destroy      = true
  keep_latest_artifact    = true
  merge_pipelines_enabled = var.merge_pipelines_enabled
  merge_trains_enabled    = var.merge_trains_enabled
  packages_enabled        = var.packages_enabled
  public_jobs             = var.public_jobs

  analytics_access_level               = var.analytics_access_level
  builds_access_level                  = var.builds_access_level
  container_registry_access_level      = var.container_registry_access_level
  environments_access_level            = var.environments_access_level
  feature_flags_access_level           = var.feature_flags_access_level
  forking_access_level                 = var.forking_access_level
  infrastructure_access_level          = var.infrastructure_access_level
  issues_access_level                  = var.issues_access_level
  merge_requests_access_level          = var.merge_requests_access_level
  model_experiments_access_level       = var.model_experiments_access_level
  model_registry_access_level          = var.model_registry_access_level
  monitor_access_level                 = var.monitor_access_level
  pages_access_level                   = var.pages_access_level
  releases_access_level                = var.releases_access_level
  repository_access_level              = var.repository_access_level
  requirements_access_level            = var.requirements_access_level
  security_and_compliance_access_level = var.security_and_compliance_access_level
  snippets_access_level                = var.snippets_access_level
  wiki_access_level                    = var.wiki_access_level

  allow_merge_on_skipped_pipeline                  = true
  auto_cancel_pending_pipelines                    = "enabled"
  autoclose_referenced_issues                      = true
  merge_method                                     = var.merge_method
  only_allow_merge_if_all_discussions_are_resolved = true
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  printing_merge_request_link_enabled              = true
  remove_source_branch_after_merge                 = true
  squash_option                                    = var.squash_option
  suggestion_commit_message                        = var.suggestion_commit_message

  build_git_strategy                          = "fetch"
  build_timeout                               = 900
  ci_delete_pipelines_in_seconds              = 2592000 # 30d
  ci_forward_deployment_enabled               = true
  ci_forward_deployment_rollback_allowed      = true
  ci_pipeline_variables_minimum_override_role = "developer"
  ci_push_repository_for_job_token_allowed    = false
  ci_restrict_pipeline_cancellation_role      = "developer"
  ci_separated_caches                         = true

  resolve_outdated_diff_discussions = false

  push_rules {
    branch_name_regex    = var.branch_name_regex
    commit_message_regex = var.commit_message_regex

    deny_delete_tag         = true
    max_file_size           = 25
    prevent_secrets         = true
    reject_non_dco_commits  = false
    reject_unsigned_commits = false
  }
}

resource "gitlab_branch_protection" "protections" {
  for_each = var.protected_branches

  project = gitlab_project.default.id
  branch  = each.value

  allow_force_push             = false
  code_owner_approval_required = true

  allowed_to_merge     = [{ access_level = var.merge_access_level }]
  allowed_to_push      = [{ access_level = var.push_access_level }]
  allowed_to_unprotect = [{ access_level = var.unprotect_access_level }]
}

resource "gitlab_pipeline_schedule" "schedules" {
  for_each = { for schedule in var.schedules : schedule.name => schedule }
  project  = gitlab_project.default.id

  active         = each.value.active
  cron           = each.value.cron
  cron_timezone  = each.value.timezone
  description    = each.value.description
  inputs         = each.value.inputs
  ref            = each.value.ref
  take_ownership = true
}

resource "gitlab_pipeline_schedule_variable" "variables" {
  for_each = merge([
    for schedule in var.schedules : {
      for variable in schedule.variables : "${schedule.name}:${variable.key}" => {
        key                  = variable.key
        pipeline_schedule_id = gitlab_pipeline_schedule.schedules[schedule.name].pipeline_schedule_id
        value                = variable.value
      }
    }
  ]...)

  pipeline_schedule_id = each.value.pipeline_schedule_id
  project              = gitlab_project.default.id

  key           = each.value.key
  value         = each.value.value
  variable_type = "env_var"
}

resource "gitlab_project_environment" "environments" {
  for_each = { for env in var.environments : env.environment => env }
  project  = gitlab_project.default.id

  name         = each.key
  description  = each.value.description
  external_url = each.value.external_url

  stop_before_destroy = true
  tier                = each.value.tier
}

resource "gitlab_project_label" "labels" {
  for_each = { for label in var.labels : label.name => label }
  project  = gitlab_project.default.id

  color       = each.value.color
  description = each.value.description
  name        = each.value.name
}

data "gitlab_user" "members" {
  for_each = { for member in var.members : member.username => member }
  username = each.key
}

resource "gitlab_project_membership" "members" {
  for_each = { for member in var.members : member.username => member }

  access_level = each.value.access_level
  project      = gitlab_project.default.id
  user_id      = data.gitlab_user.members[each.key].id
}

resource "gitlab_project_security_settings" "default" {
  count = var.security_and_compliance_access_level != "disabled" ? 1 : 0

  project                        = gitlab_project.default.id
  secret_push_protection_enabled = true
}

resource "gitlab_project_variable" "variables" {
  for_each = merge([
    # environment variables
    merge([
      for env in var.environments : {
        for variable in env.variables : "${env.environment}:${variable.key}" => merge(variable, {
          environment_scope = env.environment
          protected         = contains(["production", "staging"], env.tier)
        })
      }
    ]...),
    # global variables
    {
      for variable in var.variables : variable.key => merge(variable, {
        environment_scope = "*"
      })
    }
  ]...)

  project     = gitlab_project.default.id
  key         = each.value.key
  description = each.value.description

  environment_scope = each.value.environment_scope
  hidden            = each.value.sensitive
  masked            = each.value.sensitive
  protected         = each.value.protected
  raw               = each.value.raw
  value             = sensitive(each.value.value)
  variable_type     = "env_var"
}

resource "gitlab_tag_protection" "tags" {
  project = gitlab_project.default.id

  create_access_level = "maintainer"
  tag                 = "*"
}

data "gitlab_project_labels" "labels" {
  project = gitlab_project.default.id
}

locals {
  stale_labels = [
    for label in data.gitlab_project_labels.labels.labels :
    label.name if label.is_project_label && !contains([for l in var.labels : l.name], label.name)
  ]
}

resource "terraform_data" "labels" {
  triggers_replace = local.stale_labels

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      for name in $(printf '%s' "$STALE_LABELS" | jq -r '.[]'); do
        curl -fsSL -X DELETE \
          --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
          "https://gitlab.com/api/v4/projects/${gitlab_project.default.id}/labels/$name"
      done
    EOT

    environment = {
      GITLAB_TOKEN = var.gitlab_token
      # use an environment variable instead of 'for_each' since on project creation, data is not yet available on plan
      STALE_LABELS = jsonencode(local.stale_labels)
    }
  }
}
