<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.5 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.5 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >=1.39 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >=1.39 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.7.6 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.7.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >=1.39 >=1.39 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | >=0.7.6 >=0.7.6 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_device.libvirt_host](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_device) | resource |
| [equinix_metal_project_ssh_key.public_key](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_project_ssh_key) | resource |
| [equinix_metal_reserved_ip_block.public_ip_block](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/metal_reserved_ip_block) | resource |
| [libvirt_cloudinit_disk.router](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit_disk) | resource |
| [libvirt_cloudinit_disk.testbox](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.router](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_domain.testbox](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_network.private_network](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/network) | resource |
| [libvirt_network.public_network](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/network) | resource |
| [libvirt_pool.main](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/pool) | resource |
| [libvirt_volume.router](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.router_base](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.testbox](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.testbox_base](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [local_file.host-username](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.private_key_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.libvirt_host_provisioner](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [equinix_metal_project.demos](https://registry.terraform.io/providers/equinix/equinix/latest/docs/data-sources/metal_project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | The Equinix API key. | `string` | n/a | yes |
| <a name="input_dns_base_domain"></a> [dns\_base\_domain](#input\_dns\_base\_domain) | base domain for the LAN network so the k8s nodes can get unique the FQDN name and resolved by the router | `string` | `"local"` | no |
| <a name="input_equinix_metal_project"></a> [equinix\_metal\_project](#input\_equinix\_metal\_project) | The Equinix project to use. | `string` | `"Demos"` | no |
| <a name="input_infra_name"></a> [infra\_name](#input\_infra\_name) | The name of the equinix metal infrastructure. | `string` | n/a | yes |
| <a name="input_k8s_cluster_name"></a> [k8s\_cluster\_name](#input\_k8s\_cluster\_name) | this will be used to create the FQDN name in the DNS record to follow the OCP guide(https://docs.openshift.com/container-platform/4.11/installing/installing_bare_metal/installing-bare-metal.html#installation-dns-user-infra-example_installing-bare-metal) | `string` | `"liyi-test"` | no |
| <a name="input_k8s_master_count"></a> [k8s\_master\_count](#input\_k8s\_master\_count) | number of master nodes, and we only support numbers 1 or 3 for now | `number` | `"3"` | no |
| <a name="input_k8s_master_hostname_prefix"></a> [k8s\_master\_hostname\_prefix](#input\_k8s\_master\_hostname\_prefix) | prefix hostname of the master nodes | `string` | `"k8s-masters"` | no |
| <a name="input_k8s_master_mac_prefix"></a> [k8s\_master\_mac\_prefix](#input\_k8s\_master\_mac\_prefix) | prefix mac address of the master nodes | `string` | `"52:54:00:aa:bb:a"` | no |
| <a name="input_k8s_worker_count"></a> [k8s\_worker\_count](#input\_k8s\_worker\_count) | number of worker nodes, and we only support numbers less than 9 for now | `number` | `"2"` | no |
| <a name="input_k8s_worker_hostname_prefix"></a> [k8s\_worker\_hostname\_prefix](#input\_k8s\_worker\_hostname\_prefix) | prefix hostname of the worker nodes | `string` | `"k8s-workers"` | no |
| <a name="input_k8s_worker_mac_prefix"></a> [k8s\_worker\_mac\_prefix](#input\_k8s\_worker\_mac\_prefix) | prefix mac address of the worker nodes | `string` | `"52:54:00:aa:bb:b"` | no |
| <a name="input_metro"></a> [metro](#input\_metro) | The Equinix metro to use. | `string` | `"ny"` | no |
| <a name="input_private_network_ipv4_cidr"></a> [private\_network\_ipv4\_cidr](#input\_private\_network\_ipv4\_cidr) | the private network IPv4 cidr block for VMs, only /24 is supported for now | `string` | `"192.168.1.0/24"` | no |
| <a name="input_private_network_ipv6_cidr"></a> [private\_network\_ipv6\_cidr](#input\_private\_network\_ipv6\_cidr) | the private network IPv6 cidr block for VMs, and only /112 is supported for now | `string` | `"fd03::/112"` | no |
| <a name="input_router_password"></a> [router\_password](#input\_router\_password) | The login password for vyos. | `string` | `"R0uter123!"` | no |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | The server type to use. | `string` | `"m3.small.x86"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_example_output"></a> [example\_output](#output\_example\_output) | n/a |
| <a name="output_host-public-ip-address"></a> [host-public-ip-address](#output\_host-public-ip-address) | n/a |
| <a name="output_k8s_master_ip_mac_hostname_maps"></a> [k8s\_master\_ip\_mac\_hostname\_maps](#output\_k8s\_master\_ip\_mac\_hostname\_maps) | n/a |
| <a name="output_k8s_worker_ip_mac_hostname_maps"></a> [k8s\_worker\_ip\_mac\_hostname\_maps](#output\_k8s\_worker\_ip\_mac\_hostname\_maps) | n/a |
| <a name="output_router-public-ip-address"></a> [router-public-ip-address](#output\_router-public-ip-address) | n/a |
| <a name="output_testbox-public-ip-address"></a> [testbox-public-ip-address](#output\_testbox-public-ip-address) | n/a |
<!-- END_TF_DOCS -->