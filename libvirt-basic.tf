resource "libvirt_network" "public_network" {
  autostart = true
  mode      = "bridge"
  name      = "public_network"
  bridge    = "br0"
  dhcp {
    enabled = false // We'll set the router's networking up manually.
  }

  dns {
    enabled = false // We'll set the router's DNS up manually.
  }
}


resource "libvirt_network" "private_network" {
  autostart = true
  mode      = "none"
  name      = "private_network"


  dhcp {
    enabled = false // DHCP to be handled by the router.
  }

  dns {
    enabled = false // DNS to be handled by the router.
  }
}


// The main storage pool.
resource "libvirt_pool" "main" {
  name = "main"
  path = "/var/lib/libvirt/pools/main"
  type = "dir"
}