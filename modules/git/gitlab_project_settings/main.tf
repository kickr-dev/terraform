data "gitlab_project_labels" "labels" {
  project = var.project
}

resource "gitlab_branch_protection" "protections" {
  for_each = var.protected_branches

  project = var.project
  branch  = each.value

  allow_force_push             = false
  code_owner_approval_required = true

  allowed_to_merge     = [{ access_level = var.merge_access_level }]
  allowed_to_push      = [{ access_level = var.push_access_level }]
  allowed_to_unprotect = [{ access_level = "maintainer" }]
}

resource "gitlab_project_environment" "environments" {
  for_each = { for env in var.environments : env.environment => env }
  project  = var.project

  name         = each.key
  description  = each.value.description
  external_url = each.value.external_url

  stop_before_destroy = true
  tier                = each.value.tier
}

resource "gitlab_project_integration_github" "github" {
  count   = var.mirror != null ? 1 : 0
  project = var.project

  token          = var.mirror.token
  repository_url = var.mirror.url
}

resource "gitlab_project_label" "labels" {
  for_each = { for label in var.labels : label.name => label }
  project  = var.project

  color       = each.value.color
  description = each.value.description
  name        = each.value.name
}

resource "terraform_data" "labels" {
  for_each = toset([
    for label in data.gitlab_project_labels.labels.labels :
    label.name if label.is_project_label && !contains([for l in var.labels : l.name], label.name)
  ])

  triggers_replace = each.key

  provisioner "local-exec" {
    command = <<-EOT
      curl -fsSL -X DELETE \
        --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "https://gitlab.com/api/v4/projects/${var.project}/labels/${each.key}"
    EOT

    environment = {
      GITLAB_TOKEN = var.gitlab_token
    }
  }
}

resource "gitlab_project_push_mirror" "github" {
  count   = var.mirror != null ? 1 : 0
  project = var.project

  auth_method             = "password"
  enabled                 = true
  keep_divergent_refs     = false
  only_protected_branches = true
  url                     = "https://mirror:${var.mirror.token}@${trimprefix(var.mirror.url, "https://")}"
}

resource "gitlab_pipeline_schedule" "schedules" {
  for_each = { for schedule in var.schedules : schedule.name => schedule }
  project  = var.project

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
  project              = var.project

  key           = each.value.key
  value         = each.value.value
  variable_type = "env_var"
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

  project     = var.project
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
  project = var.project

  create_access_level = "maintainer"
  tag                 = "*"
}
