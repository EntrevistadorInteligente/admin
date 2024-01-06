variable "repository_name" {
  description = "The name of the repository to manage."
  type        = string

  validation {
    condition     = can(regex("^[a-z-.]+$", var.repository_name))
    error_message = "Repository name must be lowercase alphanumeric with dashes or dots."
  }
}

variable "config" {
  description = "The configuration of the repository."
  # TODO: change to optionals
  type = object({
    archived               = bool
    homepage               = string
    auto_init              = bool
    allow_auto_merge       = bool
    allow_merge_commit     = bool
    allow_rebase_merge     = bool
    allow_squash_merge     = bool
    allow_update_branch    = bool
    delete_branch_on_merge = bool
    has_issues             = bool
    has_downloads          = bool
    has_discussions        = bool
    has_projects           = bool
    has_wiki               = bool
    security = object({
      enableVulnerabilityAlerts    = bool
      enableAutomatedSecurityFixes = bool
    })
  })
  default = {
    archived               = false
    homepage               = ""
    auto_init              = true
    allow_auto_merge       = true
    allow_merge_commit     = false
    allow_rebase_merge     = false
    allow_squash_merge     = true
    allow_update_branch    = true
    delete_branch_on_merge = true
    has_issues             = false
    has_downloads          = false
    has_discussions        = false
    has_projects           = false
    has_wiki               = false
    security = {
      enableVulnerabilityAlerts    = true
      enableAutomatedSecurityFixes = false
    }
  }
}

variable "description" {
  description = "The description of the repository."
  type        = string
  default     = ""
}

variable "variables" {
  description = "List of variables"
  type        = map(string)
  default     = {}
}

variable "topics" {
  description = "The topics of the repository."
  type        = set(string)
  default     = []
}

variable "visibility" {
  description = "The visibility of the repository. Default: private"
  type        = string
  default     = "private"

  validation {
    condition     = can(regex("^(public|private|internal)$", var.visibility))
    error_message = "Visibility must be public, private or internal."
  }
}

variable "default_branch_name" {
  description = "The default branch name. Default: main"
  type        = string
  default     = "main"
}

variable "team_access" {
  description = "The teams to grant access to the repository. team_access = { team_name = permission, ... }"
  type = map(object({
    team_id     = string
    permissions = string
  }))
}

variable "labels" {
  description = "List of labels"
  type = map(object({
    color       = string
    description = optional(string)
  }))
  default = {}
}

variable "reviewers_team_slugs" {
  description = "List of reviewers team slug names"
  type        = list(string)
}
