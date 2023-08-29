output "url" {
  description = "The URL endpoint for Atlantis."
  value       = module.example-atlantis.url
}

output "web_username" {
  description = "The username for Atlantis web access."
  value       = module.example-atlantis.web_username
}

output "web_password" {
  description = "The password for Atlantis web access. This is sensitive and should be kept secure."
  value       = module.example-atlantis.web_password
  sensitive   = true
}
