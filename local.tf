locals {
  libvirt_host_user       = "root"
  image_download_base_url = "https://storage.googleapis.com/isovalent-cs-team/images"
  testbox_base_image_url  = "${local.image_download_base_url}/jammy-server-cloudimg-amd64-disk-kvm.img"
  # have to use 1.4 rolling image for the srv6 since 1.3.4 uses FRR 7.5 and 1.4 is using FRR 9.0
  router_base_image_url = "${local.image_download_base_url}/vyos-1.4-rolling.qcow2"


  equinix_public_network_subnet_ipv4           = equinix_metal_reserved_ip_block.public_ip_block.cidr_notation
  equinix_public_network_gateway_ipv4          = equinix_metal_reserved_ip_block.public_ip_block.gateway
  equinix_public_network_host_ipv4_no_mask     = cidrhost(local.equinix_public_network_subnet_ipv4, 2)
  equinix_public_network_host_ipv4             = "${local.equinix_public_network_host_ipv4_no_mask}/${equinix_metal_reserved_ip_block.public_ip_block.cidr}"
  equinix_public_network_router_ipv4_no_mask   = cidrhost(local.equinix_public_network_subnet_ipv4, 3)
  equinix_public_network_router_ipv4           = "${local.equinix_public_network_router_ipv4_no_mask}/${equinix_metal_reserved_ip_block.public_ip_block.cidr}"
  equinix_public_network_test_box_ipv4_no_mask = cidrhost(local.equinix_public_network_subnet_ipv4, 4)
  equinix_public_network_test_box_ipv4         = "${local.equinix_public_network_test_box_ipv4_no_mask}/${equinix_metal_reserved_ip_block.public_ip_block.cidr}"

  private_network_ipv4_cidr_no_mask           = split("/", var.private_network_ipv4_cidr)[0]
  private_network_ipv4_cidr_mask              = split("/", var.private_network_ipv4_cidr)[1]
  private_network_ipv4_netmask                = cidrnetmask(var.private_network_ipv4_cidr)
  private_network_router_ipv4_no_mask         = cidrhost(var.private_network_ipv4_cidr, 1)
  private_network_router_ipv4                 = "${local.private_network_router_ipv4_no_mask}/${local.private_network_ipv4_cidr_mask}"
  private_network_first_ip_address_last_octet = 50
  private_network_last_ip_address_last_octet  = 200
  dhcp_vm_node_cidr_first_ipv4_address        = cidrhost(var.private_network_ipv4_cidr, local.private_network_first_ip_address_last_octet)
  dhcp_vm_node_cidr_last_ipv4_address         = cidrhost(var.private_network_ipv4_cidr, local.private_network_last_ip_address_last_octet)

  private_network_ipv6_cidr_no_mask    = split("/", var.private_network_ipv6_cidr)[0]
  private_network_ipv6_network_mask    = split("/", var.private_network_ipv6_cidr)[1]
  private_network_router_ipv6_no_mask  = cidrhost(var.private_network_ipv6_cidr, 1)
  private_network_router_ipv6          = "${local.private_network_router_ipv6_no_mask}/${local.private_network_ipv6_network_mask}"
  dhcp_vm_node_cidr_first_ipv6_address = cidrhost(var.private_network_ipv6_cidr, local.private_network_first_ip_address_last_octet)
  dhcp_vm_node_cidr_last_ipv6_address  = cidrhost(var.private_network_ipv6_cidr, local.private_network_last_ip_address_last_octet)

  # use 20-30 for k8s masters ipv4/ipv6 address
  k8s_master_ip_mac_hostname_map = zipmap(
    [for i in range(var.k8s_master_count) : i],
    [for i in range(var.k8s_master_count) : [cidrhost(var.private_network_ipv4_cidr, 20 + i), "${var.k8s_master_mac_prefix}${i}", "${var.k8s_master_hostname_prefix}${i}", cidrhost(var.private_network_ipv6_cidr, 32 + i)]]
  )
  # use 30-40 for k8s worker ipv4/ipv6 address

  k8s_worker_ip_mac_hostname_map = zipmap(
    [for i in range(var.k8s_worker_count) : i],
    [for i in range(var.k8s_worker_count) : [cidrhost(var.private_network_ipv4_cidr, 30 + i), "${var.k8s_worker_mac_prefix}${i}", "${var.k8s_worker_hostname_prefix}${i}", cidrhost(var.private_network_ipv6_cidr, 48 + i)]]
  )
}