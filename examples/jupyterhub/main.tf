module "controlplane" {
  source           = "git::https://github.com/el-mail/terraform-openstack-rke2"
  cluster_name     = var.cluster_name
  write_kubeconfig = true
  image_name       = "ubuntu-20.04-focal-x86_64"
  flavor_name      = "genX1"
  public_net_name  = "dmz"
  rke2_config      = file("server.yaml")
  manifests_path   = "./manifests"
  # Fix for https://github.com/rancher/rke2/issues/1113
  additional_san = ["kubernetes.default.svc"]
}

module "worker" {
  source      = "git::https://github.com/el-mail/terraform-openstack-rke2//modules/agent"
  image_name  = "ubuntu-20.04-focal-x86_64"
  nodes_count = 2
  name_prefix = "worker"
  flavor_name = "genX1"
  node_config = module.controlplane.node_config
}
