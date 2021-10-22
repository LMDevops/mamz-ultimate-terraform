output "project_id" {
  value       = google_project.main.id
  description = "The id for project with the format `projects/{{project}}`"
}

output "project_number" {
  value       = google_project.main.number
  description = "The numeric identifier for the project."
}