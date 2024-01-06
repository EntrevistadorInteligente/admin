output "name" {
  description = "Name of the team."
  value       = github_team.this.name
}

output "id" {
  description = "The ID of the team."
  value       = github_team.this.id
}
