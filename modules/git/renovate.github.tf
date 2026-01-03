resource "github_repository" "renovate" {
  depends_on = [github_organization_settings.kickr-dev]

  name        = "renovate"
  description = "Renovate repository with shared kickr configurations"
  visibility  = "public"

  has_discussions = false
  has_downloads   = false
  has_issues      = true

  allow_auto_merge   = false
  allow_merge_commit = false
  allow_rebase_merge = true
  allow_squash_merge = false

  archive_on_destroy          = true
  delete_branch_on_merge      = true
  web_commit_signoff_required = true

  topics = ["renovate", "renovate-configs", "shared-configuration"]

  vulnerability_alerts = true
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_branch_protection" "renovate" {
  depends_on = [github_repository.renovate]
  for_each   = toset(["main"])

  pattern       = each.value
  repository_id = github_repository.renovate.name

  # enforce_admins                  = true
  require_conversation_resolution = true

  # required_pull_request_reviews {
  #   dismiss_stale_reviews           = true
  #   require_code_owner_reviews      = true
  #   require_last_push_approval      = true
  #   required_approving_review_count = 1
  # }
  required_status_checks {
    strict = true
  }
}

module "github_renovate" {
  depends_on = [github_repository.renovate]
  source     = "./github"
  repository = github_repository.renovate.name

  actions_disabled = true
  default_branch   = "main"
  labels           = local.labels
}
