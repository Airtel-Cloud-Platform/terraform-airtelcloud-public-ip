output "public_ip_id" {
  description = "Public IP ID"
  value       = airtelcloud_public_ip.this.id
}

output "public_ip_address" {
  description = "Allocated public IP address"
  value       = airtelcloud_public_ip.this.public_ip
}

output "public_ip_status" {
  description = "Public IP status (reserved after create, attached after bind)"
  value       = airtelcloud_public_ip.this.status
}

output "public_ip" {
  description = "Public IP reservation attributes"
  value = {
    id        = airtelcloud_public_ip.this.id
    public_ip = airtelcloud_public_ip.this.public_ip
    vip       = airtelcloud_public_ip.this.vip
    status    = airtelcloud_public_ip.this.status
  }
}

output "vip" {
  description = "Private IP the address is NATed to. Empty until attached."
  value       = try(airtelcloud_public_ip_attachment.this[0].target_vip, airtelcloud_public_ip.this.vip)
}

output "attachment_id" {
  description = "Attachment ID when resource_type and resource_name are set"
  value       = try(airtelcloud_public_ip_attachment.this[0].id, null)
}

output "policy_rule_ids" {
  description = "Map of policy rule name to rule ID"
  value       = { for k, r in airtelcloud_public_ip_policy_rule.this : k => r.id }
}
