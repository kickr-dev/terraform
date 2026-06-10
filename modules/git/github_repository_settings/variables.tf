variable "actions_disabled" {
  type        = bool
  default     = false
  description = "Should GitHub Actions be enabled on this repository."
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The branch (e.g. `main`) to set as the default branch of the repository."
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

variable "protected_branches" {
  type = list(object({
    name                          = string
    required_pull_request_reviews = optional(bool, false)
  }))
  default     = []
  description = "List of branch protection rules to apply on the repository, each identified by a pattern and with optional pull request review enforcement."
}

variable "repository" {
  type        = string
  description = "The GitHub repository name to apply settings to."
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
}

variable "variables" {
  type = list(object({
    variable_name = string
    value         = string
  }))
  default     = []
  description = "List of repository-level Actions variables to create, each with a variable_name and a value."
}

variable "webhook" {
  type = object({
    secret = string
    url    = string
  })
  default     = null
  nullable    = true
  description = "Webhook configuration for the repository, with the target url and an optional shared secret."
}
