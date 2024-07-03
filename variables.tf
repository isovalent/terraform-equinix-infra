variable "api_key" {
  description = "The Equinix API key."
  sensitive   = true
  type        = string
}

variable "equinix_metal_project" {
  description = "The Equinix project to use."
  type        = string
  default     = "Demos"
}

variable "metro" {
  description = "The Equinix metro to use."
  type        = string
  default     = "ny"
}

variable "infra_name" {
  description = "The name of the equinix metal infrastructure."
  type        = string
}

variable "server_type" {
  description = "The server type to use."
  type        = string
  default     = "m3.small.x86"
}

variable "router_password" {
  description = "The login password for vyos."
  type        = string
  default     = "R0uter123!"

}
variable "private_network_ipv4_cidr" {
  description = "the private network IPv4 cidr block for VMs, only /24 is supported for now"
  type        = string
  default     = "192.168.1.0/24"
  validation {
    condition     = can(regex("\\/24$", var.private_network_ipv4_cidr))
    error_message = "please use ipv4 network with /24"
  }

}

variable "private_network_ipv6_cidr" {
  description = "the private network IPv6 cidr block for VMs, and only /112 is supported for now"
  type        = string
  default     = "fd03::/112"
  validation {
    condition     = can(regex("\\/112$", var.private_network_ipv6_cidr))
    error_message = "please use ipv6 network with /112"
  }
}


variable "dns_base_domain" {
  description = "base domain for the LAN network so the k8s nodes can get unique the FQDN name and resolved by the router"
  type        = string
  default     = "local"

}

variable "k8s_cluster_name" {
  description = "this will be used to create the FQDN name in the DNS record to follow the OCP guide(https://docs.openshift.com/container-platform/4.11/installing/installing_bare_metal/installing-bare-metal.html#installation-dns-user-infra-example_installing-bare-metal)"
  type        = string
  default     = "liyi-test"

}

# the count number will be used to caculate the mac/ipv4/ipv6/hostname etc in local.tf of the nodes so the router can have the static mapping of the nodes,
# that's why we have limited number support

variable "k8s_master_hostname_prefix" {
  description = "prefix hostname of the master nodes"
  type        = string
  default     = "k8s-masters"

}

variable "k8s_master_mac_prefix" {
  description = "prefix mac address of the master nodes"
  type        = string
  default     = "52:54:00:aa:bb:a"
  validation {
    condition     = can(regex("(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]$", var.k8s_master_mac_prefix))
    error_message = "please use this format aa:bb:cc:dd:ee:ff:a as the prefix"

  }
}

variable "k8s_master_count" {
  description = "number of master nodes, and we only support numbers 1 or 3 for now"
  type        = number
  default     = "3"
  validation {
    condition     = var.k8s_master_count == 1 || var.k8s_master_count == 3
    error_message = "please use 1 or 3"
  }
}


variable "k8s_worker_hostname_prefix" {
  description = "prefix hostname of the worker nodes"
  type        = string
  default     = "k8s-workers"

}

variable "k8s_worker_mac_prefix" {
  description = "prefix mac address of the worker nodes"
  type        = string
  default     = "52:54:00:aa:bb:b"

  validation {
    condition     = can(regex("(?:[0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]$", var.k8s_worker_mac_prefix))
    error_message = "please use this format aa:bb:cc:dd:ee:ff:a as the prefix"

  }
}

variable "k8s_worker_count" {
  description = "number of worker nodes, and we only support numbers less than 9 for now"
  type        = number
  default     = "2"
  validation {
    condition     = var.k8s_worker_count <= 9 && var.k8s_worker_count >= 1
    error_message = "please use a number between 1 and 9"
  }
}
