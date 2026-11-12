module "public_ip" {
  source = "../../"

  object_name       = "web-public-ip"
  description       = "public IP for the web tier"
  availability_zone = "S1"

  resource_type = "vm"
  resource_name = "web-1"

  policy_rules = [
    {
      rule_name = "web-traffic"
      source    = "any"
      services  = ["HTTP", "HTTPS"]
      action    = "accept"
    },
    {
      rule_name = "ssh-access"
      source    = "10.0.0.0/8"
      services  = ["SSH"]
      action    = "accept"
    }
  ]
}
