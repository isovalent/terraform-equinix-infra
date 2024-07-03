provider "equinix" {
  auth_token = var.api_key
}
# we have a hack to enforce the provider will be created after the host in libvirt-host.tf
provider "libvirt" {
  uri = "qemu+ssh://${local_file.host-username.content}@${equinix_metal_device.libvirt_host.network.0.address}/system?sshauth=privkey&known_hosts_verify=ignore&keyfile=${local_file.private_key_file.filename}"
}
