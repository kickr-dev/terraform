resource "github_repository" "default" {
  name         = var.name
  description  = var.description
  visibility   = var.visibility
  homepage_url = var.homepage_url

  has_discussions = var.has_discussions
  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki

  allow_auto_merge   = false
  allow_merge_commit = contains(var.merge_methods, "merge")
  allow_rebase_merge = contains(var.merge_methods, "rebase")
  allow_squash_merge = contains(var.merge_methods, "squash")

  archive_on_destroy          = true
  archived                    = var.archived
  delete_branch_on_merge      = true
  web_commit_signoff_required = true

  topics = var.topics

  security_and_analysis {
    secret_scanning {
      status = var.secret_scanning
    }
    secret_scanning_push_protection {
      status = var.secret_scanning_push_protection
    }
  }
}

resource "github_actions_environment_secret" "secrets" {
  depends_on = [github_repository_environment.environments]
  for_each = merge([
    for env in var.environments : {
      for secret in env.secrets : "${env.environment}:${secret.secret_name}" => {
        environment     = env.environment
        secret_name     = secret.secret_name
        value           = secret.value
        value_encrypted = secret.value_encrypted
      }
    }
  ]...)

  environment = each.value.environment
  repository  = github_repository.default.name
  secret_name = each.value.secret_name

  value           = each.value.value
  value_encrypted = each.value.value_encrypted
}

resource "github_actions_environment_variable" "variables" {
  depends_on = [github_repository_environment.environments]
  for_each = merge([
    for env in var.environments : {
      for variable in env.variables : "${env.environment}:${variable.variable_name}" => {
        environment   = env.environment
        value         = variable.value
        variable_name = variable.variable_name
      }
    }
  ]...)

  environment   = each.value.environment
  repository    = github_repository.default.name
  value         = each.value.value
  variable_name = each.value.variable_name
}

resource "github_actions_repository_permissions" "disabled" {
  count      = var.actions_disabled ? 1 : 0
  repository = github_repository.default.name

  enabled = false
}

resource "github_actions_repository_permissions" "enabled" {
  count      = var.actions_disabled ? 0 : 1
  repository = github_repository.default.name

  enabled         = true
  allowed_actions = "all"
}

resource "github_actions_secret" "secrets" {
  for_each = {
    for secret in var.secrets : secret.secret_name => {
      value_encrypted = secret.value_encrypted
      value           = secret.value
    }
  }

  repository  = github_repository.default.name
  secret_name = each.key

  value           = each.value.value
  value_encrypted = each.value.value_encrypted
}

resource "github_actions_variable" "variables" {
  for_each = { for variable in var.variables : variable.variable_name => variable.value }

  repository    = github_repository.default.name
  variable_name = each.key
  value         = each.value
}

resource "github_branch_default" "default_branch" {
  branch     = var.default_branch
  repository = github_repository.default.name
}

resource "github_branch_protection" "branch_protections" {
  for_each = { for protected_branch in var.protected_branches : protected_branch.name => protected_branch }

  pattern       = each.key
  repository_id = github_repository.default.name

  allows_deletions                = false
  allows_force_pushes             = false
  enforce_admins                  = false
  require_conversation_resolution = true
  require_signed_commits          = false
  required_linear_history         = true

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews ? [0] : []
    content {
      dismiss_stale_reviews           = true
      require_code_owner_reviews      = true
      require_last_push_approval      = true
      required_approving_review_count = 1
    }
  }

  required_status_checks {
    strict = true
  }
}

resource "github_issue_labels" "labels" {
  repository = github_repository.default.name

  dynamic "label" {
    for_each = { for label in var.labels : label.name => label }
    content {
      color       = trimprefix(label.value.color, "#")
      description = label.value.description
      name        = label.key
    }
  }
}

resource "github_repository_collaborator" "members" {
  for_each = { for member in var.members : member.username => member }

  permission = each.value.permission
  repository = github_repository.default.name
  username   = each.key
}

resource "github_repository_environment" "environments" {
  for_each = { for env in var.environments : env.environment => env }

  environment = each.value.environment
  repository  = github_repository.default.name

  can_admins_bypass = false

  dynamic "deployment_branch_policy" {
    for_each = each.value.protected_branches || each.value.custom_branch_policies ? [each.value] : []
    content {
      custom_branch_policies = deployment_branch_policy.value.custom_branch_policies
      protected_branches     = deployment_branch_policy.value.protected_branches
    }
  }
}

resource "github_repository_ruleset" "tags" {
  name       = "tags"
  repository = github_repository.default.name

  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    deletion = true
    update   = true
  }
}

resource "github_repository_vulnerability_alerts" "default" {
  repository = github_repository.default.name
  enabled    = var.vulnerability_alerts
}
