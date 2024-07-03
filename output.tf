output "host-public-ip-address" {
  value = local.equinix_public_network_host_ipv4_no_mask

}

output "router-public-ip-address" {
  value = local.equinix_public_network_router_ipv4_no_mask

}

output "testbox-public-ip-address" {
  value = local.equinix_public_network_test_box_ipv4_no_mask

}

output "k8s_master_ip_mac_hostname_maps" {
  value = local.k8s_master_ip_mac_hostname_map
}
output "k8s_worker_ip_mac_hostname_maps" {
  value = local.k8s_worker_ip_mac_hostname_map
}

output "example_output" {
  value = <<-EOT
    the private key has been generated to output folder and you can SSH the equinix host(username: root) and testbox(testbox) with the private key. 
    The router's default username is vyos and the default password is in the variables.tf. terraform generates the mac/ipv4/ipv6/hostname for the k8s nodes
    where you might need them in the future for k8 installation, you can just use the terraform output mac address for the k8s nodes then they will pick up
    the right IP addresses that we created in the map. There are some pre populated DNS entries for the Openshift platform. please check out the templates/router-user-data.yaml
    to see what has been configured.
  EOT
}
