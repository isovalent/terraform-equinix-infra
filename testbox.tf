resource "libvirt_volume" "testbox_base" {
  depends_on = [libvirt_domain.router]
  name       = "testbox-base"
  source     = local.testbox_base_image_url
  pool       = libvirt_pool.main.name
  format     = "qcow2"
}

// The root volume for the testbox.
resource "libvirt_volume" "testbox" {
  depends_on     = [libvirt_pool.main]
  base_volume_id = libvirt_volume.testbox_base.id
  format         = "qcow2"
  name           = "testbox-${md5(libvirt_cloudinit_disk.testbox.user_data)}.qcow2"
  size           = 10000000000
  pool           = libvirt_pool.main.name
}

resource "libvirt_cloudinit_disk" "testbox" {
  meta_data = templatefile("${path.module}/templates/testbox-meta-data.yaml", {})
  name      = "testbox.iso"
  network_config = templatefile("${path.module}/templates/testbox-network-config.yaml", {
    public_test_box_ipv4_address = local.equinix_public_network_test_box_ipv4
    public_gateway_ip            = local.equinix_public_network_gateway_ipv4
  })
  pool = libvirt_pool.main.name
  user_data = templatefile("${path.module}/templates/testbox-user-data.yaml", {
    name                                = "testbox",
    private_network_router_ipv4_no_mask = local.private_network_router_ipv4_no_mask
    private_ssh_key                     = base64encode(tls_private_key.private_key.private_key_openssh)
    public_ssh_keys = jsonencode([
      tls_private_key.private_key.public_key_openssh
    ])
  })
}

// The testbox VM.
resource "libvirt_domain" "testbox" {
  autostart = true
  cloudinit = libvirt_cloudinit_disk.testbox.id
  memory    = 2048
  name      = "testbox"
  vcpu      = 2

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  disk {
    volume_id = libvirt_volume.testbox.id
  }

  graphics {
    listen_type = "address"
  }

  network_interface {
    bridge = "br0" # hardcode the bridege name than the network_id to prevent the terraform keep changing network_id to the bridge name
    # network_id     = libvirt_network.public_network.id
    wait_for_lease = false
  }

  network_interface {
    network_id     = libvirt_network.private_network.id
    wait_for_lease = false
  }
}

