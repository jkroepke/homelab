locals {
  nodes_worker = {for k, v in {
    1: {},
    2: {},
    3: {},
  }: "worker${k}" => {
    availability_zone = var.availability_zones[(k - 1) % length(var.availability_zones)],
    subnet_id         = aws_subnet.subnet[
      var.availability_zones[(k - 1) % length(var.availability_zones)]
    ].id,
  }}
}



resource "aws_instance" "worker" {
  for_each = local.nodes_worker

  // e2-standard-2
  ami               = data.aws_ami.ubuntu2004.id
  instance_type     = lookup(each.value, "instance_type", "t3a.large")
  availability_zone = each.value.availability_zone
  subnet_id         = each.value.subnet_id

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh.key_name

  iam_instance_profile = aws_iam_instance_profile.kubernetes-worker.name

  vpc_security_group_ids = [
    aws_security_group.external.id,
    aws_security_group.internal.id
  ]

  ebs_optimized = true

  // ip forward
  source_dest_check = false

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 200
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      user_data_base64,
    ]
  }


  tags = {
    Name = "${var.name}-${each.key}"
    project = var.name

    "worker" = "true"

    "kubernetes.io/cluster/${var.name}" = "owned"

    kubernetes_pod_cidr = cidrsubnet(var.kubernetes_cluster_cidr_block, 8, replace(each.key, "worker", "") - 1)
  }
}
