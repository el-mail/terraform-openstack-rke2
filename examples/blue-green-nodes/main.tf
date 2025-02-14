module "controlplane" {
  source           = "git::https://github.com/el-mail/terraform-openstack-rke2"
  cluster_name     = var.cluster_name
  nodes_count      = 3
  write_kubeconfig = true
  image_name       = "Ubuntu 22.04 LTS (jammy)"
  flavor_name      = "Com_A2_DP3"
  boot_from_volume = true
  boot_volume_size = 20
  boot_volume_type = "SAS_HDD_DP3"
  public_net_name  = "pool_16_ip"
  rke2_config      = file("server.yaml")
  manifests_path   = "./manifests"
  dns_servers      = ["1.1.1.1", "8.8.8.8"]
}

module "blue_node" {
  source      = "git::https://github.com/el-mail/terraform-openstack-rke2//modules/agent"
  image_name       = "Ubuntu 22.04 LTS (jammy)"
  nodes_count      = 1
  name_prefix      = "blue"
  flavor_name      = "Com_A2_DP3"
  boot_from_volume = true
  boot_volume_size = 20
  boot_volume_type = "SAS_HDD_DP3"
  node_config      = module.controlplane.node_config
  rke2_config = templatefile("${path.module}/agent.yaml.tpl", {
    app_name = "blue"
  })
}

module "green_node" {
  source      = "git::https://github.com/el-mail/terraform-openstack-rke2//modules/agent"
  image_name       = "Ubuntu 22.04 LTS (jammy)"
  nodes_count      = 1
  name_prefix      = "green"
  flavor_name      = "Com_A2_DP3"
  boot_from_volume = true
  boot_volume_size = 20
  boot_volume_type = "SAS_HDD_DP3"
  node_config      = module.controlplane.node_config
  rke2_config = templatefile("${path.module}/agent.yaml.tpl", {
    app_name = "green"
  })
}

output "controlplane_floating_ip" {
  value     = module.controlplane.floating_ip
  sensitive = true
}
