output "http_clone_url" {
  value       = github_repository.default.http_clone_url
  description = "URL that can be provided to `git clone` to clone the repository via HTTPS."
}

output "name" {
  value       = github_repository.default.name
  description = "The name of the repository."
}
