output "host-public-ip-address" {
  description = "the public IP address of the equinix host"
  value       = local.equinix_public_network_host_ipv4_no_mask

}

output "router-public-ip-address" {
  description = "the public IP address of the router"
  value       = local.equinix_public_network_router_ipv4_no_mask

}

output "testbox-public-ip-address" {
  description = "the public IP address of the testbox"
  value       = local.equinix_public_network_test_box_ipv4_no_mask

}
# the count number will be used to caculate the mac/ipv4/ipv6/hostname etc in local.tf of the nodes so the router can have the static mapping of the nodes,
# that's why we have limited number support
output "k8s_master_ip_mac_hostname_map" {
  description = "k8s masters maps including ipv4/mac/hostname/ipv6"
  value       = local.k8s_master_ip_mac_hostname_map
}
output "k8s_worker_ip_mac_hostname_map" {
  description = "k8s workers maps including ipv4/mac/hostname/ipv6"
  value       = local.k8s_worker_ip_mac_hostname_map
}


output "ssh_public_key_file_path" {
  description = "public key file path for this project"
  value       = local_file.public_key_file.filename

}

output "ssh_private_key_file_path" {
  description = "private key file path for this project"
  value       = local_file.private_key_file.filename

}

output "router_password" {
  description = "The login password for vyos."
  value = var.router_password

}
output "private_network_ipv4_cidr" {
  description = "the private network IPv4 cidr block for VMs, only /24 is supported for now"
  value =       var.private_network_ipv4_cidr

}

output "private_network_ipv6_cidr" {
  description = "the private network IPv6 cidr block for VMs, and only /112 is supported for now"
  value = var.private_network_ipv6_cidr
}


output "dns_base_domain" {
  description = "base domain for the LAN network so the k8s nodes can get unique the FQDN name and resolved by the router"
  value = var.dns_base_domain
}

output "k8s_cluster_name" {
  description = "this will be used to create the FQDN name in the DNS record to follow the OCP guide(https://docs.openshift.com/container-platform/4.11/installing/installing_bare_metal/installing-bare-metal.html#installation-dns-user-infra-example_installing-bare-metal)"
  value = var.k8s_cluster_name

}

output "k8s_master_count" {
  description = "number of master nodes, and we only support numbers 1 or 3 for now"
  value = var.k8s_master_count
}
output "k8s_worker_count" {
  description = "number of worker nodes, and we only support numbers less than 9 for now"
  value = var.k8s_worker_count
}

output "libvirt_public_network_id" {
  description = "libvirt public network id"
  value = libvirt_network.public_network.id
  
}
output "libvirt_private_network_id" {
  description = "libvirt private network id"
  value = libvirt_network.private_network.id
  
}


output "libvirt_pool_main_id" {
  description = "libvirt_pool_main_id"
  value = libvirt_pool.main.id
  
}