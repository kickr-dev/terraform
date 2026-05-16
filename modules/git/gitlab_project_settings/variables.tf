variable "environments" {
  type = list(object({
    description = string
    environment = string
    tier        = string

    external_url = optional(string, null)

    variables = optional(list(object({
      description = string
      key         = string
      raw         = bool
      sensitive   = bool
      value       = string
    })), [])
  }))
  default     = []
  description = "List of environments to create in the GitLab project along with their CI/CD variables."
}

variable "labels" {
  type = list(object({
    name        = string
    color       = string
    description = string
  }))
  default     = []
  description = "List of labels to create in the GitLab project."
}

variable "mirror" {
  type = object({
    token = string
    url   = string
  })
  default     = null
  nullable    = true
  description = "Pull mirror configuration to keep the GitLab project in sync with an upstream repository."
}

variable "project" {
  type        = string
  description = "The GitLab project ID or full path to configure."
}

variable "protected_branches" {
  type        = set(string)
  default     = []
  description = "List of branch name patterns to protect in the GitLab project."
}

variable "schedules" {
  type = list(object({
    active      = optional(bool, true)
    cron        = string
    description = string
    name        = string
    ref         = string
    timezone    = optional(string, "Europe/Paris")
    variables = optional(list(object({
      key   = string
      value = string
    })), [])
  }))
  default     = []
  description = "List of pipeline schedules to create in the GitLab project."
}

variable "variables" {
  type = list(object({
    description = string
    key         = string
    raw         = bool
    sensitive   = bool
    protected   = optional(bool, false)
    value       = string
  }))
  default     = []
  description = "List of CI/CD variables to create at the GitLab project level."
}
