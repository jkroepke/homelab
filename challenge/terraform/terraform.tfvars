name = "joe-k8s-sandbox"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
vpc_cidr_block = "10.240.0.0/16"

versions = {
  coreos = "32"
  ubuntu = "focal"

  kubernetes = "1.19.3"
  cri-o = "1.19"
}

kubernetes = {
  public_hostname = "joe-k8s-sandbox.adorsys-sandbox.aws.adorsys.de"
  service_cidr_block = "10.32.0.0/16"
  pod_cidr_block = "10.200.0.0/16"
}
