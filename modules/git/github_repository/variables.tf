variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "description" {
  type        = string
  description = "A description of the repository."
}

variable "visibility" {
  type        = string
  description = "Can be `public` or `private`. If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, visibility can also be `internal`. The `visibility` parameter overrides the `private` parameter."
}

variable "homepage_url" {
  type        = string
  default     = null
  description = "URL of a page describing the project."
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

variable "topics" {
  type        = set(string)
  default     = []
  description = "The list of topics of the repository."
}

variable "vulnerability_alerts" {
  type        = bool
  default     = true
  description = "Configure Dependabot security alerts for vulnerable dependencies; set to `true` to enable, set to `false` to disable, and leave unset for the default behavior."
}

variable "secret_scanning" {
  type        = string
  default     = "enabled"
  description = "Set to `enabled` to enable secret scanning on the repository. Can be `enabled` or `disabled`."
}

variable "secret_scanning_push_protection" {
  type        = string
  default     = "enabled"
  description = "Set to `enabled` to enable secret scanning push protection on the repository. Can be `enabled` or `disabled`."
}
