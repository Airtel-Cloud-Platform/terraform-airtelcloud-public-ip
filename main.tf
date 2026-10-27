resource "airtelcloud_public_ip" "this" {
  object_name       = var.object_name
  description       = var.description
  availability_zone = var.availability_zone

  lifecycle {
    precondition {
      condition     = length(var.policy_rules) == 0 || (var.resource_type != null && var.resource_name != null)
      error_message = "policy_rules require resource_type and resource_name because rules can only be created on an attached public IP."
    }
  }
}

resource "airtelcloud_public_ip_attachment" "this" {
  count = var.resource_type != null && var.resource_name != null ? 1 : 0

  public_ip_name = airtelcloud_public_ip.this.object_name
  resource_type  = var.resource_type
  resource_name  = var.resource_name
  target_vip     = var.target_vip
}

resource "airtelcloud_public_ip_policy_rule" "this" {
  for_each = {
    for rule in var.policy_rules :
    rule.rule_name => rule
  }

  public_ip_name = airtelcloud_public_ip_attachment.this[0].public_ip_name
  rule_name      = each.value.rule_name
  source         = each.value.source
  services       = each.value.services
  action         = each.value.action
}
