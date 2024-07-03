output "host-public-ip-address" {
  description = "the public IP address of the equinix host"
  value = local.equinix_public_network_host_ipv4_no_mask

}

output "router-public-ip-address" {
  description = "the public IP address of the router between public and private network"
  value = local.equinix_public_network_router_ipv4_no_mask

}

output "testbox-public-ip-address" {
  description = "the public IP address of the testbox"
  value = local.equinix_public_network_test_box_ipv4_no_mask

}

output "k8s_master_ip_mac_hostname_maps" {
  description = "the public IP address of the testbox"
  value = local.k8s_master_ip_mac_hostname_map
}
output "k8s_worker_ip_mac_hostname_maps" {
  value = local.k8s_worker_ip_mac_hostname_map
}
