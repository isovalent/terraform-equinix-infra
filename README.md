## Overall

This module will deploy the baremetal server in Equinix metal, and this baremetal server will be used as the hypervisor for the VMs. 

On top of the this hypervisor, it will create 2 virtual networks(public and private) and 2 VMs(router and the testbox).

The public virtual network will be in the same physical public network with the hyperviosr where it can get the public IP address and use the Equinix gateway as the next-hop to access the Internet. Baremetal hypervisor, router and testbox will have the public IP address for you to access them through the Internet

In the private virtual network, the router works as the ipv4/ipv6 L3 gateway/DHCP/DNS server for the private network where you can deploy more VMs in the private networks for your further k8s cluster deployment. The testbox also has the interface in this network to receive the IP address from the DHCP server for test purpose.

We require you to input the mac address prefix,hostname prefix and nodes counts for k8s nodes info in this module because we will populate the staitc DHCP mappingg, the FQDN name and HA proxy config for the k8s nodes in the DHCP/DNS server and HA proxy. When you deploy your k8s nodes, you can just use the MAC address from the output from this module so you can have the relaible IP address from the DHCP server.

## Notes
* the router will source NAT the virtual network traffic to its public IP address to help the virtual private network VM to access the Internet.
* the router will forward the 6443/443/80 traffic from the its public/private interfaces to the k8s masters(6443)/workers(443/80) nodes.
* all the VMs in the private network will receive the ipv4/ipv6 address.
* Testbox is using the KVM VM ubuntu image so the kernel config can be different from the vanilla ubuntu.
## Output of this modules
After running this module, the private key will be generated to output folder and you can SSH the equinix host(username: root) and testbox(testbox) with the private key. The router's default username is vyos and the default password is in the variables.tf. There are some pre populated DNS entries/HA proxy setup for the Openshift platform. please check out the templates/router-user-data.yam to see what has been configured.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.6.5 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | >=1.39 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.7.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | >=1.39 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | >=0.7.6 |
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
| [local_file.public_key_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
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
| <a name="output_dns_base_domain"></a> [dns\_base\_domain](#output\_dns\_base\_domain) | base domain for the LAN network so the k8s nodes can get unique the FQDN name and resolved by the router |
| <a name="output_host-public-ip-address"></a> [host-public-ip-address](#output\_host-public-ip-address) | the public IP address of the equinix host |
| <a name="output_k8s_cluster_name"></a> [k8s\_cluster\_name](#output\_k8s\_cluster\_name) | this will be used to create the FQDN name in the DNS record to follow the OCP guide(https://docs.openshift.com/container-platform/4.11/installing/installing_bare_metal/installing-bare-metal.html#installation-dns-user-infra-example_installing-bare-metal) |
| <a name="output_k8s_master_count"></a> [k8s\_master\_count](#output\_k8s\_master\_count) | number of master nodes, and we only support numbers 1 or 3 for now |
| <a name="output_k8s_master_ip_mac_hostname_map"></a> [k8s\_master\_ip\_mac\_hostname\_map](#output\_k8s\_master\_ip\_mac\_hostname\_map) | k8s masters maps including ipv4/mac/hostname/ipv6 |
| <a name="output_k8s_worker_count"></a> [k8s\_worker\_count](#output\_k8s\_worker\_count) | number of worker nodes, and we only support numbers less than 9 for now |
| <a name="output_k8s_worker_ip_mac_hostname_map"></a> [k8s\_worker\_ip\_mac\_hostname\_map](#output\_k8s\_worker\_ip\_mac\_hostname\_map) | k8s workers maps including ipv4/mac/hostname/ipv6 |
| <a name="output_libvirt_pool_main_name"></a> [libvirt\_pool\_main\_name](#output\_libvirt\_pool\_main\_name) | libvirt\_pool\_main\_name |
| <a name="output_libvirt_private_network_id"></a> [libvirt\_private\_network\_id](#output\_libvirt\_private\_network\_id) | libvirt private network id |
| <a name="output_libvirt_public_network_id"></a> [libvirt\_public\_network\_id](#output\_libvirt\_public\_network\_id) | libvirt public network id |
| <a name="output_private_network_ipv4_cidr"></a> [private\_network\_ipv4\_cidr](#output\_private\_network\_ipv4\_cidr) | the private network IPv4 cidr block for VMs, only /24 is supported for now |
| <a name="output_private_network_ipv6_cidr"></a> [private\_network\_ipv6\_cidr](#output\_private\_network\_ipv6\_cidr) | the private network IPv6 cidr block for VMs, and only /112 is supported for now |
| <a name="output_router-public-ip-address"></a> [router-public-ip-address](#output\_router-public-ip-address) | the public IP address of the router |
| <a name="output_router_password"></a> [router\_password](#output\_router\_password) | The login password for vyos. |
| <a name="output_ssh_private_key_file_path"></a> [ssh\_private\_key\_file\_path](#output\_ssh\_private\_key\_file\_path) | private key file path for this project |
| <a name="output_ssh_public_key_file_path"></a> [ssh\_public\_key\_file\_path](#output\_ssh\_public\_key\_file\_path) | public key file path for this project |
| <a name="output_testbox-public-ip-address"></a> [testbox-public-ip-address](#output\_testbox-public-ip-address) | the public IP address of the testbox |
<!-- END_TF_DOCS -->