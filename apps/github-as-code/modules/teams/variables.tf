variable "name" {
  description = "(Required) The name of the team."
  type        = string
}

variable "description" {
  description = "(Optional) The description of the team."
  type        = string
  default     = ""
}

variable "parent_team_id" {
  description = "(Optional) The ID of the parent team."
  type        = string
  default     = ""
}

variable "members" {
  description = "(Optional) A set of GitHub usernames of team members."
  type        = set(string)
  default     = []
}

variable "privacy" {
  description = "(Optional) The privacy of the team. Can be either `secret` or `closed`."
  type        = string
  default     = ""
}

variable "organization_admins" {
  description = "A set of GitHub usernames of organization admins."
  type        = set(string)
  default     = []
}
