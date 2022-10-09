resource "aws_security_group" "worker" {
  name   = "${var.name}-worker"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
    for_each = {
      179 : { protocol : "tcp", description : "Calico networking (BGP)" },
      9100 : { protocol : "tcp", description : "Prometheus: node_exporter" },
      9620 : { protocol : "tcp", description : "Prometheus: kiam" },
      10249 : { protocol : "tcp", description : "Prometheus: kube-proxy" },
      10250 : { protocol : "tcp", description : "Prometheus: kubelet" },
    }

    content {
      description = ingress.value.description

      from_port = ingress.key
      protocol  = ingress.value.protocol
      to_port   = ingress.value.protocol == "icmp" ? 0 : ingress.key

      security_groups = [aws_security_group.controller.id]
    }
  }

  dynamic "ingress" {
    # https://docs.projectcalico.org/getting-started/kubernetes/requirements#network-requirements
    for_each = {
      179 : { protocol : "tcp", description : "Calico networking (BGP)" },
    }

    content {
      description = ingress.value.description

      from_port = ingress.key
      protocol  = ingress.value.protocol
      to_port   = ingress.value.protocol == "icmp" ? 0 : ingress.key

      self = true
    }
  }

  # https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
  # IPIP
  ingress {
    from_port = 0
    protocol  = 4
    to_port   = 0

    self = true
  }

  # IPv6IPv6
  ingress {
    from_port = 0
    protocol  = 41
    to_port   = 0

    self = true
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
