locals {
  version_metrics_server               = "3.8.2"
  version_aws_load_balancer_controller = "1.4.1"
  version_external_dns                 = "1.7.1"
  version_node_problem_detector        = "2.2.0"
  version_aws_node_termination_handler = "0.18.0"
  version_aws_ebs_csi_driver           = "2.6.4"
  # https://github.com/prometheus-community/helm-charts/blob/e02b5a3d69f25a45650eccfaceade4f42a541f7e/charts/kube-prometheus-stack/Chart.yaml#L26
  version_kube_prometheus_stack = "34.9.0"
}


module "metrics-server" {
  source = "./modules/metrics-server"

  chart_version = local.version_metrics_server
}

module "aws-load-balancer-controller" {
  source = "./modules/aws-load-balancer-controller"

  cluster_name          = var.cluster_name
  kubernetes_api_server = var.kubernetes_api_server
  chart_version         = local.version_aws_load_balancer_controller
}

module "external-dns" {
  source = "./modules/external-dns"

  cluster_name          = var.cluster_name
  kubernetes_api_server = var.kubernetes_api_server
  chart_version         = local.version_external_dns
}

module "kube-prometheus-stack" {
  source = "./modules/kube-prometheus-stack"

  chart_version = local.version_kube_prometheus_stack
}

module "node-problem-detector" {
  source = "./modules/node-problem-detector"

  chart_version = local.version_node_problem_detector
}

module "aws-node-termination-handler" {
  source = "./modules/aws-node-termination-handler"

  chart_version = local.version_aws_node_termination_handler
}

module "aws-ebs-csi-driver" {
  source = "./modules/aws-ebs-csi-driver"

  cluster_name          = var.cluster_name
  kubernetes_api_server = var.kubernetes_api_server
  chart_version         = local.version_aws_ebs_csi_driver
}
