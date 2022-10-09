locals {
  nodes_controller = { for k, v in {
    1 : {},
    2 : {},
    3 : {},
    } : "controller${k}" => {
    availability_zone = var.availability_zones[(k - 1) % length(var.availability_zones)],
    subnet_id = aws_subnet.subnet[
      var.availability_zones[(k - 1) % length(var.availability_zones)]
    ].id,
  } }
}



resource "aws_instance" "controller" {
  for_each = local.nodes_controller

  // e2-standard-2
  ami               = data.aws_ami.ubuntu2004.id
  instance_type     = lookup(each.value, "instance_type", "t3a.large")
  availability_zone = each.value.availability_zone
  subnet_id         = each.value.subnet_id

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh.key_name

  iam_instance_profile = aws_iam_instance_profile.kubernetes-controller.name

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
    Name    = "${var.name}-${each.key}"
    project = var.name

    "controller" = "true"

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}
