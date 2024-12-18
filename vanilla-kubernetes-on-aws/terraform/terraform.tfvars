name               = "joe-k8s-sandbox"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
vpc_cidr_block     = "10.240.0.0/16"
root_dns_zone      = "adorsys-sandbox.aws.adorsys.de"

versions = {
  ubuntu = "focal"

  # https://github.com/cri-o/cri-o/tags
  cri-o = "1.19.0"

  # https://github.com/kubernetes/kubernetes/tags
  kubernetes = "1.19.4"

  # https://github.com/kubernetes/kubernetes/blob/release-1.19/cmd/kubeadm/app/constants/constants.go#L429
  etcd = "3.4.13-0"
}

kubernetes = {
  api_hostname       = "joe-k8s-sandbox.adorsys-sandbox.aws.adorsys.de"
  service_cidr_block = "172.30.0.0/16"
  pod_cidr_block     = "10.128.0.0/14"
  feature_gates = [
    "CSINodeInfo=true",
    "CSIDriverRegistry=true",
    "CSIBlockVolume=true",
    "CSIMigration=true",
    "CSIMigrationAWS=true",
    "CSIMigrationAWSComplete=true",
    "EphemeralContainers=true",
  ]
}
