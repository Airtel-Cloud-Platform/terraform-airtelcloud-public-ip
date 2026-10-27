## Airtel Cloud Public IP Terraform Module

Terraform module for reserving an Airtel Cloud Public IP, optionally attaching it to a VM, load balancer, or baremetal server, and creating NAT policy rules.

## Features

- Reserves a Public IP (`airtelcloud_public_ip`)
- Optionally attaches it (`airtelcloud_public_ip_attachment`)
- Optionally creates policy rules (`airtelcloud_public_ip_policy_rule`)
- Exposes Public IP outputs for downstream modules

Reserve, attach, and policy are separate provider resources. Policy rules cannot be created until the address is attached.

## Usage

### Basic Example (reserve only)

```hcl
module "public_ip" {
  source = "Airtel-Cloud-Platform/public-ip/airtelcloud"

  object_name       = "web-public-ip"
  availability_zone = "S1"
}
```

### Complete Example (attach to a VM and allow traffic)

```hcl
module "public_ip" {
  source = "Airtel-Cloud-Platform/public-ip/airtelcloud"

  object_name       = "web-public-ip"
  availability_zone = "S1"

  resource_type = "vm"
  resource_name = "web-1"

  policy_rules = [
    {
      rule_name = "web-traffic"
      source    = "any"
      services  = ["HTTP", "HTTPS"]
      action    = "accept"
    }
  ]
}
```

### Attach to a load balancer

Set `resource_type = "lb"` and `target_vip` to the load balancer VIP. Do not set `target_vip` for `vm` or `baremetal`.

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| object_name | Public IP reservation name | string | Yes |
| availability_zone | Availability zone (for example S1) | string | Yes |
| description | Reservation description | string | No |
| resource_type | Attach to `vm`, `lb`, or `baremetal` | string | No |
| resource_name | Name of the VM, LB, or baremetal server | string | No |
| target_vip | Required for `lb`; omit for `vm`/`baremetal` | string | No |
| policy_rules | NAT policy rules | list(object) | No |

## Policy Rule Object

| Name | Type | Required |
|------|------|----------|
| rule_name | string | Yes |
| source | string | Yes |
| services | list(string) | Yes |
| action | string (`accept` or `deny`) | Yes |

## Outputs

| Name | Description |
|------|-------------|
| public_ip_id | Public IP ID |
| public_ip_address | Allocated public IP |
| public_ip_status | Public IP status |
| public_ip | Reservation attributes |
| vip | Private IP after attach; empty while reserved |
| attachment_id | Attachment ID, or null if not attached |
| policy_rule_ids | Map of rule_name to rule ID |

## Notes

If `resource_type` and `resource_name` are omitted, only the reservation is created.

Policy rules require attachment. `vip` is not a create argument on the public IP resource; it is computed after attach.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| airtelcloud Provider | >= 1.2.6 |
