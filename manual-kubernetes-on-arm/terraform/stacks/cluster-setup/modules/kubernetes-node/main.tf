module "user_data" {
  source = "./modules/user_data"

  name               = "${var.cluster_name}-node"
  kubernetes_version = var.kubernetes_version
  files              = var.files
}
