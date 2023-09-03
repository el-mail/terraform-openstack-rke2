locals {
  rancher_helm_b64 = base64gzip(templatefile("${path.root}/manifests/ranhcer.helm.yaml.tpl", {
    hostname          = local.hostname
    bootstrapPassword = random_string.rancher_password.result
  }))
}

module "controlplane" {
  source             = "git::https://github.com/el-mail/terraform-openstack-rke2"
  cluster_name       = local.rancher_name
  nodes_count        = 3
  write_kubeconfig   = true
  image_name         = "Ubuntu 22.04 LTS (jammy)"
  flavor_name        = "Com_A2_DP3"
  boot_from_volume   = true
  boot_volume_size   = 20
  boot_volume_type   = "SAS_HDD_DP3"
  public_net_name    = "pool_16_ip"
  assign_floating_ip = true
  dns_servers        = ["1.1.1.1", "8.8.8.8"]
  rke2_config        = file("${path.root}/config/server.yaml")
  manifests_path     = "./manifests/common"
  manifests_gzb64 = {
    "rancher" : local.rancher_helm_b64
  }
}

module "worker_node" {
  source           = "git::https://github.com/el-mail/terraform-openstack-rke2//modules/agent"
  image_name       = "Ubuntu 22.04 LTS (jammy)"
  nodes_count      = 3
  name_prefix      = "worker"
  flavor_name      = "Com_A2_DP3"
  boot_from_volume = true
  boot_volume_size = 20
  boot_volume_type = "SAS_HDD_DP3"
  node_config      = module.controlplane.node_config
}

resource "random_string" "rancher_password" {
  length = 64
}
