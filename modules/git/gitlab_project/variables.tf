variable "analytics_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the analytics access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "avatar" {
  type        = string
  default     = null
  description = "A local path to the avatar image to upload. Note: not available for imported resources."
}

variable "branch_name_regex" {
  type        = string
  description = "All branch names must match this regex, e.g. `(feature|hotfix)\\/*`."
}

variable "builds_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the builds access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "commit_message_regex" {
  type        = string
  description = "All commit messages must match this regex, e.g. `Fixed \\d+\\..*`."
}

variable "container_registry_access_level" {
  type        = string
  default     = "enabled"
  description = "Set visibility of container registry, for this project. Valid values are `disabled`, `private`, `enabled`."
}

variable "default_branch" {
  type        = string
  description = "The default branch for the project."
}

variable "description" {
  type        = string
  description = "A description of the project."
}

variable "environments_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the environments access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "feature_flags_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the feature flags access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "forking_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the forking access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "infrastructure_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the infrastructure access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "issues_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the issues access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "merge_pipelines_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable merge pipelines."
}

variable "merge_requests_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the merge requests access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "merge_trains_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable merge trains. Requires `merge_pipelines_enabled` to be set to `true` to take effect."
}

variable "model_experiments_access_level" {
  type        = string
  default     = "enabled"
  description = "Set visibility of machine learning model experiments. Valid values are `disabled`, `private`, `enabled`."
}

variable "model_registry_access_level" {
  type        = string
  default     = "enabled"
  description = "Set visibility of machine learning model registry. Valid values are `disabled`, `private`, `enabled`."
}

variable "monitor_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the monitor access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "name" {
  type        = string
  description = "The name of the project."
}

variable "namespace_id" {
  type        = number
  description = "The namespace (group or user) of the project. Defaults to your user."
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type        = bool
  default     = true
  description = "Set to true if you want allow merges only if a pipeline succeeds."
}

variable "packages_enabled" {
  type        = bool
  default     = false
  description = "Enable packages repository for the project."
}

variable "pages_access_level" {
  type        = string
  default     = "enabled"
  description = "Enable pages access control. Valid values are `public`, `private`, `enabled`, `disabled`."
}

variable "public_jobs" {
  type        = bool
  default     = true
  description = "If true, jobs can be viewed by non-project members."
}

variable "releases_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the releases access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "repository_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the repository access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "requirements_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the requirements access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "security_and_compliance_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the security and compliance access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "snippets_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the snippets access level. Valid values are `disabled`, `private`, `enabled`."
}

variable "visibility_level" {
  type        = string
  description = "Set to `public` to create a public project. Valid values are `private`, `internal`, `public`."
}

variable "wiki_access_level" {
  type        = string
  default     = "enabled"
  description = "Set the wiki access level. Valid values are `disabled`, `private`, `enabled`."
}
