## Airtel Cloud Public IP Terraform Module

Terraform module for provisioning Airtel Cloud Public IPs and associated Policy Rules.

## Features

- Creates Public IPs
- Supports NAT mapping to VM or Load Balancer private IPs
- Supports Public IP Policy Rules
- Supports multiple policy rules
- Exposes Public IP outputs for downstream modules

## Usage

### Basic Example

```hcl
module "public_ip" {
  source = "Airtel-Cloud-Platform/public-ip/airtelcloud"

  object_name       = "web-public-ip"
  vip               = "10.1.99.172"
  availability_zone = "S1"
}
```

### Complete Example

```hcl
module "public_ip" {
  source = "Airtel-Cloud-Platform/public-ip/airtelcloud"

  object_name       = "web-public-ip"
  vip               = "10.1.99.172"
  availability_zone = "S1"

  policy_rules = [
    {
      display_name = "web-traffic"
      source       = "any"
      services     = ["HTTP", "HTTPS"]
      action       = "accept"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| object_name | Public IP object name | string | Yes |
| vip | Private IP to NAT against | string | Yes |
| availability_zone | Availability Zone | string | Yes |
| policy_rules | Public IP policy rules | list(object) | No |

## Policy Rule Object

| Name | Type | Required |
|------|------|----------|
| display_name | string | Yes |
| source | string | Yes |
| services | list(string) | Yes |
| action | string | Yes |

## Outputs

| Name | Description |
|------|-------------|
| public_ip_id | Public IP ID |
| public_ip_address | Allocated Public IP |
| public_ip_status | Public IP Status |
| public_ip | Complete Public IP Object |

## Notes

Policy rules are optional.

If no policy rules are provided, only the Public IP resource will be created.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| airtelcloud Provider | >= 1.0.4 |
