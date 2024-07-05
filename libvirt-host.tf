
data "equinix_metal_project" "demos" {
  name = var.equinix_metal_project
}


# we use the /29 for public IP address here to match what we ask for 8 ip address in equinix_metal_reserved_ip_block
resource "equinix_metal_reserved_ip_block" "public_ip_block" {
  project_id  = data.equinix_metal_project.demos.project_id
  metro       = var.metro
  quantity    = 8
  description = "public IP address block for ${var.infra_name}"

}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_file" {
  filename        = "${path.module}/output/${var.infra_name}_id_rsa"
  content         = tls_private_key.private_key.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key_file" {
  filename        = "${path.module}/output/${var.infra_name}_id_rsa.pub"
  content         = tls_private_key.private_key.public_key_openssh
  file_permission = "0600"
}


resource "equinix_metal_project_ssh_key" "public_key" {
  name       = "${var.infra_name}-pub-key"
  public_key = tls_private_key.private_key.public_key_openssh
  project_id = data.equinix_metal_project.demos.project_id
}

resource "equinix_metal_device" "libvirt_host" {
  billing_cycle       = "hourly"
  hostname            = "${var.infra_name}-host"
  metro               = var.metro
  operating_system    = "debian_12"
  plan                = var.server_type
  project_id          = data.equinix_metal_project.demos.project_id
  project_ssh_key_ids = [equinix_metal_project_ssh_key.public_key.id]

  ip_address {
    type            = "public_ipv4"
    cidr            = 29
    reservation_ids = [equinix_metal_reserved_ip_block.public_ip_block.id]

  }
  ip_address {
    type = "private_ipv4"
    cidr = 29
  }

}

resource "null_resource" "libvirt_host_provisioner" {

  connection {
    host        = equinix_metal_device.libvirt_host.access_public_ipv4
    user        = local.libvirt_host_user
    private_key = tls_private_key.private_key.private_key_openssh
    timeout     = "5m"
    type        = "ssh"
  }


  provisioner "remote-exec" {
    script = "${path.module}/scripts/libvirt-host-provisioner.sh"
  }

}
# this is a hack to enforce the libvirt provider will be called after we create the host
resource "local_file" "host-username" {
  depends_on = [null_resource.libvirt_host_provisioner]
  filename   = "${path.module}/hack/host-username"
  content    = "root"
}