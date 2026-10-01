variable "actions_disabled" {
  type        = bool
  default     = false
  description = "Should GitHub Actions be enabled on this repository."
}

variable "archived" {
  type        = bool
  default     = false
  description = "Whether the repository is archived."
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The branch (e.g. `main`) to set as the default branch of the repository."
}

variable "description" {
  type        = string
  description = "A description of the repository."
}

variable "environments" {
  type = list(object({
    environment = string

    custom_branch_policies = optional(bool, false)
    protected_branches     = optional(bool, false)

    secrets = optional(list(object({
      secret_name     = string
      from            = optional(string, null)
      value           = optional(string, null)
      value_encrypted = optional(string, null)
    })), [])

    variables = optional(list(object({
      variable_name = string
      value         = string
    })), [])
  }))
  default     = []
  description = "List of deployment environments to create on the repository, each with optional secrets (secret_name, value, value_encrypted) and variables (variable_name, value)."

  validation {
    condition = alltrue(flatten([
      for env in var.environments : [for secret in env.secrets : (secret.value == null) != (secret.value_encrypted == null)]
    ]))
    error_message = "Each environment secret must set exactly one of `value` or `value_encrypted`."
  }
}

variable "has_discussions" {
  type        = bool
  default     = false
  description = "Set to `true` to enable GitHub Discussions on the repository. Defaults to `false`."
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "Set to `true` to enable the GitHub Issues features on the repository."
}

variable "has_projects" {
  type        = bool
  default     = false
  description = "Set to `true` to enable the GitHub Projects features on the repository. Per the GitHub documentation when in an organization that has disabled repository projects it will default to `false` and will otherwise default to `true`. If you specify `true` when it has been disabled it will return an error."
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "Set to `true` to enable the GitHub Wiki features on the repository."
}

variable "homepage_url" {
  type        = string
  default     = null
  description = "URL of a page describing the project."
}

variable "labels" {
  type = list(object({
    name        = string
    color       = string
    description = string
  }))
  default     = []
  description = "List of issue labels to create on the repository, each with a name, a 6 character hex color code (without leading #), and an optional description."
}

variable "members" {
  type = list(object({
    username   = string
    permission = optional(string, "push")
  }))
  default     = []
  description = "List of users, by username, to add as collaborators of the repository."

  validation {
    condition     = alltrue([for member in var.members : contains(["pull", "triage", "push", "maintain", "admin"], member.permission)])
    error_message = "Each member `permission` must be one of `pull`, `triage`, `push`, `maintain`, `admin`."
  }
}

variable "merge_methods" {
  type        = set(string)
  default     = ["rebase"]
  description = "Set the allowed merge methods. At least one is required, valid values are `merge`, `rebase`, `squash`."

  validation {
    condition     = length(var.merge_methods) > 0 && alltrue([for method in var.merge_methods : contains(["merge", "rebase", "squash"], method)])
    error_message = "Provide at least one merge method, valid values are `merge`, `rebase`, `squash`."
  }
}

variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "protected_branches" {
  type = list(object({
    name                          = string
    required_pull_request_reviews = optional(bool, false)
  }))
  default     = []
  description = "List of branch protection rules to apply on the repository, each identified by a pattern and with optional pull request review enforcement."
}

variable "secret_scanning" {
  type        = string
  default     = "enabled"
  description = "Set to `enabled` to enable secret scanning on the repository. Can be `enabled` or `disabled`."

  validation {
    condition     = contains(["enabled", "disabled"], var.secret_scanning)
    error_message = "Valid values are `enabled`, `disabled`."
  }
}

variable "secret_scanning_push_protection" {
  type        = string
  default     = "enabled"
  description = "Set to `enabled` to enable secret scanning push protection on the repository. Can be `enabled` or `disabled`."

  validation {
    condition     = contains(["enabled", "disabled"], var.secret_scanning_push_protection)
    error_message = "Valid values are `enabled`, `disabled`."
  }
}

variable "secrets" {
  type = list(object({
    secret_name     = string
    from            = optional(string, null)
    value           = optional(string, null)
    value_encrypted = optional(string, null)
  }))
  default     = []
  description = "List of repository-level Actions secrets to create, each with a secret_name and one of value or value_encrypted."

  validation {
    condition     = alltrue([for secret in var.secrets : (secret.value == null) != (secret.value_encrypted == null)])
    error_message = "Each secret must set exactly one of `value` or `value_encrypted`."
  }
}

variable "topics" {
  type        = set(string)
  default     = []
  description = "The list of topics of the repository."
}

variable "variables" {
  type = list(object({
    variable_name = string
    value         = string
  }))
  default     = []
  description = "List of repository-level Actions variables to create, each with a variable_name and a value."
}

variable "visibility" {
  type        = string
  description = "Can be `public` or `private`. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be `internal`. The `visibility` parameter overrides the `private` parameter."

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Valid values are `public`, `private`, `internal`."
  }
}

variable "vulnerability_alerts" {
  type        = bool
  default     = true
  description = "Configure Dependabot security alerts for vulnerable dependencies; set to `true` to enable, set to `false` to disable, and leave unset for the default behavior."
}
