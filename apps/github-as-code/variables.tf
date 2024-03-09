# Variables

variable "org_dir_relative" {
  description = "The relative path to the directory containing the organization configuration file."
  type        = string
}

variable "repository_dir_relative" {
  description = "The relative path to the directory containing the repository configuration files."
  type        = string
}

# Secrets

variable "github_token" {
  description = "An PAT token to connect to GitHub with"
  type        = string
}
