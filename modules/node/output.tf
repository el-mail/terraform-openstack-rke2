output "floating_ip" {
  value = openstack_compute_floatingip_associate_v2.associate_floating_ip[*].floating_ip
}

output "internal_ip" {
  value = openstack_compute_instance_v2.instance[*].access_ip_v4
}

output "public_address" {
  value = var.assign_floating_ip ? openstack_networking_floatingip_v2.floating_ip[*].address : openstack_networking_port_v2.port[*].all_fixed_ips[0]
}
