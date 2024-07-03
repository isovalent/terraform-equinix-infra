terraform {
  required_version = ">=1.6.5"
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">=1.39"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">=0.7.6"
    }

  }
}