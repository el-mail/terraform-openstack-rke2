module "controlplane" {
  source           = "../../"
  cluster_name     = var.cluster_name
  write_kubeconfig = true
  image_name       = "Ubuntu 22.04 LTS (jammy)"
  flavor_name      = "Com_A2_DP3"
  boot_from_volume = true
  boot_volume_size = 20
  boot_volume_type = "SAS_HDD_DP3"
  public_net_name  = "pool_16_ip"
  assign_floating_ip = true
  dns_servers      = ["1.1.1.1", "8.8.8.8"]
}
