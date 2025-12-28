resource "github_repository" "engine" {
  depends_on = [github_organization_settings.kickr-dev]

  name        = "engine"
  description = "Kickr engine for those who want to use their own generation schema and templates"
  visibility  = "public"

  has_discussions = true
  has_downloads   = false
  has_issues      = true

  allow_auto_merge   = false
  allow_merge_commit = false
  allow_rebase_merge = true
  allow_squash_merge = false

  archive_on_destroy     = true
  delete_branch_on_merge = true
  # web_commit_signoff_required = true

  topics = ["golang", "golang-library", "layout", "repository-tools", "templates"]

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

resource "github_branch_protection" "engine" {
  depends_on = [github_repository.engine]
  for_each   = toset(["main"])

  pattern       = each.value
  repository_id = github_repository.engine.name

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

module "github_engine" {
  depends_on = [github_repository.engine]
  source     = "./github"
  repository = github_repository.engine.name

  actions_disabled = true
  default_branch   = "main"
  labels           = local.labels
}
