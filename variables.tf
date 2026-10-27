variable "object_name" {
  description = "Public IP reservation name. Used by attachment and policy rules."
  type        = string

  validation {
    condition     = length(trim(var.object_name, " ")) > 0
    error_message = "object_name cannot be empty."
  }
}

variable "availability_zone" {
  description = "Availability zone for the reservation (for example S1 or S2)."
  type        = string

  validation {
    condition     = length(trim(var.availability_zone, " ")) > 0
    error_message = "availability_zone cannot be empty."
  }
}

variable "description" {
  description = "Optional description stored with the reservation. Forces replacement if changed."
  type        = string
  default     = null
}

variable "resource_type" {
  description = "Workload type to attach to: vm, lb, or baremetal. Null skips attachment."
  type        = string
  default     = null

  validation {
    condition     = var.resource_type == null || contains(["vm", "lb", "baremetal", "compute", "instance", "virtual_machine", "load_balancer", "loadbalancer", "bare_metal", "bm"], var.resource_type)
    error_message = "resource_type must be a provider-supported alias of vm, lb, or baremetal."
  }
}

variable "resource_name" {
  description = "Name of the VM, load balancer, or baremetal server to attach. Null skips attachment."
  type        = string
  default     = null
}

variable "target_vip" {
  description = "Required when resource_type is lb: the load balancer VIP. Do not set for vm or baremetal."
  type        = string
  default     = null
}

variable "policy_rules" {
  description = "NAT policy rules. Parent public IP must be attached (resource_type and resource_name set)."
  type = list(object({
    rule_name = string
    source    = string
    services  = list(string)
    action    = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.policy_rules :
      length(trim(r.rule_name, " ")) > 0
    ])
    error_message = "rule_name cannot be empty."
  }

  validation {
    condition = alltrue([
      for r in var.policy_rules :
      length(trim(r.source, " ")) > 0
    ])
    error_message = "source cannot be empty."
  }

  validation {
    condition = alltrue([
      for r in var.policy_rules :
      length(r.services) > 0
    ])
    error_message = "At least one service must be specified."
  }

  validation {
    condition = alltrue([
      for r in var.policy_rules :
      contains(["accept", "deny"], r.action)
    ])
    error_message = "action must be accept or deny."
  }
}
